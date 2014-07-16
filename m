Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbaGPKbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:31:33 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:49159 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaGPKb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:31:29 -0400
Date: Wed, 16 Jul 2014 12:31:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3/6] samples: use uapiprogs support for seccomp
Message-ID: <20140716103120.GA4710@ravnborg.org>
References: <1405276974-17323-1-git-send-email-sam@ravnborg.org>
 <1405276974-17323-3-git-send-email-sam@ravnborg.org>
 <20140716184351.AC2E.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716184351.AC2E.AA925319@jp.panasonic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 06:43:51PM +0900, Masahiro Yamada wrote:
> Hi Sam,
> 
> 
> On Sun, 13 Jul 2014 20:42:51 +0200
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > Reduce complexity of seccomp Makefile by introducing use of uapiprogs support.
> > Build testet with i686 only.
> 
> tested ?
> 
> (Ditto in 4/6)
Thanks - will fix.

> I am interested in this series.
> 
> Forgive me if I am asking a stupid question..
> 
> 
> How can I build hostprogs for the same host as the kernel?
> (I mean, how can I override $(HOSTCC) for cross-compiling ?)

One way to do this:

make ARCH=sparc CROSS_COMPILE=sparc-leon-linux-gnu- HOSTCC=sparc-leon-linux-gnu-gcc

Notice that I override HOSTCC as part of the make comand line.
This allows me to override the "=" assignment in the top-level Makefile.

But then my build breaks as fixdep do not run on my host.

If you in general want to build a binary for the target then uapiprogs come in handy.
Only caveat here is that you will be using the exported kernel headers.

	Sam
