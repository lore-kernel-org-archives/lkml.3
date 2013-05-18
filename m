Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3ERVKV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 17:10:21 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:42240 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab3ERVKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 17:10:16 -0400
Date: Sat, 18 May 2013 23:10:12 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Petko Manolov <petkan@nucleusys.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers: net: usb: rtl8150: bug fixing and cleanup
Message-ID: <20130518211012.GC26590@electric-eye.fr.zoreil.com>
References: <alpine.DEB.2.02.1305181905100.7518@fry.nucleusys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305181905100.7518@fry.nucleusys.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petko Manolov <petkan@nucleusys.com> :
[...]
>  static int set_registers(rtl8150_t * dev, u16 indx, u16 size, void *data)
>  {
> -	return usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
> -			       RTL8150_REQ_SET_REGS, RTL8150_REQT_WRITE,
> -			       indx, 0, data, size, 500);
> +	int res;
> +
> +	res = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
> +			      RTL8150_REQ_SET_REGS, RTL8150_REQT_WRITE,
> +			      indx, 0, data, size, 500);
> +	if (res < 0)
> +		dev_dbg(&dev->udev->dev, "%s returned %d\n", __func__, res);
> +	return res;

You may move it into a separate patch. It is completely unrelated to the
ctrl_urb changes.

[...]
> +static int async_set_registers(rtl8150_t *dev, u16 indx, u16 size, u16 reg)
>  {

[...]
> +	usb_fill_control_urb(async_urb, dev->udev,
> +	                     usb_sndctrlpipe(dev->udev, 0), (void *) &req->dr,

Useless void * cast.

-- 
Ueimor
