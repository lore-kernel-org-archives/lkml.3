Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab3CULl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:41:56 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:50561
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932102Ab3CULly convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:41:54 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Message-ID: <1363866099.2289.8.camel@leyfoon-vm>
Subject: Re: [PATCH 2/2] serial: of_serial: Handle fifosize property
From: Ley Foon Tan <lftan@altera.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Rob Landley <rob@landley.net>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
Date: Thu, 21 Mar 2013 19:41:39 +0800
In-Reply-To: <1363862880-17295-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <20130321104651.GC2862@xps8300>
	 <1363862880-17295-1-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 12:48 +0200, Heikki Krogerus wrote:
> fifosize property is already used with a number of serial
> devices. This should reduce the need for extra types in
> 8250.c just in case the fifosize differs from the standard.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  Documentation/devicetree/bindings/tty/serial/of-serial.txt |    1 +
>  drivers/tty/serial/of_serial.c                             |    4 ++++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/tty/serial/of-serial.txt b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
> index 8f01cb1..55fe4e7 100644
> --- a/Documentation/devicetree/bindings/tty/serial/of-serial.txt
> +++ b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
> @@ -33,6 +33,7 @@ Optional properties:
>    RTAS and should not be registered.
>  - no-loopback-test: set to indicate that the port does not implements loopback
>    test mode
> +- fifosize: the fifo size of the UART.
>  
>  Example:
>  
> diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
> index b025d54..4f89761 100644
> --- a/drivers/tty/serial/of_serial.c
> +++ b/drivers/tty/serial/of_serial.c
> @@ -97,6 +97,10 @@ static int of_platform_serial_setup(struct platform_device *ofdev,
>  	if (of_property_read_u32(np, "reg-shift", &prop) == 0)
>  		port->regshift = prop;
>  
> +	/* Check for fifo size */
> +	if (of_property_read_u32(np, "fifosize", &prop) == 0)
> +		port->fifosize = prop;
> +
Suggest to use "fifo-size" for the device tree property, to align with
other DT properties.

>  	port->irq = irq_of_parse_and_map(np, 0);
>  	port->iotype = UPIO_MEM;
>  	if (of_property_read_u32(np, "reg-io-width", &prop) == 0) {

I think you need to remove the UPF_FIXED_TYPE from port-flags as well to
use the fifo size from device tree. Otherwise, it will get from the
static array in 8250.c.

LFTan


