Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaKGPqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 10:46:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbaKGPql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 10:46:41 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: "Sharma\, Sanjeev" <Sanjeev_Sharma@mentor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging:rtl8723au: core: Fix Warning reported by checkpatch.
References: <wrfjy4rxzk5b.fsf@redhat.com>
	<1415255796-8471-1-git-send-email-sanjeev_sharma@mentor.com>
	<20141106154301.GC19605@kroah.com>
	<FDC088D3B5555644AE135ED28A7ABDE950E8B904@EU-MBX-02.mgc.mentorg.com>
Date: Fri, 07 Nov 2014 10:46:18 -0500
In-Reply-To: <FDC088D3B5555644AE135ED28A7ABDE950E8B904@EU-MBX-02.mgc.mentorg.com>
	(Sanjeev Sharma's message of "Fri, 7 Nov 2014 12:00:19 +0000")
Message-ID: <wrfj61er2eut.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com> writes:
> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org] 
> Sent: Thursday, November 06, 2014 9:13 PM
> To: Sharma, Sanjeev
> Cc: Larry.Finger@lwfinger.net; Jes.Sorensen@redhat.com;
> devel@driverdev.osuosl.org; linux-wireless@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] staging:rtl8723au: core: Fix Warning reported by
> checkpatch.
>
> On Thu, Nov 06, 2014 at 12:06:36PM +0530, Sanjeev Sharma wrote:
>> This is a patch to the rtw_cmd.c file that fixes following Warning by 
>> introducing temporary structure.
>> 
>> WARNING: line over 80 characters
>> 
>> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
>> ---
>>  drivers/staging/rtl8723au/core/rtw_cmd.c | 123 
>> +++++++++++++++----------------
>>  1 file changed, 60 insertions(+), 63 deletions(-)
>
> Same as the other patch, give us a hint as to the warning in the subject.
>
> This patch is Fix of Warning introduced in Previous patch while fixing " ERROR: spaces required around that '>' (ctx:WxV)".Can I mentioned dependency or hint in subject line or do we have
> another way to described these type of fix.(One patch introduced another Warning/Error)

When replying to these messages, please do it properly with proper
quoting. Do NOT resend other peoples' emails with just an
"-----Original Message-----" line and no comments and no indentation of
the message you respond to.

If you have any questions, please read:
https://www.ietf.org/rfc/rfc1855.txt

Jes

>
>> 
>> diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c 
>> b/drivers/staging/rtl8723au/core/rtw_cmd.c
>> index 4eaa502..6186575 100644
>> --- a/drivers/staging/rtl8723au/core/rtw_cmd.c
>> +++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
>> @@ -919,34 +919,34 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
>>  	u8 bHigherBusyTxTraffic = false;
>>  	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
>>  	int BusyThreshold = 100;
>> +	struct rt_link_detect *ldi = &pmlmepriv->LinkDetectInfo;
>> +
>>  	/*  */
>>  	/*  Determine if our traffic is busy now */
>>  	/*  */
>>  	if (check_fwstate(pmlmepriv, _FW_LINKED)) {
>>  		if (rtl8723a_BT_coexist(padapter))
>>  			BusyThreshold = 50;
>> -		else if (pmlmepriv->LinkDetectInfo.bBusyTraffic)
>> +		else if (ldi->bBusyTraffic)
>>  			BusyThreshold = 75;
>>  		/*  if we raise bBusyTraffic in last watchdog, using
>>  		    lower threshold. */
>> -		if (pmlmepriv->LinkDetectInfo.NumRxOkInPeriod > BusyThreshold ||
>> -		    pmlmepriv->LinkDetectInfo.NumTxOkInPeriod > BusyThreshold) {
>> +		if (ldi->NumRxOkInPeriod > BusyThreshold ||
>> +		    ldi->NumTxOkInPeriod > BusyThreshold) {
>>  			bBusyTraffic = true;
>>  
>> -			if (pmlmepriv->LinkDetectInfo.NumRxOkInPeriod >
>> -			    pmlmepriv->LinkDetectInfo.NumTxOkInPeriod)
>> +			if (ldi->NumRxOkInPeriod > ldi->NumTxOkInPeriod)
>>  				bRxBusyTraffic = true;
>>  			else
>>  				bTxBusyTraffic = true;
>>  		}
>>  
>>  		/*  Higher Tx/Rx data. */
>> -		if (pmlmepriv->LinkDetectInfo.NumRxOkInPeriod > 4000 ||
>> -		    pmlmepriv->LinkDetectInfo.NumTxOkInPeriod > 4000) {
>> +		if (ldi->NumRxOkInPeriod > 4000 ||
>> +		    ldi->NumTxOkInPeriod > 4000) {
>>  			bHigherBusyTraffic = true;
>>  
>> -			if (pmlmepriv->LinkDetectInfo.NumRxOkInPeriod >
>> -			    pmlmepriv->LinkDetectInfo.NumTxOkInPeriod)
>> +			if (ldi->NumRxOkInPeriod > ldi->NumTxOkInPeriod)
>>  				bHigherBusyRxTraffic = true;
>>  			else
>>  				bHigherBusyTxTraffic = true;
>> @@ -955,9 +955,9 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
>>  		if (!rtl8723a_BT_coexist(padapter) ||
>>  		    !rtl8723a_BT_using_antenna_1(padapter)) {
>>  		/*  check traffic for  powersaving. */
>> -			if (((pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod +
>> -			      pmlmepriv->LinkDetectInfo.NumTxOkInPeriod) > 8) ||
>> -			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod >2)
>> +			if (((ldi->NumRxUnicastOkInPeriod +
>> +			      ldi->NumTxOkInPeriod) > 8) ||
>> +			    ldi->NumRxUnicastOkInPeriod > 2)
>>  				bEnterPS = false;
>>  			else
>>  				bEnterPS = true;
>> @@ -971,15 +971,15 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
>>  	} else
>>  		LPS_Leave23a(padapter);
>>  
>> -	pmlmepriv->LinkDetectInfo.NumRxOkInPeriod = 0;
>> -	pmlmepriv->LinkDetectInfo.NumTxOkInPeriod = 0;
>> -	pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod = 0;
>> -	pmlmepriv->LinkDetectInfo.bBusyTraffic = bBusyTraffic;
>> -	pmlmepriv->LinkDetectInfo.bTxBusyTraffic = bTxBusyTraffic;
>> -	pmlmepriv->LinkDetectInfo.bRxBusyTraffic = bRxBusyTraffic;
>> -	pmlmepriv->LinkDetectInfo.bHigherBusyTraffic = bHigherBusyTraffic;
>> -	pmlmepriv->LinkDetectInfo.bHigherBusyRxTraffic = bHigherBusyRxTraffic;
>> -	pmlmepriv->LinkDetectInfo.bHigherBusyTxTraffic = bHigherBusyTxTraffic;
>> +	ldi->NumRxOkInPeriod = 0;
>> +	ldi->NumTxOkInPeriod = 0;
>> +	ldi->NumRxUnicastOkInPeriod = 0;
>> +	ldi->bBusyTraffic = bBusyTraffic;
>> +	ldi->bTxBusyTraffic = bTxBusyTraffic;
>> +	ldi->bRxBusyTraffic = bRxBusyTraffic;
>> +	ldi->bHigherBusyTraffic = bHigherBusyTraffic;
>> +	ldi->bHigherBusyRxTraffic = bHigherBusyRxTraffic;
>> +	ldi->bHigherBusyTxTraffic = bHigherBusyTxTraffic;
>>  }
>>  
>>  static void dynamic_chk_wk_hdl(struct rtw_adapter *padapter, u8 
>> *pbuf, int sz) @@ -1017,46 +1017,44 @@ static void lps_ctrl_wk_hdl(struct rtw_adapter *padapter, u8 lps_ctrl_type)
>>  	    check_fwstate(pmlmepriv, WIFI_ADHOC_STATE))
>>  		return;
>>  
>> -	switch (lps_ctrl_type)
>> -	{
>> -		case LPS_CTRL_SCAN:
>> -			rtl8723a_BT_wifiscan_notify(padapter, true);
>> -			if (!rtl8723a_BT_using_antenna_1(padapter)) {
>> -				if (check_fwstate(pmlmepriv, _FW_LINKED))
>> -					LPS_Leave23a(padapter);
>> -			}
>> -			break;
>> -		case LPS_CTRL_JOINBSS:
>> -			LPS_Leave23a(padapter);
>> -			break;
>> -		case LPS_CTRL_CONNECT:
>> -			mstatus = 1;/* connect */
>> -			/*  Reset LPS Setting */
>> -			padapter->pwrctrlpriv.LpsIdleCount = 0;
>> -			rtl8723a_set_FwJoinBssReport_cmd(padapter, 1);
>> -			rtl8723a_BT_mediastatus_notify(padapter, mstatus);
>> -			break;
>> -		case LPS_CTRL_DISCONNECT:
>> -			mstatus = 0;/* disconnect */
>> -			rtl8723a_BT_mediastatus_notify(padapter, mstatus);
>> -			if (!rtl8723a_BT_using_antenna_1(padapter))
>> -				LPS_Leave23a(padapter);
>> -			rtl8723a_set_FwJoinBssReport_cmd(padapter, 0);
>> -			break;
>> -		case LPS_CTRL_SPECIAL_PACKET:
>> -			pwrpriv->DelayLPSLastTimeStamp = jiffies;
>> -			rtl8723a_BT_specialpacket_notify(padapter);
>> -			if (!rtl8723a_BT_using_antenna_1(padapter))
>> -				LPS_Leave23a(padapter);
>> -			break;
>> -		case LPS_CTRL_LEAVE:
>> -			rtl8723a_BT_lps_leave(padapter);
>> -			if (!rtl8723a_BT_using_antenna_1(padapter))
>> +	switch (lps_ctrl_type) {
>> +	case LPS_CTRL_SCAN:
>> +		rtl8723a_BT_wifiscan_notify(padapter, true);
>> +		if (!rtl8723a_BT_using_antenna_1(padapter)) {
>> +			if (check_fwstate(pmlmepriv, _FW_LINKED))
>>  				LPS_Leave23a(padapter);
>
> You are doing more than one thing here, something you did not specify in your changelog above, which isn't ok :(
>
> Please fix up and resend.
>
> thanks,
>
> greg k-h
