Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab3B0Vv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 16:51:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3B0Vv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 16:51:57 -0500
Date: Wed, 27 Feb 2013 13:51:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
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
Subject: Re: [PATCH 0/3] build linux-next without perl
Message-Id: <20130227135155.c04453db.akpm@linux-foundation.org>
In-Reply-To: <1361944667.957820@landley.net>
References: <1361944667.957820@landley.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2013 21:57:52 -0800 (PST)
Rob Landley <rob@landley.net> wrote:

> Before 2.6.25 building Linux never required perl. This patch series removes
> the requirement from basic kernel builds (tested on i686, x86_64, arm, mips,
> powerpc, sparc, sh4, and m68k). Now updated to 3.8-rc1.
> 
> Note, this removes perl from the _build_ environment, not from the _development_
> environment. This is approximately the same logic behind "make menuconfig"
> requiring curses but "make oldconfig" not requiring curses. Including
> zconf.lex.c_shipped in kconfig and then requiring perl makes no sense.
>
> ...
>
> Mostly people just copy the patches into their local projects (ala
> https://github.com/rofl0r/sabotage/tree/master/KEEP ) but I'm reposting
> them to linux-kernel after Gentoo considered using these patches, but didn't 
> because they weren't upstream:
>   https://bugs.gentoo.org/show_bug.cgi?id=421483

Sitting here scratching head wondering why you-need-perl is a problem
for anyone.

That gentoo bug report provides some explanation: "perl was removed
from @system".  But I expect other people have different reasons.

IOW, please better describe the motivation for this patchset.

It'll need to be reasonably good motivation, too.  Because not only do
we need to patch the kernel, we also need to *maintain* its
perl-freeness and fix up perlisms as they later get added by others.

(Perhaps one way of doing this would be to disable perl in regular
builds, so even if a developer has perl installed on his machine, his
build will still fail when he invokes it.  Add "PERL=/dev/null" to some
build targets in some manner.)

