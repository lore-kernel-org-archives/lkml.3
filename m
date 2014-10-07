Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbaJGPas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:30:48 -0400
Received: from smtprelay0047.hostedemail.com ([216.40.44.47]:55425 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753269AbaJGPar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:30:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3770:3868:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6117:7652:7903:9025:9388:10004:10400:10848:11026:11027:11232:11658:11914:12043:12292:12517:12519:12555:12679:12682:12740:12776:13069:13255:13311:13357:13845:14106:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: farm54_7adb7a91ff503
X-Filterd-Recvd-Size: 1544
Message-ID: <1412695842.2916.49.camel@joe-AO725>
Subject: Re: [PATCH v2 1/2] staging: gs_fpgaboot: Fix "Possible unnecessary
 KERN_INFO" checkpatch.pl warning
From: Joe Perches <joe@perches.com>
To: Dzmitry Sledneu <dzmitry.sledneu@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Date: Tue, 07 Oct 2014 08:30:42 -0700
In-Reply-To: <54340568.7090700@gmail.com>
References: <5433FA93.8000607@gmail.com> <5433FB18.9000009@gmail.com>
	 <54340568.7090700@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-07 at 17:23 +0200, Dzmitry Sledneu wrote:
> Fix "Possible unnecessary KERN_INFO" checkpatch.pl warning
[]
> diff --git a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
[]
> @@ -58,7 +58,7 @@ static void datadump(char *msg, void *m, int n)
>  
>  	for (i = 0; i < n; i++) {
>  		if ((i&0xf) == 0)
> -			pr_info(KERN_INFO "\n  0x%4x: ", i);
> +			pr_info("\n  0x%4x: ", i);
>  
>  		pr_info("%02X ", c[i]);
>  	}

Please fix this by using print_hex_dump (and family) instead

Something like:
http://www.spinics.net/lists/linux-driver-devel/msg55075.html


