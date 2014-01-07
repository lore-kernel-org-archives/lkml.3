Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaAGPGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:06:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63457 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaAGPGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:06:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Ming Lei <tom.leiming@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts/kallsyms: filter symbols not in kernel address space
Date: Tue, 07 Jan 2014 16:05:43 +0100
Message-ID: <5082388.oRuzc7DqM3@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CACVXFVNPcC+7Th-xfD24GiEat=FHMGKXh9Abc_othvR5pdLOYQ@mail.gmail.com>
References: <1382975339-25831-1-git-send-email-tom.leiming@gmail.com> <201401071512.34016.arnd@arndb.de> <CACVXFVNPcC+7Th-xfD24GiEat=FHMGKXh9Abc_othvR5pdLOYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:v4sxxqdkq6MWWyMoyngLniB9puhVEj1poI6V+VKZJVZ
 +DaxXH/MvRygjt45klNgGNmiu2RQMz1OKGgtEeaasoaUs4F0M1
 8mCig7ag6+PK7S3Gmfut6aP3gtER4mrx+Ob3EQ6QAriDF/neTe
 RZTEizp+yyApAJJn+IfWgfp2wc/95PASNaNM+HBgVsSEB0rE12
 EwfEF8EjHiK8tm25ycD0h4GrRplYwvjH0ChjVWy/PLVTPnwzT7
 j3wkgzZNrb4UKCoJECZg9nLMwyCM1+Zhb/PkPZPp7m31HGSzkJ
 KOiqSJ/IZ2JcqwaAaVjdUl7IFyo/8IrnU7lrjjyFAL2aXqeMPl
 RhUccGZifbT++8G1RHYo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 January 2014 22:33:24 Ming Lei wrote:
> On Tue, Jan 7, 2014 at 10:12 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 28 October 2013, Ming Lei wrote:
> 
> We had posted two patches to address the problem, see below link:
> 
>    http://lists.scusting.com/index.php?t=msg&goto=1726509&S=Google

The patch "scripts/link-vmlinux.sh: only filter kernel symbols for arm"
has made it in now, which is good for all other architectures, but it
makes no difference  for nommu-arm, because CONFIG_PAGE_OFFSET is
still set.

The second patch from Jonathan Austin has not been applied yet, as of
today's linux-next, and it's exactly what I suggested. However it
won't work on ARM platforms that define their own PLAT_PHYS_OFFSET:
ebsa110, ep93xx, exynos, footbridge, integrator, iop13xx, ks8695,
omap1, realview, rpc, s5pv210 and sa1100. Fortunately these all have
MMUs, so in practice it won't hurt, but it doesn't seem correct.

	Arnd
