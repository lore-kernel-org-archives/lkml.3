Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaJ0Owm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:52:42 -0400
Received: from smtprelay0157.hostedemail.com ([216.40.44.157]:48719 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752594AbaJ0Owj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:52:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:2:41:69:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1606:1730:1747:1777:1792:2194:2198:2199:2200:2393:2559:2562:2828:2914:3138:3139:3140:3141:3142:3622:3865:3866:3867:3870:3871:3873:3874:4117:4225:4321:4605:5007:6261:7901:7903:8957:9038:9592:10004:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12555:12683:12740:13161:13229:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: scent64_50e252b33a347
X-Filterd-Recvd-Size: 6050
Message-ID: <1414421554.8884.7.camel@perches.com>
Subject: Re: [PATCH] staging:rtl8723au: core: Fix error reported by
 checkpatch.
From: Joe Perches <joe@perches.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Sanjeev Sharma <sanjeev_sharma@mentor.com>, Larry.Finger@lwfinger.net,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 27 Oct 2014 07:52:34 -0700
In-Reply-To: <wrfjioj5aonx.fsf@redhat.com>
References: <1414396745-8845-1-git-send-email-sanjeev_sharma@mentor.com>
	 <wrfjioj5aonx.fsf@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 09:43 +0100, Jes Sorensen wrote:
> Sanjeev Sharma <sanjeev_sharma@mentor.com> writes:
> > This is a patch to the rtw_cmd.c file that fixes
> > Error reported by checkpatch.
[]
> > diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
[]
> > @@ -957,7 +957,7 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
> >  		/*  check traffic for  powersaving. */
> >  			if (((pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod +
> >  			      pmlmepriv->LinkDetectInfo.NumTxOkInPeriod) > 8) ||
> > -			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod >2)
> > +			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod > 2)
> >  				bEnterPS = false;
> >  			else
> >  				bEnterPS = true;
> 
> This makes the line longer than 80 characters, that is worse than the
> 'problem' you are fixing.

The code already has dozens of long lines already.

This is generally a problem because the variable names
are pretty long so strict 80 column adherence generally
isn't possible.

A possible way to shorten these relatively long variable
name/line lengths is to use a temporary for

	pmlmeprv->LinkDetectInfo

	struct rt_link_detect *ldi = &pmlmeprv->LinkDetectInfo;

so:

 drivers/staging/rtl8723au/core/rtw_cmd.c | 46 ++++++++++++++++----------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
index d2d7edf..1b24945 100644
--- a/drivers/staging/rtl8723au/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
@@ -922,34 +922,33 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
 	u8 bHigherBusyTxTraffic = false;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	int BusyThreshold = 100;
+	struct rt_link_detect *ldi = &pmlmepriv->LinkDetectInfo;
+
 	/*  */
 	/*  Determine if our traffic is busy now */
 	/*  */
 	if (check_fwstate(pmlmepriv, _FW_LINKED)) {
 		if (rtl8723a_BT_coexist(padapter))
 			BusyThreshold = 50;
-		else if (pmlmepriv->LinkDetectInfo.bBusyTraffic)
+		else if (ldi->bBusyTraffic)
 			BusyThreshold = 75;
 		/*  if we raise bBusyTraffic in last watchdog, using
 		    lower threshold. */
-		if (pmlmepriv->LinkDetectInfo.NumRxOkInPeriod > BusyThreshold ||
-		    pmlmepriv->LinkDetectInfo.NumTxOkInPeriod > BusyThreshold) {
+		if (ldi->NumRxOkInPeriod > BusyThreshold ||
+		    ldi->NumTxOkInPeriod > BusyThreshold) {
 			bBusyTraffic = true;
 
-			if (pmlmepriv->LinkDetectInfo.NumRxOkInPeriod >
-			    pmlmepriv->LinkDetectInfo.NumTxOkInPeriod)
+			if (ldi->NumRxOkInPeriod > ldi->NumTxOkInPeriod)
 				bRxBusyTraffic = true;
 			else
 				bTxBusyTraffic = true;
 		}
 
 		/*  Higher Tx/Rx data. */
-		if (pmlmepriv->LinkDetectInfo.NumRxOkInPeriod > 4000 ||
-		    pmlmepriv->LinkDetectInfo.NumTxOkInPeriod > 4000) {
+		if (ldi->NumRxOkInPeriod > 4000 ||
+		    ldi->NumTxOkInPeriod > 4000) {
 			bHigherBusyTraffic = true;
-
-			if (pmlmepriv->LinkDetectInfo.NumRxOkInPeriod >
-			    pmlmepriv->LinkDetectInfo.NumTxOkInPeriod)
+			if (ldi->NumRxOkInPeriod > ldi->NumTxOkInPeriod)
 				bHigherBusyRxTraffic = true;
 			else
 				bHigherBusyTxTraffic = true;
@@ -958,9 +957,9 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
 		if (!rtl8723a_BT_coexist(padapter) ||
 		    !rtl8723a_BT_using_antenna_1(padapter)) {
 		/*  check traffic for  powersaving. */
-			if (((pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod +
-			      pmlmepriv->LinkDetectInfo.NumTxOkInPeriod) > 8) ||
-			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod >2)
+			if (((ldi->NumRxUnicastOkInPeriod +
+			      ldi->NumTxOkInPeriod) > 8) ||
+			    ldi->NumRxUnicastOkInPeriod > 2)
 				bEnterPS = false;
 			else
 				bEnterPS = true;
@@ -971,18 +970,19 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
 			else
 				LPS_Leave23a(padapter);
 		}
-	} else
+	} else {
 		LPS_Leave23a(padapter);
+	}
 
-	pmlmepriv->LinkDetectInfo.NumRxOkInPeriod = 0;
-	pmlmepriv->LinkDetectInfo.NumTxOkInPeriod = 0;
-	pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod = 0;
-	pmlmepriv->LinkDetectInfo.bBusyTraffic = bBusyTraffic;
-	pmlmepriv->LinkDetectInfo.bTxBusyTraffic = bTxBusyTraffic;
-	pmlmepriv->LinkDetectInfo.bRxBusyTraffic = bRxBusyTraffic;
-	pmlmepriv->LinkDetectInfo.bHigherBusyTraffic = bHigherBusyTraffic;
-	pmlmepriv->LinkDetectInfo.bHigherBusyRxTraffic = bHigherBusyRxTraffic;
-	pmlmepriv->LinkDetectInfo.bHigherBusyTxTraffic = bHigherBusyTxTraffic;
+	ldi->NumRxOkInPeriod = 0;
+	ldi->NumTxOkInPeriod = 0;
+	ldi->NumRxUnicastOkInPeriod = 0;
+	ldi->bBusyTraffic = bBusyTraffic;
+	ldi->bTxBusyTraffic = bTxBusyTraffic;
+	ldi->bRxBusyTraffic = bRxBusyTraffic;
+	ldi->bHigherBusyTraffic = bHigherBusyTraffic;
+	ldi->bHigherBusyRxTraffic = bHigherBusyRxTraffic;
+	ldi->bHigherBusyTxTraffic = bHigherBusyTxTraffic;
 }
 
 static void dynamic_chk_wk_hdl(struct rtw_adapter *padapter, u8 *pbuf, int sz)


