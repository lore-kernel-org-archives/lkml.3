Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3ARQSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 11:18:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62684 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3ARQSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 11:18:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v2 28/76] ARC: I/O and DMA Mappings
Date: Fri, 18 Jan 2013 16:18:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <201301181555.43487.arnd@arndb.de> <20130118160106.GD14019@linux-sh.org>
In-Reply-To: <20130118160106.GD14019@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181618.11736.arnd@arndb.de>
X-Provags-ID: V02:K0:B8HUoyyeUKVJWrrdsE7LdSAj+Z+c1iw8QniSB4Pq/FI
 uhF4YvQb0maZHhT1nYKeMUFz7sGq68NOlH+ofl2Ew9eZhd/9pM
 nGCm+ymPT5nprB/bAKgYUAPmvoAe2Dn+UdRsh4jJkPksElDJLU
 kXDrbJtbpvCy49BcTk/oFYk8/eoE753iWFQMaRh/T56MafsU5q
 SzvIf34xmtk5o2ehZLhR8KTjI4ROwouRrFghvKvTE75IhuOc8h
 +SifC++SOtFNU5b6c6KHLsifHZ7XIGqEGbqx+qwg8iMy9wnAiz
 sLLG90wcTCZWewcm8naJt1Fkp0X27wAoTZ1ngiWE8tzFg1L4Fg
 QeOxBHn0OvncIroZcST8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Paul Mundt wrote:
> On Fri, Jan 18, 2013 at 03:55:43PM +0000, Arnd Bergmann wrote:
> > On Friday 18 January 2013, Vineet Gupta wrote:
> > > TBD: Do we need early ioremap support like openrisc
> > > 
> > > Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> > 
> > Can you explain why early ioremap is necessary for you?
> > 
> > I wasn't aware that openrisc has it. In a lot of cases,
> > you can use fixmap as a replacement.
> > 
> The two don't need to be mutually exclusive, either. sh implements early
> ioremap transparently via fixmaps for example:
> 
>         arch/sh/mm/ioremap.c
>         arch/sh/mm/ioremap_fixed.c

Ah, right. It also seems that openrisc uses the same approach
for its early ioremap.

I usually recommend doing as few things as possible "early"
though, that's why I was asking. If it's only one or two drivers
that need an early mapping and can't be moved to a later stage
of bootup, using only hardcoded fixmaps would make it harder
to add more users, which one might consider a good thing.

Allowing ioremap to be used before memory_init() adds flexibility
but could lead to code being moved into an early stage by accident
rather than by necessity.

	Arnd
