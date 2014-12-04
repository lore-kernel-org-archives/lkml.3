Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaLDJeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:34:13 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:46862 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaLDJeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:34:11 -0500
Message-ID: <54802A93.3000103@gmail.com>
Date: Thu, 04 Dec 2014 17:34:11 +0800
From: Fred Chou <fred.chou.nd@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: rtl8192u: fix sparse warnings
References: <1417661443-17574-1-git-send-email-fred.chou.nd@gmail.com> <20141204073437.GA4311@sudip-PC> <5480177F.90309@gmail.com> <20141204083042.GA15299@sudip-PC>
In-Reply-To: <20141204083042.GA15299@sudip-PC>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 4/12/2014 4:30 PM, Sudip Mukherjee wrote:
> On Thu, Dec 04, 2014 at 04:12:47PM +0800, Fred Chou wrote:
>>
>>
>> On 4/12/2014 3:34 PM, Sudip Mukherjee wrote:
>>> On Thu, Dec 04, 2014 at 10:50:43AM +0800, Fred Chou wrote:
>>>> From: Fred Chou <fred.chou.nd@gmail.com>
>>>>
>>>> Fixed the following warnings in sparse:
>>>>
>>>> drivers/staging/rtl8192u/r8192U_core.c:670:6: warning:
>>>>  	symbol 'dump_eprom' was not declared.
>>>> 	Should it be static?
>>>> drivers/staging/rtl8192u/r8192U_core.c:1489:5: warning:
>>>>  	symbol 'ComputeTxTime' was not declared.
>>>> 	Should it be static?
>>>> drivers/staging/rtl8192u/r8192U_core.c:1556:14: warning:
>>>> 	symbol 'txqueue2outpipe' was not declared.
>>>> 	Should it be static?
>>>> drivers/staging/rtl8192u/r8192U_core.c:4876:5: warning:
>>>> 	symbol 'GetRxPacketShiftBytes819xUsb' was not declared.
>>>> 	Should it be static?
>>>>
>>>> Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>
>>>>
>>>> ---
>>>> change in v3: fixed alignment to match open parenthesis 
>>> have u fixed?
>>> your v2 was having one problem of alignment, but v3 is again having 3 problems.
>>> and your patch doesnot apply to next-20141203
>>>
>>
>> The alignment issue is fixed when I apply the patch against my local
>> kernel source tree. Wondering why there are still alignment problems.
>> Let me test with next-20141203 and send v4 again. My apologies...
> 
> i think you have created your v3 on top of your v2.
> reset the source before doing this one. and check the patch with checkpatch before sending.
> 
> thanks
> sudip

v3 is created from scratch. I removed the v2 patch when formatting the
patch. checkpatch.pl does not report any zeros or warnings for both v2
and v3, and the alignment looks all right to me. That makes me very
confused.


>>
>> Fred
>>
>>> sudip
>>>
>>>>
>>>>  drivers/staging/rtl8192u/r8192U_core.c | 12 +++++++-----
>>>>  1 file changed, 7 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
>>>> index 7640386..2c61801 100644
>>>> --- a/drivers/staging/rtl8192u/r8192U_core.c
>>>> +++ b/drivers/staging/rtl8192u/r8192U_core.c
>>>> @@ -667,7 +667,7 @@ static void tx_timeout(struct net_device *dev)
>>>>  
>>>>  
>>>>  /* this is only for debug */
>>>> -void dump_eprom(struct net_device *dev)
>>>> +static void dump_eprom(struct net_device *dev)
>>>>  {
>>>>  	int i;
>>>>  	for (i = 0; i < 63; i++)
>>>> @@ -1486,8 +1486,8 @@ inline u8 rtl8192_IsWirelessBMode(u16 rate)
>>>>  
>>>>  u16 N_DBPSOfRate(u16 DataRate);
>>>>  
>>>> -u16 ComputeTxTime(u16 FrameLength, u16 DataRate, u8 bManagementFrame,
>>>> -		  u8 bShortPreamble)
>>>> +static u16 ComputeTxTime(u16 FrameLength, u16 DataRate, u8 bManagementFrame,
>>>> +			  u8 bShortPreamble)
>>>>  {
>>>>  	u16	FrameTime;
>>>>  	u16	N_DBPS;
>>>> @@ -1553,7 +1553,8 @@ u16 N_DBPSOfRate(u16 DataRate)
>>>>  	return N_DBPS;
>>>>  }
>>>>  
>>>> -unsigned int txqueue2outpipe(struct r8192_priv *priv, unsigned int tx_queue)
>>>> +static unsigned int txqueue2outpipe(struct r8192_priv *priv,
>>>> +				     unsigned int tx_queue)
>>>>  {
>>>>  	if (tx_queue >= 9) {
>>>>  		RT_TRACE(COMP_ERR, "%s():Unknown queue ID!!!\n", __func__);
>>>> @@ -4873,7 +4874,8 @@ static void query_rxdesc_status(struct sk_buff *skb,
>>>>  
>>>>  }
>>>>  
>>>> -u32 GetRxPacketShiftBytes819xUsb(struct ieee80211_rx_stats  *Status, bool bIsRxAggrSubframe)
>>>> +static u32 GetRxPacketShiftBytes819xUsb(struct ieee80211_rx_stats  *Status,
>>>> +					 bool bIsRxAggrSubframe)
>>>>  {
>>>>  #ifdef USB_RX_AGGREGATION_SUPPORT
>>>>  	if (bIsRxAggrSubframe)
>>>> -- 
>>>> 1.9.1
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
