Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaL0R0y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 12:26:54 -0500
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:50092 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750795AbaL0R0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 12:26:53 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2894:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6261:7903:7904:10004:10400:10848:11026:11232:11657:11658:11914:12043:12294:12296:12438:12517:12519:12740:13069:13071:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: smoke00_1e6236641ef09
X-Filterd-Recvd-Size: 2287
Message-ID: <1419701207.20894.3.camel@perches.com>
Subject: Re: [PATCH] staging: rtl8723au: Fixed multiple space issues
From: Joe Perches <joe@perches.com>
To: Matthew Emerson <emersonmde@gmail.com>
Cc: gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sat, 27 Dec 2014 09:26:47 -0800
In-Reply-To: <1419669741-6048-1-git-send-email-emersonmde@gmail.com>
References: <1419669741-6048-1-git-send-email-emersonmde@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-12-27 at 03:42 -0500, Matthew Emerson wrote:
> Fixed multiple space issues found by checkpatch.pl in
> drivers/staging/rtl8723au/core/rtw_ap.c

Hello.

Please strive for more than simple robotic like
adherence to checkpatch messages.

A lot of the time, there is a better way.

> diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
[]
> @@ -897,7 +897,7 @@ int rtw_check_beacon_data23a(struct rtw_adapter *padapter,
>  	pairwise_cipher = 0;
>  	psecuritypriv->wpa_group_cipher = 0;
>  	psecuritypriv->wpa_pairwise_cipher = 0;
> -	for (p = ie; ;p += (ie_len + 2)) {
> +	for (p = ie; ; p += (ie_len + 2)) {

While it's arguably true that the ; is misplaced,
the loop control logic is probably better rewritten
for clarity here instead.

[]

> @@ -1871,7 +1871,7 @@ void stop_ap_mode23a(struct rtw_adapter *padapter)
>  	pmlmeext->bstart_bss = false;
>  
>  	/* reset and init security priv , this can refine with rtw_reset_securitypriv23a */
> -	memset((unsigned char *)&padapter->securitypriv, 0, sizeof (struct security_priv));
> +	memset((unsigned char *)&padapter->securitypriv, 0, sizeof(struct security_priv));

unnecessary cast too.

More likely this style would be nicer:

	memset(&adapter->securitypriv, 0, sizeof(adapter->securitypriv));

You could also use a compound literal.


