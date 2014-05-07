Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaEGUIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:08:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23492 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaEGUIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:08:42 -0400
Date: Wed, 7 May 2014 23:08:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, w-lkml@lebenslange-mailadresse.de,
        gregkh@linuxfoundation.org, peter.p.waskiewicz.jr@intel.com,
        oat.elena@gmail.com, linux-kernel@vger.kernel.org, teobaluta@gmail.com,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH v2 4/5] staging: rtl8188eu: fix potential leak in
 rtw_mp_SetRFPath()
Message-ID: <20140507200806.GW4963@mwanda>
References: <20140507212825.2289e00e@spike>
 <20140507213320.406d9958@spike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507213320.406d9958@spike>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 09:33:20PM +0200, Christian Engelmayer wrote:
> Function rtw_mp_SetRFPath() dynamically allocates a temporary buffer that
> is not freed in all error paths. Use a centralized exit path and make sure
> that all memory is freed correctly. Detected by Coverity - CID 1077714.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
>  drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
> index 8b1579b..ea5e1f8 100644
> --- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
> +++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
> @@ -7321,11 +7321,14 @@ static int rtw_mp_SetRFPath(struct net_device *dev,
>  	struct adapter *padapter = rtw_netdev_priv(dev);
>  	char	*input = kmalloc(wrqu->data.length, GFP_KERNEL);

You didn't introduce this so there is no need to resend but doing the
allocation in the declaration block is nasty style.  No one reads the
declaration block and it is a common cause of bugs.  For example, the
bug you are fixing here.  ;)

>  	u8 bMain = 1, bTurnoff = 1;
> +	int ret = 0;

regards,
dan carpenter


