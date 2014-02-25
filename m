Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaBYJQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:16:26 -0500
Received: from mx0.aculab.com ([213.249.233.131]:46028 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750818AbaBYJQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:16:20 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Keith Packard'" <keithp@keithp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH] net/usb: Add Lenovo ThinkPad OneLink GigaLAN USB ID to
 ax88179 driver
Thread-Topic: [PATCH] net/usb: Add Lenovo ThinkPad OneLink GigaLAN USB ID to
 ax88179 driver
Thread-Index: AQHPMbbzcTimAiTUIEqjyghnqZZkM5rFsCBQ
Date: Tue, 25 Feb 2014 09:15:18 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6CA667@AcuExch.aculab.com>
References: <1393283629-25396-1-git-send-email-keithp@keithp.com>
In-Reply-To: <1393283629-25396-1-git-send-email-keithp@keithp.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Packard
> The Lenovo OneLink dock includes a USB ethernet adapter using the
> AX88179 chip, but with a different USB ID. Add this new USB id to the
> driver so that it will autodetect the adapter correctly.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> Tested-by: Carl Worth <cworth@cworth.org>
> ---
>  drivers/net/usb/ax88179_178a.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
> index 8e8d0fc..dcf974f 100644
> --- a/drivers/net/usb/ax88179_178a.c
> +++ b/drivers/net/usb/ax88179_178a.c
> @@ -1418,6 +1418,19 @@ static const struct driver_info samsung_info = {
>  	.tx_fixup = ax88179_tx_fixup,
>  };
> 
> +static const struct driver_info lenovo_info = {
> +	.description = "ThinkPad OneLink Dock USB GigaLAN",
> +	.bind = ax88179_bind,
> +	.unbind = ax88179_unbind,
> +	.status = ax88179_status,
> +	.link_reset = ax88179_link_reset,
> +	.reset = ax88179_reset,
> +	.stop = ax88179_stop,
> +	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
> +	.rx_fixup = ax88179_rx_fixup,
> +	.tx_fixup = ax88179_tx_fixup,
> +};
> +
>  static const struct usb_device_id products[] = {
>  {
>  	/* ASIX AX88179 10/100/1000 */
> @@ -1435,6 +1448,10 @@ static const struct usb_device_id products[] = {
>  	/* Samsung USB Ethernet Adapter */
>  	USB_DEVICE(0x04e8, 0xa100),
>  	.driver_info = (unsigned long)&samsung_info,
> +}, {
> +	/* Lenovo ThinkPad OneLink GigaLAN */
> +	USB_DEVICE(0x17ef, 0x304b),
> +	.driver_info = (unsigned long)&samsung_info,
                                     ^^^^^^^^^^^^
I think you meant lenovo_info.

Actually it looks like the initialiser should be factored somehow
to that the list of functions and flags doesn't need repeating for
every clone.

	David



