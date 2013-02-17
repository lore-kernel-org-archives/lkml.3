Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab3BQOtd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 09:49:33 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:3367 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250Ab3BQOtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 09:49:31 -0500
Message-ID: <5120EDF8.7010503@bfs.de>
Date: Sun, 17 Feb 2013 15:49:28 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Kumar Amit Mehta <gmate.amit@gmail.com>
CC: jdmason@kudzu.us, davem@davemloft.net, joe@perches.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ethernet: neterion: vxge: vxge-traffic.c: fix for a potential
 NULL pointer dereference
References: <1361037394-14731-1-git-send-email-gmate.amit@gmail.com>
In-Reply-To: <1361037394-14731-1-git-send-email-gmate.amit@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 16.02.2013 18:56, schrieb Kumar Amit Mehta:
> fix for a potential NULL pointer dereference and removal of a redundant
> assignment operation. Found using smatch.
> 
> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
> ---
>  drivers/net/ethernet/neterion/vxge/vxge-traffic.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/neterion/vxge/vxge-traffic.c b/drivers/net/ethernet/neterion/vxge/vxge-traffic.c
> index 99749bd..adb05a8 100644
> --- a/drivers/net/ethernet/neterion/vxge/vxge-traffic.c
> +++ b/drivers/net/ethernet/neterion/vxge/vxge-traffic.c
> @@ -611,11 +611,8 @@ __vxge_hw_vpath_alarm_process(struct __vxge_hw_virtualpath *vpath,
>  	struct vxge_hw_vpath_stats_sw_info *sw_stats;
>  	struct vxge_hw_vpath_reg __iomem *vp_reg;
>  
> -	if (vpath == NULL) {
> -		alarm_event = VXGE_HW_SET_LEVEL(VXGE_HW_EVENT_UNKNOWN,
> -			alarm_event);
> +	if (vpath == NULL)
>  		goto out2;
> -	}
>  
>  	hldev = vpath->hldev;
>  	vp_reg = vpath->vp_reg;
> @@ -852,13 +849,12 @@ __vxge_hw_vpath_alarm_process(struct __vxge_hw_virtualpath *vpath,
>  	}
>  out:
>  	hldev->stats.sw_dev_err_stats.vpath_alarms++;
> +	__vxge_hw_device_handle_error(hldev, vpath->vp_id, alarm_event);
>  out2:
>  	if ((alarm_event == VXGE_HW_EVENT_ALARM_CLEARED) ||
>  		(alarm_event == VXGE_HW_EVENT_UNKNOWN))
>  		return VXGE_HW_OK;
>  
> -	__vxge_hw_device_handle_error(hldev, vpath->vp_id, alarm_event);
> -
>  	if (alarm_event == VXGE_HW_EVENT_SERR)
>  		return VXGE_HW_ERR_CRITICAL;
>  

the patch looks ok.
it would be nice if someone would rewrite the if (alarm_event == x ) stuff
using switch or more if()'s it is hardly readable this way.

just my 2 cents,
re,
 wh
