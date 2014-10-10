Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaJJRPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 13:15:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbaJJRPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 13:15:47 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH v2 0/2] deadline TSC multi injection fix
Date: Fri, 10 Oct 2014 19:15:07 +0200
Message-Id: <1412961309-16485-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First patch refactors code and introduces a minor should-not-happen
optimization.  Second patch fixes the bug and improves handling of passed
deadline timers.

I still haven't looked at Amit's proposed optimization (not recomputing the
value of hrtimer on rewrites) long enough to be able to sign it off, sorry.

Radim Krčmář (2):
  KVM: x86: add apic_timer_expired()
  KVM: x86: fix deadline tsc interrupt injection

 arch/x86/kvm/lapic.c | 47 +++++++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

-- 
2.1.0

