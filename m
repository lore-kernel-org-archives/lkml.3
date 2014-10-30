Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564AbaJ3Oux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:50:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbaJ3Ouw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:50:52 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: "Sharma\, Sanjeev" <Sanjeev_Sharma@mentor.com>
Cc: Joe Perches <joe@perches.com>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging:rtl8723au: core: Fix error reported by checkpatch.
References: <1414396745-8845-1-git-send-email-sanjeev_sharma@mentor.com>
	<wrfjioj5aonx.fsf@redhat.com> <1414421554.8884.7.camel@perches.com>
	<FDC088D3B5555644AE135ED28A7ABDE950E890CD@EU-MBX-02.mgc.mentorg.com>
Date: Thu, 30 Oct 2014 15:50:40 +0100
In-Reply-To: <FDC088D3B5555644AE135ED28A7ABDE950E890CD@EU-MBX-02.mgc.mentorg.com>
	(Sanjeev Sharma's message of "Wed, 29 Oct 2014 06:35:12 +0000")
Message-ID: <wrfjy4rxzk5b.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com> writes:
> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com] 
> Sent: Monday, October 27, 2014 8:23 PM
> To: Jes Sorensen
> Cc: Sharma, Sanjeev; Larry.Finger@lwfinger.net;
> gregkh@linuxfoundation.org; linux-wireless@vger.kernel.org;
> devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] staging:rtl8723au: core: Fix error reported by checkpatch.
>
> On Mon, 2014-10-27 at 09:43 +0100, Jes Sorensen wrote:
>> Sanjeev Sharma <sanjeev_sharma@mentor.com> writes:
>> > This is a patch to the rtw_cmd.c file that fixes Error reported by 
>> > checkpatch.
> []
>> > diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c 
>> > b/drivers/staging/rtl8723au/core/rtw_cmd.c
> []
>> > @@ -957,7 +957,7 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
>> >  		/*  check traffic for  powersaving. */
>> >  			if (((pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod +
>> >  			      pmlmepriv->LinkDetectInfo.NumTxOkInPeriod) > 8) ||
>> > -			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod >2)
>> > +			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod > 2)
>> >  				bEnterPS = false;
>> >  			else
>> >  				bEnterPS = true;
>> 
>> This makes the line longer than 80 characters, that is worse than the 
>> 'problem' you are fixing.
>
> The code already has dozens of long lines already.
>
> This is generally a problem because the variable names are pretty long so strict 80 column adherence generally isn't possible.
>
> A possible way to shorten these relatively long variable name/line lengths is to use a temporary for
>
> 	pmlmeprv->LinkDetectInfo
>
> 	struct rt_link_detect *ldi = &pmlmeprv->LinkDetectInfo;
>
> so:
>
> I am agree on this approach but Let's wait for Jes opinion on it.
>
> Sanjeev Sharma
>
>  drivers/staging/rtl8723au/core/rtw_cmd.c | 46 ++++++++++++++++----------------
>  1 file changed, 23 insertions(+), 23 deletions(-)

This is fine with me.

Jes

>
> diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
> index d2d7edf..1b24945 100644
> --- a/drivers/staging/rtl8723au/core/rtw_cmd.c
> +++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
> @@ -922,34 +922,33 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
>  	u8 bHigherBusyTxTraffic = false;
>  	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
>  	int BusyThreshold = 100;
> +	struct rt_link_detect *ldi = &pmlmepriv->LinkDetectInfo;
> +
>  	/*  */
>  	/*  Determine if our traffic is busy now */
>  	/*  */
>  	if (check_fwstate(pmlmepriv, _FW_LINKED)) {
>  		if (rtl8723a_BT_coexist(padapter))
>  			BusyThreshold = 50;
> -		else if (pmlmepriv->LinkDetectInfo.bBusyTraffic)
> +		else if (ldi->bBusyTraffic)
>  			BusyThreshold = 75;
>  		/*  if we raise bBusyTraffic in last watchdog, using
>  		    lower threshold. */
> -		if (pmlmepriv->LinkDetectInfo.NumRxOkInPeriod > BusyThreshold ||
> -		    pmlmepriv->LinkDetectInfo.NumTxOkInPeriod > BusyThreshold) {
> +		if (ldi->NumRxOkInPeriod > BusyThreshold ||
> +		    ldi->NumTxOkInPeriod > BusyThreshold) {
>  			bBusyTraffic = true;
>  
> -			if (pmlmepriv->LinkDetectInfo.NumRxOkInPeriod >
> -			    pmlmepriv->LinkDetectInfo.NumTxOkInPeriod)
> +			if (ldi->NumRxOkInPeriod > ldi->NumTxOkInPeriod)
>  				bRxBusyTraffic = true;
>  			else
>  				bTxBusyTraffic = true;
>  		}
>  
>  		/*  Higher Tx/Rx data. */
> -		if (pmlmepriv->LinkDetectInfo.NumRxOkInPeriod > 4000 ||
> -		    pmlmepriv->LinkDetectInfo.NumTxOkInPeriod > 4000) {
> +		if (ldi->NumRxOkInPeriod > 4000 ||
> +		    ldi->NumTxOkInPeriod > 4000) {
>  			bHigherBusyTraffic = true;
> -
> -			if (pmlmepriv->LinkDetectInfo.NumRxOkInPeriod >
> -			    pmlmepriv->LinkDetectInfo.NumTxOkInPeriod)
> +			if (ldi->NumRxOkInPeriod > ldi->NumTxOkInPeriod)
>  				bHigherBusyRxTraffic = true;
>  			else
>  				bHigherBusyTxTraffic = true;
> @@ -958,9 +957,9 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
>  		if (!rtl8723a_BT_coexist(padapter) ||
>  		    !rtl8723a_BT_using_antenna_1(padapter)) {
>  		/*  check traffic for  powersaving. */
> -			if (((pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod +
> -			      pmlmepriv->LinkDetectInfo.NumTxOkInPeriod) > 8) ||
> -			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod >2)
> +			if (((ldi->NumRxUnicastOkInPeriod +
> +			      ldi->NumTxOkInPeriod) > 8) ||
> +			    ldi->NumRxUnicastOkInPeriod > 2)
>  				bEnterPS = false;
>  			else
>  				bEnterPS = true;
> @@ -971,18 +970,19 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
>  			else
>  				LPS_Leave23a(padapter);
>  		}
> -	} else
> +	} else {
>  		LPS_Leave23a(padapter);
> +	}
>  
> -	pmlmepriv->LinkDetectInfo.NumRxOkInPeriod = 0;
> -	pmlmepriv->LinkDetectInfo.NumTxOkInPeriod = 0;
> -	pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod = 0;
> -	pmlmepriv->LinkDetectInfo.bBusyTraffic = bBusyTraffic;
> -	pmlmepriv->LinkDetectInfo.bTxBusyTraffic = bTxBusyTraffic;
> -	pmlmepriv->LinkDetectInfo.bRxBusyTraffic = bRxBusyTraffic;
> -	pmlmepriv->LinkDetectInfo.bHigherBusyTraffic = bHigherBusyTraffic;
> -	pmlmepriv->LinkDetectInfo.bHigherBusyRxTraffic = bHigherBusyRxTraffic;
> -	pmlmepriv->LinkDetectInfo.bHigherBusyTxTraffic = bHigherBusyTxTraffic;
> +	ldi->NumRxOkInPeriod = 0;
> +	ldi->NumTxOkInPeriod = 0;
> +	ldi->NumRxUnicastOkInPeriod = 0;
> +	ldi->bBusyTraffic = bBusyTraffic;
> +	ldi->bTxBusyTraffic = bTxBusyTraffic;
> +	ldi->bRxBusyTraffic = bRxBusyTraffic;
> +	ldi->bHigherBusyTraffic = bHigherBusyTraffic;
> +	ldi->bHigherBusyRxTraffic = bHigherBusyRxTraffic;
> +	ldi->bHigherBusyTxTraffic = bHigherBusyTxTraffic;
>  }
>  
>  static void dynamic_chk_wk_hdl(struct rtw_adapter *padapter, u8 *pbuf, int sz)
