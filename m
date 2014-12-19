Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaLSBjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:39:06 -0500
Received: from ozlabs.org ([103.22.144.67]:34822 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaLSBiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:38:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: Ionut Alexa <ionut.m.alexa@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "lkml" <linux-kernel@vger.kernel.org>
Subject: [PULL] modules-next
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 19 Dec 2014 11:25:18 +1030
Message-ID: <8761d8tq4p.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/modules-next-for-linus

for you to fetch changes up to b0a65b0cccd477b2fd8b7adad0ac39433df54829:

  param: do not set store func without write perm (2014-12-18 12:38:51 +1030)

----------------------------------------------------------------
The exciting thing here is the getting rid of stop_machine on module
removal.  This is possible by using a simple atomic_t for the counter,
rather than our fancy per-cpu counter: it turns out that no one is doing
a module increment per net packet, so the slowdown should be in the noise.

Also, script fixed for new git version.

Cheers,
Rusty.

----------------------------------------------------------------
Ionut Alexa (1):
      kernel:module Fix coding style errors and warnings.

Kees Cook (1):
      param: do not set store func without write perm

Masami Hiramatsu (5):
      module: Wait for RCU synchronizing before releasing a module
      module: Unlink module with RCU synchronizing instead of stop_machine
      lib/bug: Use RCU list ops for module_bug_list
      module: Replace module_ref with atomic_t refcnt
      module: Remove stop_machine from module unloading

Rusty Russell (1):
      params: cleanup sysfs allocation

 include/linux/module.h        |  16 +---
 include/trace/events/module.h |   2 +-
 kernel/module.c               | 170 +++++++++++++++++++-----------------------
 kernel/params.c               |  97 ++++++++++++------------
 lib/bug.c                     |  20 +++--
 5 files changed, 137 insertions(+), 168 deletions(-)
