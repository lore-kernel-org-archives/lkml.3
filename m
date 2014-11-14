Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaKNFpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 00:45:38 -0500
Received: from smtprelay0096.hostedemail.com ([216.40.44.96]:35716 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751836AbaKNFph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 00:45:37 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4362:5007:6119:6261:7576:7808:7903:7904:9025:10010:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13161:13229:13311:13357:14196:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: power51_8811e77a03e4a
X-Filterd-Recvd-Size: 1966
Message-ID: <1415943934.5912.6.camel@perches.com>
Subject: Re: [PATCH] 6fire: Convert byte_rev_table uses to bitrev8
From: Joe Perches <joe@perches.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'perex@perex.cz'" <perex@perex.cz>, "'tiwai@suse.de'" <tiwai@suse.de>,
        "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Thu, 13 Nov 2014 21:45:34 -0800
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E010D1829C@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D1829C@CNBJMBX05.corpusers.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-14 at 13:13 +0800, Wang, Yalin wrote:
> Use the inline function instead of directly indexing the array.
> 
> This allows some architectures with hardware instructions for bit
> reversals to eliminate the array.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> ---
[]
> diff --git a/sound/usb/6fire/firmware.c b/sound/usb/6fire/firmware.c
[]
> @@ -316,7 +316,7 @@ static int usb6fire_fw_fpga_upload(
>  
>  	while (c != end) {
>  		for (i = 0; c != end && i < FPGA_BUFSIZE; i++, c++)
> -			buffer[i] = byte_rev_table[(u8) *c];
> +			buffer[i] = bitrev8((u8) *c);

This is not what I submitted.
What I posted did not have a space after (u8)

https://lkml.org/lkml/2014/10/28/1056

If you are going to resubmit or add your own sign-off,
please try to maintain the proper patch that is
submitted and please also use a "From:" line before
the patch itself.

Thanks, Joe

