Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbaFSWIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 18:08:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaFSWIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 18:08:53 -0400
Date: Thu, 19 Jun 2014 15:12:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaitanya Hazarey <c@24.io>
Cc: dan.carpenter@oracle.com, burzalodowa@gmail.com, andrea.merello@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Staging: rtl8192u: r8192U_wx.c Removed commented
 dead code
Message-ID: <20140619221253.GA5993@kroah.com>
References: <1401396321-29363-1-git-send-email-c@24.io>
 <1401396321-29363-5-git-send-email-c@24.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401396321-29363-5-git-send-email-c@24.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 01:45:21PM -0700, Chaitanya Hazarey wrote:
> Removed dead code from the file.
> 
> Signed-off-by: Chaitanya Hazarey <c@24.io>
> ---
>  drivers/staging/rtl8192u/r8192U_wx.c | 18 +-----------------
>  1 file changed, 1 insertion(+), 17 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
> index 09b1e81..ceb06d8 100644
> --- a/drivers/staging/rtl8192u/r8192U_wx.c
> +++ b/drivers/staging/rtl8192u/r8192U_wx.c
> @@ -516,12 +516,9 @@ static int r8192_wx_set_enc(struct net_device *dev,
>  	struct r8192_priv *priv = ieee80211_priv(dev);
>  	struct ieee80211_device *ieee = priv->ieee80211;
>  	int ret;
> -
> -	/* u32 TargetContent; */
>  	u32 hwkey[4] = {0, 0, 0, 0};
>  	u8 mask = 0xff;
>  	u32 key_idx = 0;
> -	/* u8 broadcast_addr[6] ={	0xff,0xff,0xff,0xff,0xff,0xff}; */
>  	u8 zero_addr[4][6] = {	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
>  				{0x00, 0x00, 0x00, 0x00, 0x00, 0x01},
>  				{0x00, 0x00, 0x00, 0x00, 0x00, 0x02},
> @@ -667,14 +664,6 @@ static int r8192_wx_set_retry(struct net_device *dev,
>  	 */
>  
>  	rtl8192_commit(dev);
> -	/*
> -	if(priv->up){
> -		rtl8180_rtx_disable(dev);
> -		rtl8180_rx_enable(dev);
> -		rtl8180_tx_enable(dev);
> -
> -	}
> -	*/
>  exit:
>  	up(&priv->wx_sem);
>  
> @@ -953,14 +942,9 @@ static const struct iw_priv_args r8192_private_args[] = {
>  
>  
>  static iw_handler r8192_private_handler[] = {
> -	/* r8192_wx_set_monitor, */ /* SIOCIWFIRSTPRIV */
> -	r8192_wx_set_crcmon,   /*SIOCIWSECONDPRIV*/
> -	/* r8192_wx_set_forceassociate, */
> -	/* r8192_wx_set_beaconinterval, */
> -	/* r8192_wx_set_monitor_type, */
> +	r8192_wx_set_crcmon, 
>  	r8192_wx_set_scan_type,
>  	r8192_wx_set_rawtx,
> -	/* r8192_wx_null, */
>  	r8192_wx_force_reset,
>  };

This patch adds a checkpatch error, so I can't take it :(

