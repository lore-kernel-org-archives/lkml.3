Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaGHI4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:56:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36809 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbaGHI4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:56:04 -0400
Date: Tue, 8 Jul 2014 11:55:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navin.patidar@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 02/13] staging: rtl8188eu: Remove function
 rtw_alloc_etherdev()
Message-ID: <20140708085554.GH25880@mwanda>
References: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
 <1404758413-12859-2-git-send-email-navin.patidar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404758413-12859-2-git-send-email-navin.patidar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 12:10:02AM +0530, navin patidar wrote:
> rtw_alloc_etherdev() is used in rtw_init_netdev() but never gets called
> because old_padapter is never NULL.
> 
> Signed-off-by: navin patidar <navin.patidar@gmail.com>
> ---
>  drivers/staging/rtl8188eu/include/osdep_service.h |    1 -
>  drivers/staging/rtl8188eu/os_dep/os_intfs.c       |    4 +---
>  drivers/staging/rtl8188eu/os_dep/osdep_service.c  |   23 ---------------------
>  3 files changed, 1 insertion(+), 27 deletions(-)
> 
> diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
> index 95131fe..a52dcd5 100644
> --- a/drivers/staging/rtl8188eu/include/osdep_service.h
> +++ b/drivers/staging/rtl8188eu/include/osdep_service.h
> @@ -164,7 +164,6 @@ struct rtw_netdev_priv_indicator {
>  };
>  struct net_device *rtw_alloc_etherdev_with_old_priv(int sizeof_priv,
>  						    void *old_priv);
> -struct net_device *rtw_alloc_etherdev(int sizeof_priv);
>  
>  #define rtw_netdev_priv(netdev)					\
>  	(((struct rtw_netdev_priv_indicator *)netdev_priv(netdev))->priv)
> diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
> index b0c38a4..c7a44ab 100644
> --- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
> +++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
> @@ -707,14 +707,12 @@ static const struct device_type wlan_type = {
>  struct net_device *rtw_init_netdev(struct adapter *old_padapter)
>  {
>  	struct adapter *padapter;
> -	struct net_device *pnetdev;
> +	struct net_device *pnetdev = NULL;
>  
>  	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("+init_net_dev\n"));
>  
>  	if (old_padapter != NULL)
>  		pnetdev = rtw_alloc_etherdev_with_old_priv(sizeof(struct adapter), (void *)old_padapter);

Next time just remove the pointless NULL check as well.  It still falls
under the one thing per patch rule because it's closely related.  It
makes the code more clear and it even makes the patch easier to review.

> -	else
> -		pnetdev = rtw_alloc_etherdev(sizeof(struct adapter));
>  

regards,
dan carpenter

