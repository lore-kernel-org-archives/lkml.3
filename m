Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab3APNaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:30:04 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:46636 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab3APNaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:30:01 -0500
Message-ID: <50F6AB4B.6090902@mvista.com>
Date: Wed, 16 Jan 2013 17:29:47 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        vt8500-wm8505-linux-kernel@googlegroups.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] serial: vt8500: ioremap'd resource is never freed
References: <1358225886-5686-1-git-send-email-linux@prisktech.co.nz> <1358225886-5686-3-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1358225886-5686-3-git-send-email-linux@prisktech.co.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 15-01-2013 8:58, Tony Prisk wrote:

> Memory mapped via ioremap call is never released. Rather than add an
> iounmap call, change allocation function to devm_request_and_ioremap.

> Also, change the error on failure for this call to -EBUSY rather than
> -EADDRNOTAVAIL.

    You meant "-EADDRNOTAVAIL rather than -ENOMEM". ;-)

> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
>   drivers/tty/serial/vt8500_serial.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

> diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
> index 4c4a58d..3e76dff 100644
> --- a/drivers/tty/serial/vt8500_serial.c
> +++ b/drivers/tty/serial/vt8500_serial.c
> @@ -615,9 +615,9 @@ static int vt8500_serial_probe(struct platform_device *pdev)
>   	snprintf(vt8500_port->name, sizeof(vt8500_port->name),
>   		 "VT8500 UART%d", pdev->id);
>
> -	vt8500_port->uart.membase = ioremap(mmres->start, resource_size(mmres));
> +	vt8500_port->uart.membase = devm_request_and_ioremap(&pdev->dev, mmres);
>   	if (!vt8500_port->uart.membase) {
> -		ret = -ENOMEM;
> +		ret = -EADDRNOTAVAIL;
>   		goto err;
>   	}

WBR, Sergei

