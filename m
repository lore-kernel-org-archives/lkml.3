Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaLCJQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:16:37 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62802 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaLCJQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:16:35 -0500
Date: Wed, 3 Dec 2014 14:45:01 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Fred Chou <fred.chou.nd@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: rt8192u: fix sparse warnings in r8192U_core.c
Message-ID: <20141203091501.GA2714@sudip-PC>
References: <1417588229-9552-1-git-send-email-fred.chou.nd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417588229-9552-1-git-send-email-fred.chou.nd@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 02:30:29PM +0800, Fred Chou wrote:
> From: Fred Chou <fred.chou.nd@gmail.com>
> 
> v2: alignment to match open parenthesis

this should not come in commit log, this should go as a comment below the ---

and this patch is not applying to next-20141201, maybe in staging-testing

> 
> Fixed the following warnings in sparse:
> drivers/staging/rtl8192u/r8192U_core.c:670:6: warning:
>  	symbol 'dump_eprom' was not declared.
> 	Should it be static?
> drivers/staging/rtl8192u/r8192U_core.c:1489:5: warning:
>  	symbol 'ComputeTxTime' was not declared.
> 	Should it be static?
> drivers/staging/rtl8192u/r8192U_core.c:1556:14: warning:
> 	symbol 'txqueue2outpipe' was not declared.
> 	Should it be static?
> drivers/staging/rtl8192u/r8192U_core.c:4876:5: warning:
> 	symbol 'GetRxPacketShiftBytes819xUsb' was not declared.
> 	Should it be static?
> 
> Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>
> ---
>  drivers/staging/rtl8192u/r8192U_core.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
> index 7640386..6b647ad 100644
> --- a/drivers/staging/rtl8192u/r8192U_core.c
> +++ b/drivers/staging/rtl8192u/r8192U_core.c
> @@ -667,7 +667,7 @@ static void tx_timeout(struct net_device *dev)
>  
>  
>  /* this is only for debug */
> -void dump_eprom(struct net_device *dev)
> +static void dump_eprom(struct net_device *dev)
>  {
>  	int i;
>  	for (i = 0; i < 63; i++)
> @@ -1486,7 +1486,7 @@ inline u8 rtl8192_IsWirelessBMode(u16 rate)
>  
>  u16 N_DBPSOfRate(u16 DataRate);
>  
> -u16 ComputeTxTime(u16 FrameLength, u16 DataRate, u8 bManagementFrame,
> +static u16 ComputeTxTime(u16 FrameLength, u16 DataRate, u8 bManagementFrame,
>  		  	  u8 bShortPreamble)
u missed this alignment

thanks
sudip
>  {
>  	u16	FrameTime;
> @@ -1553,7 +1553,8 @@ u16 N_DBPSOfRate(u16 DataRate)
>  	return N_DBPS;
>  }
>  
> -unsigned int txqueue2outpipe(struct r8192_priv *priv, unsigned int tx_queue)
> +static unsigned int txqueue2outpipe(struct r8192_priv *priv,
> +				     unsigned int tx_queue)
>  {
>  	if (tx_queue >= 9) {
>  		RT_TRACE(COMP_ERR, "%s():Unknown queue ID!!!\n", __func__);
> @@ -4873,7 +4874,8 @@ static void query_rxdesc_status(struct sk_buff *skb,
>  
>  }
>  
> -u32 GetRxPacketShiftBytes819xUsb(struct ieee80211_rx_stats  *Status, bool bIsRxAggrSubframe)
> +static u32 GetRxPacketShiftBytes819xUsb(struct ieee80211_rx_stats  *Status,
> +					 bool bIsRxAggrSubframe)
>  {
>  #ifdef USB_RX_AGGREGATION_SUPPORT
>  	if (bIsRxAggrSubframe)
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
