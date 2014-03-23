Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbaCWTik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:38:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbaCWTii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:38:38 -0400
Date: Sun, 23 Mar 2014 20:37:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/11] cleanup/fix allow_signal/disallow_signal
Message-ID: <20140323193730.GA10464@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

allow_signal() and disallow_signal() have the very strange (wrong
actually) semantics. They mix/confuse "sigprocmask" and "sigaction"
logic.

This series tries to cleanup and fix them, plus other (mostly related)
cleanups.

Oleg.

 arch/m68k/include/asm/signal.h |    9 ----
 arch/x86/include/asm/signal.h  |    6 ---
 fs/jffs2/background.c          |   12 +++--
 include/linux/sched.h          |    3 -
 include/linux/signal.h         |   21 +++++++--
 kernel/exit.c                  |   39 -----------------
 kernel/kmod.c                  |    5 +--
 kernel/signal.c                |   90 ++++++++++++++++++---------------------
 8 files changed, 66 insertions(+), 119 deletions(-)

