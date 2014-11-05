Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaKELiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 06:38:11 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:44363 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaKELiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 06:38:08 -0500
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
CC: Joe Perches <joe@perches.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging:rtl8723au: core: Fix error reported by
 checkpatch.
Thread-Topic: [PATCH] staging:rtl8723au: core: Fix error reported by
 checkpatch.
Thread-Index: AQHP9FDfvV8vePNHPEKsRX+GA9Vg3JxR8NvQ
Date: Wed, 5 Nov 2014 11:38:03 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE950E8B16D@EU-MBX-02.mgc.mentorg.com>
References: <1414396745-8845-1-git-send-email-sanjeev_sharma@mentor.com>
	<wrfjioj5aonx.fsf@redhat.com> <1414421554.8884.7.camel@perches.com>
	<FDC088D3B5555644AE135ED28A7ABDE950E890CD@EU-MBX-02.mgc.mentorg.com>
 <wrfjy4rxzk5b.fsf@redhat.com>
In-Reply-To: <wrfjy4rxzk5b.fsf@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Jes Sorensen [mailto:Jes.Sorensen@redhat.com] 
Sent: Thursday, October 30, 2014 8:21 PM
To: Sharma, Sanjeev
Cc: Joe Perches; Larry.Finger@lwfinger.net; gregkh@linuxfoundation.org; linux-wireless@vger.kernel.org; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:rtl8723au: core: Fix error reported by checkpatch.

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
> A possible way to shorten these relatively long variable name/line 
> lengths is to use a temporary for
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
>  drivers/staging/rtl8723au/core/rtw_cmd.c | 46 
> ++++++++++++++++----------------
>  1 file changed, 23 insertions(+), 23 deletions(-)

This is fine with me.

Jes

Summited another patch after incorporating the change.

Sanjeev Sharma
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c 
> b/drivers/staging/rtl8723au/core/rtw_cmd.c
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
>  static void dynamic_chk_wk_hdl(struct rtw_adapter *padapter, u8 
> *pbuf, int sz)
