Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaGFRqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 13:46:34 -0400
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:52141 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751492AbaGFRqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 13:46:32 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:857:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3870:3871:3872:3874:4321:5007:7652:8879:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: front20_72e85d04c5c56
X-Filterd-Recvd-Size: 1727
Message-ID: <1404668788.27043.44.camel@joe-AO725>
Subject: Re: [PATCH] video: fbdev: sis: sis_main.c:  Cleaning up wrong type
 in format string
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 06 Jul 2014 10:46:28 -0700
In-Reply-To: <1404668190-15199-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1404668190-15199-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-06 at 19:36 +0200, Rickard Strandqvist wrote:
> Wrong type in printf format string, requires 'unsigned int'
> but the argument type is 'int'

Perhaps it'd be better to change the type of mydepth
to __u16 as that's the type of lfb_depth

> diff --git a/drivers/video/fbdev/sis/sis_main.c b/drivers/video/fbdev/sis/sis_main.c
[]
> @@ -237,7 +237,7 @@ static void sisfb_get_vga_mode_from_kernel(void)
>  
>  		if(mydepth == 24) mydepth = 32;
>  
> -		sprintf(mymode, "%ux%ux%u", screen_info.lfb_width,
> +		sprintf(mymode, "%ux%ux%d", screen_info.lfb_width,
>  					screen_info.lfb_height,
>  					mydepth);
>  


