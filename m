Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaABOZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 09:25:40 -0500
Received: from canardo.mork.no ([148.122.252.1]:44766 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaABOZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 09:25:37 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Hayes Wang <hayeswang@realtek.com>
Cc: <oliver@neukum.org>, <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next v2 6/6] r8152: support RTL8153
Organization: m
References: <1388632963-1341-1-git-send-email-hayeswang@realtek.com>
	<1388633110-1435-1-git-send-email-hayeswang@realtek.com>
Date: Thu, 02 Jan 2014 15:25:13 +0100
In-Reply-To: <1388633110-1435-1-git-send-email-hayeswang@realtek.com> (Hayes
	Wang's message of "Thu, 2 Jan 2014 11:25:10 +0800")
Message-ID: <877gai8nqu.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> writes:

> Support new chip RTL8153 which is the USB 3.0 giga ethernet adapter.
>
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/cdc_ether.c |  10 +
>  drivers/net/usb/r8152.c     | 615 +++++++++++++++++++++++++++++++++++++++++++-
>  drivers/net/usb/r815x.c     |   2 +-
>  3 files changed, 621 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
> index 4b1c0f3..640406a 100644
> --- a/drivers/net/usb/cdc_ether.c
> +++ b/drivers/net/usb/cdc_ether.c
> @@ -486,6 +486,7 @@ static const struct driver_info wwan_info = {
>  #define ZTE_VENDOR_ID		0x19D2
>  #define DELL_VENDOR_ID		0x413C
>  #define REALTEK_VENDOR_ID	0x0bda
> +#define SAMSUNG_VENDOR_ID	0x04e8
>  
>  static const struct usb_device_id	products[] = {
>  /* BLACKLIST !!
> @@ -652,6 +653,15 @@ static const struct usb_device_id	products[] = {
>  	.driver_info = 0,
>  },
>  
> +#if defined(CONFIG_USB_RTL8152) || defined(CONFIG_USB_RTL8152_MODULE)
> +/* Samsung USB Ethernet Adapters */
> +{
> +	USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, 0xa101, USB_CLASS_COMM,
> +			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
> +	.driver_info = 0,
> +},
> +#endif


We don't play the if-other-driver-is-enabled for any other of the
blacklisted devices, including other devices supported by the RTL8152
driver.  Why do we need it here?



> diff --git a/drivers/net/usb/r815x.c b/drivers/net/usb/r815x.c
> index 2df2f4f..5fd2ca6 100644
> --- a/drivers/net/usb/r815x.c
> +++ b/drivers/net/usb/r815x.c
> @@ -226,7 +226,7 @@ static const struct usb_device_id products[] = {
>  {
>  	USB_DEVICE_AND_INTERFACE_INFO(REALTEK_VENDOR_ID, 0x8153, USB_CLASS_COMM,
>  			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
> -#if defined(CONFIG_USB_RTL8153) || defined(CONFIG_USB_RTL8153_MODULE)
> +#if defined(CONFIG_USB_RTL8152) || defined(CONFIG_USB_RTL8152_MODULE)
>  	.driver_info = 0,
>  #else
>  	.driver_info = (unsigned long) &r8153_info,

This hunk seems like a completely unrelated bugfix?  This should have
been a separate patch.


Bjørn
