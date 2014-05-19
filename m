Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaESKwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:52:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36745 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaESKwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:52:32 -0400
Date: Mon, 19 May 2014 13:52:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navin.patidar@gmail.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/28] staging: rtl8188eu: Remove unused function
 rtl8188eu_ps_func()
Message-ID: <20140519105208.GV15585@mwanda>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
 <1400426361-19596-6-git-send-email-navin.patidar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400426361-19596-6-git-send-email-navin.patidar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 08:48:58PM +0530, navin patidar wrote:
> Signed-off-by: navin patidar <navin.patidar@gmail.com>
> ---
>  drivers/staging/rtl8188eu/hal/usb_halinit.c |    8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
> index 1a83d31..4c3f8c8 100644
> --- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
> +++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
> @@ -2231,12 +2231,6 @@ static void rtl8188eu_init_default_value(struct adapter *adapt)
>  		haldata->odmpriv.RFCalibrateInfo.ThermalValue_HP[i] = 0;
>  }
>  
> -static u8 rtl8188eu_ps_func(struct adapter *Adapter, enum hal_intf_ps_func efunc_id, u8 *val)
> -{
> -	u8 bResult = true;
> -	return bResult;
> -}
> -
>  void rtl8188eu_set_hal_ops(struct adapter *adapt)
>  {
>  	struct hal_ops	*halfunc = &adapt->HalFunc;
> @@ -2277,7 +2271,5 @@ void rtl8188eu_set_hal_ops(struct adapter *adapt)
>  	halfunc->hal_xmit = &rtl8188eu_hal_xmit;
>  	halfunc->mgnt_xmit = &rtl8188eu_mgnt_xmit;
>  
> -	halfunc->interface_ps_func = &rtl8188eu_ps_func;

No, this is used.  See rtw_hal_intf_ps_func().

drivers/staging/rtl8188eu/hal/hal_intf.c
   210  u8 rtw_hal_intf_ps_func(struct adapter *adapt,
   211                          enum hal_intf_ps_func efunc_id, u8 *val)
   212  {
   213          if (adapt->HalFunc.interface_ps_func)
   214                  return adapt->HalFunc.interface_ps_func(adapt, efunc_id,
   215                                                             val);
   216          return _FAIL;
   217  }

You have changed it to return _FAIL instead of true.  Perhaps that is ok
but you need to explain it in the changelog.

regards,
dan carpenter

