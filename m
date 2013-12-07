Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161283Ab3LGAlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:41:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758862Ab3LGAl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:41:26 -0500
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-arch@vger.kernel.org, rostedt@goodmis.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, arnd@arndb.de, rusty@rustcorp.com.au,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 0/5] static_key: deferred key fixes and improvements
Date: Sat,  7 Dec 2013 01:40:01 +0100
Message-Id: <1386376806-924-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is made out of three logical parts
 - patches 1 and 2 fix panic caused by accessing freed module memory
 - patches 3 and 4 fix miscounting by static_key_slow_dec_deferred()
 - patch 5 introduces a minor optimization

More jump_label/static_key patches are prepared, but I returned to them
yesterday and implemented a variable jump length on amd64, which
requires some refactoring, porting to remaining architectures, and
retesting, so I'm posting this independent part before it gets overtaken
by higher priority work again
=> This series was tested with additional patches
^ I wrote this on Tuesday and then moved to higher priority work, but
returned with enough courage to post a different first part.
The first part was tested on amd64, s390x and ppc64, the rest also on
armv7.

Applies to next-20131206 and v3.13-rc3.

Radim Krčmář (5):
  static_key: add a section for deferred keys
  static_key: cancel rate limit timer on rmmod
  static_key: add static_key_slow_inc_deferred()
  static_key: keep deferred enabled counter debt
  static_key: improve deferred inc behavior

 arch/x86/kvm/lapic.c                 | 11 +++++----
 arch/x86/kvm/lapic.h                 |  4 +--
 include/asm-generic/vmlinux.lds.h    |  1 +
 include/linux/jump_label_ratelimit.h | 10 ++++++++
 include/linux/module.h               |  3 +++
 include/linux/perf_event.h           |  2 +-
 kernel/events/core.c                 |  8 +++---
 kernel/jump_label.c                  | 47 +++++++++++++++++++++++++++++++-----
 kernel/module.c                      |  4 +++
 9 files changed, 72 insertions(+), 18 deletions(-)

-- 
1.8.4.2

