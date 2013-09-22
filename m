Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab3IVUJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:09:35 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:56945 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3IVUJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:09:33 -0400
Date: Sun, 22 Sep 2013 21:09:31 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Joe Perches <joe@perches.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Subject: Re: [PATCH 2/2] framebuffer: Remove pmag-aa-fb
In-Reply-To: <1379702587.2301.12.camel@joe-AO722>
Message-ID: <alpine.LFD.2.03.1309201946430.8379@linux-mips.org>
References: <c94f3e342947923f20d4c12932f382aa5200511b.1379641901.git.joe@perches.com>         <6f500d88eb23fd9a4cfc5583f5ca17bc5f58fe24.1379641901.git.joe@perches.com>         <CAMuHMdW6R5qTJ0uvsUUaYBZAqFcNshPsXeMbz5hwqq5UOkJr-g@mail.gmail.com>        
 <alpine.LFD.2.03.1309201907380.8379@linux-mips.org> <1379702587.2301.12.camel@joe-AO722>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Sep 2013, Joe Perches wrote:

> I do wonder how many of these still exist though.
> 
> I haven't had one of those on a desk since the early
> '90's (a VAXstation w/VMS and a DECstation w/Ultrix)

 DECstations seem virtually indestructible, so it's mostly the matter of 
how long people want to keep them.  The only serious issue is by now they 
have started to suffer from dead lithium batteries that have been moulded 
in their DS1287A RTC chips.  With Maxim taking Dallas over and then 
breaking their promise to produce replacements indefinitely this has 
become a real problem now (I did not dare trying any of the imitatations 
the Chinese seem to offer these days).  A hack exists to rework old 
DS1287A (and similar) chips with a saw, a soldering iron and some skill 
for an external battery, but it requires some extra space around the chip 
and there is little in the DECstation because the DS1287A has been placed 
in the TURBOchannel option card area with little clearance left between 
the IC and any option card installed.

 As to the PMAG-AA board itself -- well, this is indeed a very rare item, 
but I happen to have a specimen.  To support it properly I'll first have 
to wire it to a monitor somehow though; signalling is standard, 1.0 Vpp 
composite monochrome, but what looks to me like a type F connector is used 
for video output, quite unusually for a graphics card (and for DEC itself 
too as 3W3 was their usual video socket).  It looks to me like converting 
it to BNC and then a standard DE-15 VGA connector (via the green line) 
will be the easiest way to get image produced by the adapter on a 
contemporary monitor (sync-on-green required of course, but with LCD 
devices being the norm now that seems less of a problem these days).

> The commit that removed it was:
> -------------------
> commit c708093f8164011d01eb3bbdf7d61965f283ee0e
> Author: James Simmons <jsimmons@maxwell.earthlink.net>
> Date:   Wed Oct 30 20:06:21 2002 -0800
> 
> Moved all console configuration out of arch directories into
> drivers/video/console. Allow resize of a single VC via the tty layer.
> Nuked GET_FB_IDX.
> -------------------
> 
> I think you could do:
> 
> ---
> 
>  drivers/video/pmag-aa-fb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/pmag-aa-fb.c b/drivers/video/pmag-aa-fb.c
> index 8384248..0362fb7 100644
> --- a/drivers/video/pmag-aa-fb.c
> +++ b/drivers/video/pmag-aa-fb.c
> @@ -459,7 +459,7 @@ static int __init init_one(int slot)
>  		return -EINVAL;
>  
>  	printk(KERN_INFO "fb%d: %s frame buffer in TC slot %d\n",
> -	       GET_FB_IDX(ip->info.node), ip->info.modename, slot);
> +	       ip->info.node, ip->info.modename, slot);
>  
>  	return 0;
>  }

 Thanks, but the changes required are actually much more than that -- the 
driver has never been converted to the modern TURBOchannel API.  I have 
now dug out an old patch I was working on back in 2006 to convert this 
driver as well as drivers/video/maxinefb.c.  I'll try to complete the two 
drivers as soon as possible (unfortunately I can't test the latter at all; 
it's for an onboard graphics adapter of another DECstation model), 
although I now remember the main reason I didn't complete them back then 
was they used an old internal API that was removed and no suitable 
replacement provided.  I need to investigate again what that actually was 
though (hw cursor probably).

  Maciej
