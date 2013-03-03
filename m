Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab3CCDLD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 22:11:03 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57862 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab3CCDLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 22:11:01 -0500
Date: Sun, 3 Mar 2013 03:10:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [git pull] another embarrassing braino fix in signal.git
Message-ID: <20130303031056.GK4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	generic compat_sys_rt_sigprocmask() had a very dumb braino; I'd
spent quite a while staring at the offending commit before finally managing
to spot the idiocy ;-/  Dave, could you verify that it fixes all the problems
you've seen on sparc?  FWIW, the symptoms I'd been seeing got fixed by that
and AFAICS your reproducer is also taken care of.  The fix is definitely
needed; the only question is if there's something else going on.  Linus,
please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus

Shortlog:
Al Viro (1):
      fix compat_sys_rt_sigprocmask()

Diffstat:
 kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
