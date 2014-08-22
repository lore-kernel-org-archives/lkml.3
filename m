Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbaHVSKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 14:10:50 -0400
Received: from smtprelay0111.hostedemail.com ([216.40.44.111]:54204 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932410AbaHVSKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 14:10:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3872:4321:5007:6119:7652:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12740:13069:13071:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: club57_6ca76fa6f02b
X-Filterd-Recvd-Size: 2833
Message-ID: <1408731045.17241.10.camel@joe-AO725>
Subject: Re: [PATCH] drivers: staging: rtl8723au: Fix "(foo*)" should be
 "(foo *)" errors
From: Joe Perches <joe@perches.com>
To: Greg Donald <gdonald@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linux.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org
Date: Fri, 22 Aug 2014 11:10:45 -0700
In-Reply-To: <1408728056-17306-1-git-send-email-gdonald@gmail.com>
References: <1408728056-17306-1-git-send-email-gdonald@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 12:20 -0500, Greg Donald wrote:
> Fix checkpatch.pl "(foo*)" should be "(foo *)" errors

Hello Greg.

> diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
[]
> @@ -599,7 +599,7 @@ void update_sta_info23a_apmode23a(struct rtw_adapter *padapter, struct sta_info
>  
>  	/* todo: init other variables */
>  
> -	memset((void*)&psta->sta_stats, 0, sizeof(struct stainfo_stats));
> +	memset((void *)&psta->sta_stats, 0, sizeof(struct stainfo_stats));

It'd be better to remove the (void *) cast instead.

[]
> diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
[]
> @@ -1493,7 +1493,7 @@ void rtw_setstaKey_cmdrsp_callback23a(struct rtw_adapter *padapter,
>  	struct sta_info *psta;
>  
>  	pstapriv = &padapter->stapriv;
> -	psetstakey_rsp = (struct set_stakey_rsp*) (pcmd->rsp);
> +	psetstakey_rsp = (struct set_stakey_rsp *) (pcmd->rsp);

Probably better to remove the space and the
unnecessary parentheses:

	psetstakey_rsp = (struct set_stakey_rsp *)pcmd->rsp;

> @@ -1518,7 +1518,7 @@ void rtw_setassocsta_cmdrsp_callback23a(struct rtw_adapter *padapter,
>  	struct sta_info *psta;
>  
>  	passocsta_parm = (struct set_assocsta_parm *)(pcmd->parmbuf);
> -	passocsta_rsp = (struct set_assocsta_rsp*) (pcmd->rsp);
> +	passocsta_rsp = (struct set_assocsta_rsp *) (pcmd->rsp);

same unnecessary parentheses, maybe
submit separate patches for those.

> diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
[]
> @@ -4763,7 +4763,7 @@ void report_survey_event23a(struct rtw_adapter *padapter,
>  	pcmd_obj->rsp = NULL;
>  	pcmd_obj->rspsz  = 0;
>  
> -	pc2h_evt_hdr = (struct C2HEvent_Header*)(pevtcmd);
> +	pc2h_evt_hdr = (struct C2HEvent_Header *)(pevtcmd);

more unnecessary parentheses, etc...


