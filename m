Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031164Ab3HIVL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 17:11:28 -0400
Received: from one.firstfloor.org ([193.170.194.197]:34594 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031125Ab3HIVL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 17:11:27 -0400
Date: Fri, 9 Aug 2013 23:11:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, peter@hurleysoftware.com,
        gregkh@linuxfoundation.org
Cc: viro@zeniv.linux.org.uk
Subject: pty FIONREAD returning zero breaks emacs in 3.11rc3
Message-ID: <20130809211126.GF19750@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When I run emacs over ssh terminal (no X) on 3.11-rc3 it often ignores key
strokes.  I first thought the system was busy or so, but when
stracing the emacs it was not blocked.

Here's a typical sequence. select/SIGIO wakes it up, but then
FIONREAD returns 0.

I'm not fully sure when it started.

It does not happen all the time, but is quite frequent.

ioctl(3, FIONREAD, [0])                 = 0
pselect6(4, [3], [], NULL, {17, 952336932}, {NULL, 8}) = 1 (in [3], left
{17, 504942810})
--- SIGIO {si_signo=SIGIO, si_code=SI_KERNEL} ---
rt_sigreturn()                          = 1
ioctl(3, FIONREAD, [0])                 = 0
ioctl(3, FIONREAD, [0])                 = 0
pselect6(4, [3], [], NULL, {17, 504298807}, {NULL, 8}) = ?
ERESTARTNOHAND (Interrupted by signal)
--- SIGIO {si_signo=SIGIO, si_code=SI_KERNEL} ---
rt_sigreturn()                          = -1 EINTR (Interrupted system
call)
ioctl(3, FIONREAD, [0])                 = 0
pselect6(4, [3], [], NULL, {17, 103972440}, {NULL, 8}) = 1 (in [3], left
{16, 864890560})
--- SIGIO {si_signo=SIGIO, si_code=SI_KERNEL} ---
rt_sigreturn()                          = 1


-- 
ak@linux.intel.com -- Speaking for myself only.
