Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaGKDjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 23:39:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbaGKDjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 23:39:11 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Eric Paris <eparis@redhat.com>, Al Viro <aviro@redhat.com>,
        Will Drewry <wad@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/3] [RFC] X32: fix syscall_get_nr while not breaking seccomp BPF
Date: Thu, 10 Jul 2014 23:38:11 -0400
Message-Id: <cover.1405023592.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set reverts commit 8b4b9f2 which broke audit and potentially other users
of syscall_get_nr() which depend on that call as named without being overloaded
by architecture bits.  It will satisfy other regular users of syscall_get_nr()
and syscall_get_arch() without changing the seccomp interface to BPF.

A new ARCH definition, AUDIT_ARCH_X86_X32, was added for syscall_get_arch().

Cc: Paul Moore <pmoore@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <aviro@redhat.com>
Cc: Will Drewry <wad@chromium.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Link: http://lkml.kernel.org/r/cover.1405023592.git.rgb@redhat.com

Richard Guy Briggs (3):
  audit: add AUDIT_ARCH_X86_X32 arch definition
  seccomp: give BPF x32 bit when restoring x32 filter
  Revert "x86: remove the x32 syscall bitmask from syscall_get_nr()"

 arch/x86/include/asm/syscall.h |    8 ++++++--
 include/uapi/linux/audit.h     |    1 +
 kernel/seccomp.c               |    6 ++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

