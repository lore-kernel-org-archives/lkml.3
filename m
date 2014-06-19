Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaFSUJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:09:56 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49580 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaFSUJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:09:54 -0400
Date: Thu, 19 Jun 2014 13:09:47 -0700
From: josh@joshtriplett.org
To: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
Cc: devel@linuxdriverproject.org,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Himangi Saraogi <himangi774@gmail.com>,
        Vitaly Osipov <vitaly.osipov@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] wlan-ng/prism2mgmt:checkpatch: Fix string split
Message-ID: <20140619200947.GA16404@cloud>
References: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
 <1403205620-10219-2-git-send-email-Johannes.Stadlinger@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403205620-10219-2-git-send-email-Johannes.Stadlinger@fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:20:14PM +0200, Johannes Stadlinger wrote:
> This patch fixes all warnings of checkpatch about string splitting.
> 
> Signed-off-by: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
> Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
> CC: linux-kernel@i4.cs.fau.de
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Himangi Saraogi <himangi774@gmail.com>
> CC: Josh Triplett <josh@joshtriplett.org>
> CC: Vitaly Osipov <vitaly.osipov@gmail.com>
> CC: devel@driverdev.osuosl.org
> CC: linux-kernel@vger.kernel.org

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/staging/wlan-ng/prism2mgmt.c | 26 ++++++++++----------------
>  1 file changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
> index 36a3e1a..f90f7da 100644
> --- a/drivers/staging/wlan-ng/prism2mgmt.c
> +++ b/drivers/staging/wlan-ng/prism2mgmt.c
> @@ -178,8 +178,7 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
>  					     word);
>  		if (result) {
>  			netdev_warn(wlandev->netdev,
> -				    "Passive scan not supported with "
> -				    "current firmware.  (<1.5.1)\n");
> +				    "Passive scan not supported with current firmware.  (<1.5.1)\n");
>  		}
>  	}
>  
> @@ -381,8 +380,7 @@ int prism2mgmt_scan_results(wlandevice_t *wlandev, void *msgp)
>  
>  	if (!hw->scanresults) {
>  		netdev_err(wlandev->netdev,
> -			   "dot11req_scan_results can only be used after "
> -			   "a successful dot11req_scan.\n");
> +			   "dot11req_scan_results can only be used after a successful dot11req_scan.\n");
>  		result = 2;
>  		req->resultcode.data = P80211ENUM_resultcode_invalid_parameters;
>  		goto exit;
> @@ -733,8 +731,8 @@ int prism2mgmt_readpda(wlandevice_t *wlandev, void *msgp)
>  					      HFA384x_PDA_LEN_MAX);
>  		if (result) {
>  			netdev_err(wlandev->netdev,
> -				   "hfa384x_drvr_readpda() failed, "
> -				   "result=%d\n", result);
> +				   "hfa384x_drvr_readpda() failed, result=%d\n",
> +				   result);
>  
>  			msg->resultcode.data =
>  			    P80211ENUM_resultcode_implementation_failure;
> @@ -782,8 +780,7 @@ int prism2mgmt_ramdl_state(wlandevice_t *wlandev, void *msgp)
>  
>  	if (wlandev->msdstate != WLAN_MSD_FWLOAD) {
>  		netdev_err(wlandev->netdev,
> -			   "ramdl_state(): may only be called "
> -			   "in the fwload state.\n");
> +			   "ramdl_state(): may only be called in the fwload state.\n");
>  		msg->resultcode.data =
>  		    P80211ENUM_resultcode_implementation_failure;
>  		msg->resultcode.status = P80211ENUM_msgitem_status_data_ok;
> @@ -841,8 +838,7 @@ int prism2mgmt_ramdl_write(wlandevice_t *wlandev, void *msgp)
>  
>  	if (wlandev->msdstate != WLAN_MSD_FWLOAD) {
>  		netdev_err(wlandev->netdev,
> -			   "ramdl_write(): may only be called "
> -			   "in the fwload state.\n");
> +			   "ramdl_write(): may only be called in the fwload state.\n");
>  		msg->resultcode.data =
>  		    P80211ENUM_resultcode_implementation_failure;
>  		msg->resultcode.status = P80211ENUM_msgitem_status_data_ok;
> @@ -901,8 +897,7 @@ int prism2mgmt_flashdl_state(wlandevice_t *wlandev, void *msgp)
>  
>  	if (wlandev->msdstate != WLAN_MSD_FWLOAD) {
>  		netdev_err(wlandev->netdev,
> -			   "flashdl_state(): may only be called "
> -			   "in the fwload state.\n");
> +			   "flashdl_state(): may only be called in the fwload state.\n");
>  		msg->resultcode.data =
>  		    P80211ENUM_resultcode_implementation_failure;
>  		msg->resultcode.status = P80211ENUM_msgitem_status_data_ok;
> @@ -936,8 +931,8 @@ int prism2mgmt_flashdl_state(wlandevice_t *wlandev, void *msgp)
>  		result = prism2sta_ifstate(wlandev, P80211ENUM_ifstate_fwload);
>  		if (result != P80211ENUM_resultcode_success) {
>  			netdev_err(wlandev->netdev,
> -				   "prism2sta_ifstate(fwload) failed,"
> -				   "P80211ENUM_resultcode=%d\n", result);
> +				   "prism2sta_ifstate(fwload) failed, P80211ENUM_resultcode=%d\n",
> +				   result);
>  			msg->resultcode.data =
>  			    P80211ENUM_resultcode_implementation_failure;
>  			result = -1;
> @@ -975,8 +970,7 @@ int prism2mgmt_flashdl_write(wlandevice_t *wlandev, void *msgp)
>  
>  	if (wlandev->msdstate != WLAN_MSD_FWLOAD) {
>  		netdev_err(wlandev->netdev,
> -			   "flashdl_write(): may only be called "
> -			   "in the fwload state.\n");
> +			   "flashdl_write(): may only be called in the fwload state.\n");
>  		msg->resultcode.data =
>  		    P80211ENUM_resultcode_implementation_failure;
>  		msg->resultcode.status = P80211ENUM_msgitem_status_data_ok;
> -- 
> 1.9.1
> 
