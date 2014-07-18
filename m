Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945975AbaGRTJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:09:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55822 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030665AbaGRTJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:09:48 -0400
Date: Fri, 18 Jul 2014 15:09:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nicholas Krause <xerofoify@gmail.com>
cc: gregkh@linuxfoundation.org, <mail@beyermatthias.de>, <hdegoede@redhat.com>,
        <dan.j.williams@intel.com>, <valentine.barshak@cogentembedded.com>,
        <ming.lei@canonical.com>, <michael.opdenacker@free-electrons.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb-core: Remove Fix mes in file hcd.c
In-Reply-To: <1405704880-10036-1-git-send-email-xerofoify@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1407181509210.979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014, Nicholas Krause wrote:

> I am removing two fix mes in this file as after dicussing then it  seems
> there is no reason to check against Null for usb_device as it can never
> be NULL and this is check is therefore not needed.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/usb/core/hcd.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index bec31e2..487abcf 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -855,8 +855,6 @@ static ssize_t authorized_default_show(struct device *dev,
>  	struct usb_bus *usb_bus = rh_usb_dev->bus;
>  	struct usb_hcd *usb_hcd;
>  
> -	if (usb_bus == NULL)	/* FIXME: not sure if this case is possible */
> -		return -ENODEV;
>  	usb_hcd = bus_to_hcd(usb_bus);
>  	return snprintf(buf, PAGE_SIZE, "%u\n", usb_hcd->authorized_default);
>  }
> @@ -871,8 +869,6 @@ static ssize_t authorized_default_store(struct device *dev,
>  	struct usb_bus *usb_bus = rh_usb_dev->bus;
>  	struct usb_hcd *usb_hcd;
>  
> -	if (usb_bus == NULL)	/* FIXME: not sure if this case is possible */
> -		return -ENODEV;
>  	usb_hcd = bus_to_hcd(usb_bus);
>  	result = sscanf(buf, "%u\n", &val);
>  	if (result == 1) {

Acked-by: Alan Stern <stern@rowland.harvard.edu>

