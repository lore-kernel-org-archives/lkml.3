Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaFUN6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 09:58:42 -0400
Received: from smtprelay0183.hostedemail.com ([216.40.44.183]:37199 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752020AbaFUN6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 09:58:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:857:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3871:3872:3874:4321:4385:4605:5007:7652:8603:8879:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740:13069:13161:13229:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crush57_112fe955daa5a
X-Filterd-Recvd-Size: 2326
Message-ID: <1403359116.4076.44.camel@joe-AO725>
Subject: Re: [PATCH] video: fbdev: skeletonfb.c:  Adding code to managing
 allocation error
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 21 Jun 2014 06:58:36 -0700
In-Reply-To: <1403356646-29443-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403356646-29443-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Geert, who probably wrote most of this
 and likely might have forgotten all of it)

On Sat, 2014-06-21 at 15:17 +0200, Rickard Strandqvist wrote:
> Adding missing code for managing a memory allocation error that may occur.
> 
> This was partly found using a static code analysis program called cppcheck.

skeletonfb.c is not meant to be compiled.
It's a sample driver template.

Those /* goto error path */ lines are for
driver writers that use this to figure out
what to do.

The second return is not correct as it would
not free the first alloc'd block.

> diff --git a/drivers/video/fbdev/skeletonfb.c b/drivers/video/fbdev/skeletonfb.c
[]
> @@ -692,6 +692,7 @@ static int xxxfb_probe(struct pci_dev *dev, const struct pci_device_id *ent)
>  
>      if (!info) {
>  	    /* goto error path */
> +	    return -ENOMEM;
>      }
>  
>      par = info->par;
> @@ -746,6 +747,7 @@ static int xxxfb_probe(struct pci_dev *dev, const struct pci_device_id *ent)
>      info->pixmap.addr = kmalloc(PIXMAP_SIZE, GFP_KERNEL);
>      if (!info->pixmap.addr) {
>  	    /* goto error */
> +	    return -ENOMEM;
>      }
>  
>      info->pixmap.size = PIXMAP_SIZE;
> 


