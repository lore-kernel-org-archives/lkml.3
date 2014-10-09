Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaJIRQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:16:25 -0400
Received: from smtprelay0204.hostedemail.com ([216.40.44.204]:48045 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750886AbaJIRQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:16:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3870:3871:3872:4321:5007:6119:7652:7903:8829:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13019:13868:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: leg14_8dddc1333c45f
X-Filterd-Recvd-Size: 3113
Message-ID: <1412874973.2975.8.camel@joe-AO725>
Subject: Re: [PATCH] staging: rtl8192u: correct coding style errors
From: Joe Perches <joe@perches.com>
To: Tsung-Han Lin <tsunghan.tw@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Thu, 09 Oct 2014 10:16:13 -0700
In-Reply-To: <1412874122-7650-1-git-send-email-tsunghan.tw@gmail.com>
References: <1412874122-7650-1-git-send-email-tsunghan.tw@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 01:02 +0800, Tsung-Han Lin wrote:
> Correct some coding style errors in
> drivers/staging/rtl8192u/r819xU_firmware.c.

Generic advice is not to merely shut up checkpatch
complaints, but try to make the code better/more readable.

> diff --git a/drivers/staging/rtl8192u/r819xU_firmware.c b/drivers/staging/rtl8192u/r819xU_firmware.c
[]
> @@ -37,7 +37,7 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>  	bool		    rt_status = true;
>  	u16		    frag_threshold;
>  	u16		    frag_length, frag_offset = 0;
> -	//u16		    total_size;
> +	/* u16		    total_size; */

probably better to delete this instead.

> @@ -66,7 +66,7 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>  		skb  = dev_alloc_skb(USB_HWDESC_HEADER_LEN + frag_length + 4);
>  		if (!skb)
>  			return false;
> -		memcpy((unsigned char *)(skb->cb),&dev,sizeof(dev));
> +		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));

Unnecessary cast

		memcpy(sk->cb, &dev, sizeof(dev));

> @@ -78,19 +78,19 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>  		 * Transform from little endian to big endian
>  		 * and pending  zero
>  		 */
> -		for (i=0; i < frag_length; i+=4) {
> -			*seg_ptr++ = ((i+0)<frag_length)?code_virtual_address[i+3]:0;
> -			*seg_ptr++ = ((i+1)<frag_length)?code_virtual_address[i+2]:0;
> -			*seg_ptr++ = ((i+2)<frag_length)?code_virtual_address[i+1]:0;
> -			*seg_ptr++ = ((i+3)<frag_length)?code_virtual_address[i+0]:0;
> +		for (i = 0; i < frag_length; i += 4) {
> +			*seg_ptr++ = ((i+0) < frag_length)?code_virtual_address[i+3]:0;
> +			*seg_ptr++ = ((i+1) < frag_length)?code_virtual_address[i+2]:0;
> +			*seg_ptr++ = ((i+2) < frag_length)?code_virtual_address[i+1]:0;
> +			*seg_ptr++ = ((i+3) < frag_length)?code_virtual_address[i+0]:0;

It may be better to create a helper function.
Spaces around ternaries are generally more readable

			*seg_ptr++ = frag_length >= i + 0 ? code_virtual_address[i + 3] : 0;
			*seg_ptr++ = frag_length >= i + 1 ? code_virtual_address[i + 2] : 0;
			*seg_ptr++ = frag_length >= i + 2 ? code_virtual_address[i + 1] : 0;
			*seg_ptr++ = frag_length >= i + 3 ? code_virtual_address[i + 0] : 0;



