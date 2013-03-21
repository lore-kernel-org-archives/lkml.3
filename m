Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab3CUWyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:54:50 -0400
Received: from ozlabs.org ([203.10.76.45]:46458 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932358Ab3CUWyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 18:54:49 -0400
From: Michael Neuling <mikey@neuling.org>
To: Chen Gang <gang.chen@asianux.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, sfr@canb.auug.org.au,
        "paulus\@samba.org" <paulus@samba.org>, matt@ozlabs.org,
        imunsie@au1.ibm.com, linuxppc-dev@lists.ozlabs.org,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] PowerPC: kernel: cross compiling issue with allmodconfig
In-reply-to: <514AA0D9.1090509@asianux.com>
References: <51428C81.6000204@asianux.com> <25841.1363323174@ale.ozlabs.ibm.com> <5142AE27.7060003@asianux.com> <514AA0D9.1090509@asianux.com>
Comments: In-reply-to Chen Gang <gang.chen@asianux.com>
   message dated "Thu, 21 Mar 2013 13:55:37 +0800."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Fri, 22 Mar 2013 09:54:46 +1100
Message-ID: <10123.1363906486@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> wrote:

> Hello All:
> 
> summary:
>   the root cause is no enough room in exception area (0x5500 -- 0x7000).
> 
>   it is caused by the patches "for saving/restre PPR":
>     they consumed much space of this area (0x5500 -- 0x7000).
>     for pseries_defconfig and ppc64_defconfig, it is still ok.
>     but for allmodconfig and "some additional config", it will cause issue.
> 
>   the solving patch "Make room in exception vector area" can make room larger.
>     it can let "some additional config" ok.
>     but for allmodconfig, it is still not enough.
> 
> 
> details
>   reason:
>     it is caused by:
>        commit number: 13e7a8e846c2ea38a552b986ea49332f965bbb7a
>        commit number: 44e9309f1f357794b7ae93d5f3e3e6f11d2b8a7f
>     they are "for saving/restore PPR"
>     by Haren Myneni <haren@linux.vnet.ibm.com> Thu, 6 Dec 2012
>     compiling result:
>       pseries_defconfig: pass   (cpu for POWER7)
>       ppc64_defconfig:   pass   (cpu for POWER7)
>       allmodconfig:      failed (cpu for POWER7)
> 
>   analysing:
>     solving patch:
>       ------------------------------------------------------------------
>       commit number: 61383407677aef05928541a00678591abea2d84c
>       Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>       Date:   Thu Jan 10 17:44:19 2013 +1100
> 
>         powerpc: Make room in exception vector area
>     
>         The FWNMI region is fixed at 0x7000 and the vector are now
>         overflowing that with some configurations. Fix that by moving
>         some hash management code out of that region as it doesn't need
>         to be that close to the call sites (isn't accessed using
>         conditional branches).
>       ------------------------------------------------------------------
> 
>       but for allmodconfig (not only for "some configurations"):
>         it really can reduce much overflow bytes,
>           (maybe from hundreds bytes to dozens bytes)
>         but still not enough (still content overflow bytes)
> 
>     additional trying:
> 	after del CONFIG_VSX and CONFIG_PPC_970_NAP in allmodconfig,
>           (will reduce dozens bytes in the region .0x5500 -- .0x7000)
>         it can pass compiling (not overflow).
> 
> 
> next:
>   I am sorry:
>       I am not quite familiar with the detail features of powerpc.
>       it seems I am not the suitable member to continue trying.
> 
>   I prefer Benjamin to continue trying (just like what he has done).
> 
>   if Benjamin will not do it (e.g. maybe no time to do)
>     I should continue: "make additional room in exception vector area".
>       (if get no reply within a week: before 2013-03-28, I should continue)
> 
> 
> 
>   welcome any members' (especially Benjamin) suggestions or completions.

This is great, thanks a lot.  

If you want this to be picked up by the maintainer, you'll need to add
your signed-off-by.

The signed-off-by is to indicate that your happy for it to be included
and that you're legally allowed to do so.  See
http://gerrit.googlecode.com/svn/documentation/2.0/user-signedoffby.html
for more info.

Mikey

> 
>   thanks.
> 
>   :-)
> 
> 
> On 2013年03月15日 13:14, Chen Gang wrote:
> > 于 2013年03月15日 12:52, Michael Neuling 写道:
> >> Yep it's a known problem but no one has bothered to fix it since it
> >> doesn't happen in a config that anyone cares about like
> >> pseries_defconfig and ppc64_defconfig.  We've been moving code around in
> >> this area a lot recently hence the breakage.
> >>
> >> It should be fixed though.  Patches welcome. :-)
> > 
> >   thanks, and I should try, and very glad to try.
> > 
> >   :-)  :-)
> > 
> >   excuse me, I try to provide related patch within this month (2013-03-31), is it ok ?
> >   the reason is:
> >     I am not familiar with ppc assembly code, neither ppc kernel,
> >     so need additional time resource.
> >       (originally, I worked for x86(_64) core dump analysing for kernel and user programs)
> > 
> >   thanks.
> > 
> 
> 
> -- 
> Chen Gang
> 
> Asianux Corporation
> 
