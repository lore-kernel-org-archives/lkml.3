Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbaIDHMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:12:09 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:62789 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbaIDHMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:12:07 -0400
MIME-Version: 1.0
In-Reply-To: <1409564362-27571-2-git-send-email-frans.klaver@xsens.com>
References: <1409564362-27571-1-git-send-email-frans.klaver@xsens.com>
	<1409564362-27571-2-git-send-email-frans.klaver@xsens.com>
Date: Thu, 4 Sep 2014 09:12:05 +0200
Message-ID: <CAH6sp9Me6wVTnNGn9Z4pLDsFyTz27EgcEvedF8PrcH-fw+awBQ@mail.gmail.com>
Subject: Re: [PATCH resend 2/2] usb: serial: xsens_mt: always bind to
 interface number 1
From: Frans Klaver <fransklaver@gmail.com>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johan,

I noticed I submitted an error here. Will resend later today.

On Mon, Sep 1, 2014 at 11:39 AM, Frans Klaver <frans.klaver@xsens.com> wrote:
> Probe is testing if the current interface provides two bulk endpoints.
> While this achieves the goal of only binding to the correct interface,
> we already know we can find the device on interface number 1. Stop
> checking the endpoints and just return successfully when interface
> number 1 is probed.
>
> Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
> ---
>  drivers/usb/serial/xsens_mt.c | 23 ++++-------------------
>  1 file changed, 4 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/usb/serial/xsens_mt.c b/drivers/usb/serial/xsens_mt.c
> index d500ccd..ea67ed9 100644
> --- a/drivers/usb/serial/xsens_mt.c
> +++ b/drivers/usb/serial/xsens_mt.c
> @@ -41,28 +41,13 @@ static const struct usb_device_id id_table[] = {
>  };
>  MODULE_DEVICE_TABLE(usb, id_table);
>
> -static int has_required_endpoints(const struct usb_host_interface *interface)
> -{
> -       __u8 i;
> -       int has_bulk_in = 0;
> -       int has_bulk_out = 0;
> -
> -       for (i = 0; i < interface->desc.bNumEndpoints; ++i) {
> -               if (usb_endpoint_is_bulk_in(&interface->endpoint[i].desc))
> -                       has_bulk_in = 1;
> -               else if (usb_endpoint_is_bulk_out(&interface->endpoint[i].desc))
> -                       has_bulk_out = 1;
> -       }
> -
> -       return has_bulk_in && has_bulk_out;
> -}
> -
>  static int xsens_mt_probe(struct usb_serial *serial,
>                                         const struct usb_device_id *id)
>  {
> -       if (!has_required_endpoints(serial->interface->cur_altsetting))
> -               return -ENODEV;
> -       return 0;
> +       if (serial->interface->cur_altsetting.desc.bInterfaceNumber == 1)

This should be

if (serial->interface->cur_altsetting->desc.bInterfaceNumber == 1)


> +               return 0;
> +
> +       return -ENODEV;
>  }
>
>  static struct usb_serial_driver xsens_mt_device = {
> --
> 2.1.0
>
