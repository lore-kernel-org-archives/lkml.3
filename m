Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaCYIcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:32:42 -0400
Received: from smtprelay0148.hostedemail.com ([216.40.44.148]:42442 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752086AbaCYIch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:32:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3866:3867:3870:3873:4321:5007:7514:7652:10004:10400:10848:11232:11473:11658:11914:12043:12114:12295:12296:12517:12519:12555:12740:13019:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cave64_33b1356a4dc4b
X-Filterd-Recvd-Size: 2317
Message-ID: <1395736353.3010.6.camel@joe-AO722>
Subject: Re: [PATCH] drivers:bluetooth:ath3k.c: Fixed sparse warning for
 cast to restricted __le32
From: Joe Perches <joe@perches.com>
To: Surendra Patil <surendra.tux@gmail.com>
Cc: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 25 Mar 2014 01:32:33 -0700
In-Reply-To: <1395735950-17968-1-git-send-email-surendra.tux@gmail.com>
References: <1395735950-17968-1-git-send-email-surendra.tux@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-25 at 01:25 -0700, Surendra Patil wrote:
> This patch fixes below Sparse warnings -
> drivers/bluetooth/ath3k.c:370:17: warning: cast to restricted __le32
> drivers/bluetooth/ath3k.c:432:17: warning: cast to restricted __le32

You are changing output here.

I suspect rom_version should be marked __le32 instead
of unsigned int in "struct ath3k_version" instead.

> Signed-off-by: Surendra Patil <surendra.tux@gmail.com>
> ---
>  drivers/bluetooth/ath3k.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
> index be571fe..badacbc 100644
> --- a/drivers/bluetooth/ath3k.c
> +++ b/drivers/bluetooth/ath3k.c
> @@ -367,7 +367,7 @@ static int ath3k_load_patch(struct usb_device *udev)
>  	}
>  
>  	snprintf(filename, ATH3K_NAME_LEN, "ar3k/AthrBT_0x%08x.dfu",
> -		le32_to_cpu(fw_version.rom_version));
> +		fw_version.rom_version);
>  
>  	ret = request_firmware(&firmware, filename, &udev->dev);
>  	if (ret < 0) {
> @@ -429,7 +429,7 @@ static int ath3k_load_syscfg(struct usb_device *udev)
>  	}
>  
>  	snprintf(filename, ATH3K_NAME_LEN, "ar3k/ramps_0x%08x_%d%s",
> -		le32_to_cpu(fw_version.rom_version), clk_value, ".dfu");
> +		 fw_version.rom_version, clk_value, ".dfu");
>  
>  	ret = request_firmware(&firmware, filename, &udev->dev);
>  	if (ret < 0) {



