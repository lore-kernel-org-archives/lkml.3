Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaJ0LNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:13:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44074 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaJ0LN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:13:28 -0400
Date: Mon, 27 Oct 2014 14:13:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8712: remove unused variables
Message-ID: <20141027111312.GA6879@mwanda>
References: <1414326813-21444-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414326813-21444-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 06:03:33PM +0530, Sudip Mukherjee wrote:
> @@ -262,7 +257,7 @@ static u8 rtl8712_dl_fw(struct _adapter *padapter)
>  		if (tmp8_a != (tmp8|BIT(2)))
>  			goto exit_fail;
>  
> -		tmp32 = r8712_read32(padapter, TCR);
> +		r8712_read32(padapter, TCR);

I wonder if we actually need to call r8712_read32() here?  It's not
clear.  The changelog should say one way or the other.  Maybe something
like "I left a call to r8712_read32(padapter, TCR) because I didn't know
if it had side effects".  When you note down questions you have in the
changelog that helps reviewers.

> --- a/drivers/staging/rtl8712/rtl871x_pwrctrl.c
> +++ b/drivers/staging/rtl8712/rtl871x_pwrctrl.c
> @@ -156,11 +156,9 @@ static void rpwm_workitem_callback(struct work_struct *work)
>  				       struct pwrctrl_priv, rpwm_workitem);
>  	struct _adapter *padapter = container_of(pwrpriv,
>  				    struct _adapter, pwrctrlpriv);
> -	u8 cpwm = pwrpriv->cpwm;
> -
>  	if (pwrpriv->cpwm != pwrpriv->rpwm) {
>  		_enter_pwrlock(&pwrpriv->lock);
> -		cpwm = r8712_read8(padapter, SDIO_HCPWM);
> +		r8712_read8(padapter, SDIO_HCPWM);

Same here.

>  		pwrpriv->rpwm_retry = 1;
>  		r8712_set_rpwm(padapter, pwrpriv->rpwm);
>  		up(&pwrpriv->lock);

regards,
dan carpenter
