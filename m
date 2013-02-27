Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab3B0F55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 00:57:57 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:64464 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3B0F5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 00:57:55 -0500
Date: Tue, 26 Feb 2013 21:57:52 -0800 (PST)
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Dave Jones <davej@redhat.com>, David Howells <dhowell@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>, Michal Marek <mmarek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>, x86@kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Message-Id: <1361944667.957820@landley.net>
From: Rob Landley <rob@landley.net>
Subject: [PATCH 0/3] build linux-next without perl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before 2.6.25 building Linux never required perl. This patch series removes
the requirement from basic kernel builds (tested on i686, x86_64, arm, mips,
powerpc, sparc, sh4, and m68k). Now updated to 3.8-rc1.

Note, this removes perl from the _build_ environment, not from the _development_
environment. This is approximately the same logic behind "make menuconfig"
requiring curses but "make oldconfig" not requiring curses. Including
zconf.lex.c_shipped in kconfig and then requiring perl makes no sense.

Earlier versions have been posted to the mailing list over, and over, and over:

http://lkml.indiana.edu/hypermail/linux/kernel/1212.2/00734.html
http://lkml.indiana.edu/hypermail/linux/kernel/1201.2/02849.html
http://lkml.indiana.edu/hypermail/linux/kernel/0912.1/00093.htm
http://lkml.indiana.edu/hypermail/linux/kernel/0909.2/01661.html
http://lkml.indiana.edu/hypermail/linux/kernel/0901.0/00772.html
http://lkml.indiana.edu/hypermail/linux/kernel/0901.0/00148.html
http://lkml.indiana.edu/hypermail/linux/kernel/0802.1/4393.html

They've also been posted individually rather than as a series:
http://lkml.indiana.edu/hypermail/linux/kernel/1101.2/00650.html
http://lkml.indiana.edu/hypermail/linux/kernel/1101.2/00115.html

Mentioned during related perl removal patches from other people:
http://lkml.indiana.edu/hypermail/linux/kernel/0910.0/02145.html

And so on. So here it is again. The most up to date version of these patches
is always available at http://landley.net/hg/aboriginal in the sources/patches
directory. Specifically, check:

http://landley.net/hg/aboriginal/log/tip/sources/patches/linux-noperl-capflags.patch
http://landley.net/hg/aboriginal/log/tip/sources/patches/linux-noperl-headers.patch
http://landley.net/hg/aboriginal/log/tip/sources/patches/linux-noperl-timeconst.patch

(Earlier versions had the kernel version number in the filename, so you'll have
to dig in the repository a bit to find them if you want the version for an
older kernel.)

Mostly people just copy the patches into their local projects (ala
https://github.com/rofl0r/sabotage/tree/master/KEEP ) but I'm reposting
them to linux-kernel after Gentoo considered using these patches, but didn't 
because they weren't upstream:
  https://bugs.gentoo.org/show_bug.cgi?id=421483

Here's either Peter Anvin or Greg KH (not quite sure which) suggesting removing
timeconst.pl:
http://lkml.indiana.edu/hypermail/linux/kernel/1302.3/00506.html

Here's Sam Ravnborg acking the headers_install patch:
https://lkml.org/lkml/2013/2/15/121

Here's Michal Marek reviewing the headers_install patch (his suggestions
are incorporated in this version):
http://lkml.indiana.edu/hypermail/linux/kernel/1302.3/00078.html

Here's somebody else reminding me to repost the patch series:
http://lkml.indiana.edu/hypermail/linux/kernel/1302.0/00607.html

Plus various people keep poking me and asking about it. I'll see who I can
remember to ping.

(Sorry for the delay. Balsa is such a horrible email client I wrote a python
script to send this email. Took a while to debug. Probably still likely to
screw something up...)
