Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965491AbaLMGnH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 01:43:07 -0500
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:58568 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965425AbaLMGnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 01:43:05 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:4321:5007:6261:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12517:12519:12555:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crib41_8eebdc678004f
X-Filterd-Recvd-Size: 2017
Message-ID: <1418452981.29082.7.camel@perches.com>
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
From: Joe Perches <joe@perches.com>
To: Krzysztof Konopko <kris@konagma.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Dec 2014 22:43:01 -0800
In-Reply-To: <1418425137-13339-1-git-send-email-kris@konagma.com>
References: <1418336609-10191-1-git-send-email-kris@konagma.com>
	 <1418425137-13339-1-git-send-email-kris@konagma.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-12 at 23:58 +0100, Krzysztof Konopko wrote:
> This patch changes the types of the struct fields involved to be
> little-endian which is what is received over the air and consistent with
> relevant structs in include/linux/ieee80211.h.
[]
> diff --git a/drivers/staging/rtl8723au/include/wifi.h b/drivers/staging/rtl8723au/include/wifi.h
[]
> @@ -28,7 +28,7 @@
>  struct AC_param {
>  	unsigned char		ACI_AIFSN;
>  	unsigned char		CW;
> -	unsigned short	TXOP_limit;
> +	__le16			TXOP_limit;
>  }  __packed;
>  
>  struct WMM_para_element {
> @@ -39,9 +39,9 @@ struct WMM_para_element {
>  
>  struct ADDBA_request {
>  	unsigned char		dialog_token;
> -	unsigned short	BA_para_set;
> -	unsigned short	BA_timeout_value;
> -	unsigned short	BA_starting_seqctrl;
> +	__le16		BA_para_set;
> +	__le16		BA_timeout_value;
> +	__le16		BA_starting_seqctrl;
>  }  __packed;

If I did this, I would also change the
unsigned char uses to u8 at the same time.



