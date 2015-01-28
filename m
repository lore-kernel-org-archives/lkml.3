Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226AbbA2Bwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:52:37 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33266 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbbA2Bwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:52:32 -0500
Message-ID: <54C8D68B.6010607@cogentembedded.com>
Date: Wed, 28 Jan 2015 15:31:07 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Peter Hung <hpeter@gmail.com>, johan@kernel.org
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom_tsai@fintek.com.tw,
        peter_hong@fintek.com.tw, Peter Hung <hpeter+linux_kernel@gmail.com>
Subject: Re: [PATCH v3 5/5] usb: serial: implement CMSPAR for F81232
References: <1422424712-7561-1-git-send-email-hpeter+linux_kernel@gmail.com>
In-Reply-To: <1422424712-7561-1-git-send-email-hpeter+linux_kernel@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/28/2015 8:58 AM, Peter Hung wrote:

> This patch implement CMSPAR in set_termios,
> and fix some warnning from checkpatch.pl

     Please don't try to do 2 unrelated things in one patch.

> Signed-off-by: Peter Hung <hpeter+linux_kernel@gmail.com>
> ---
>   drivers/usb/serial/f81232.c | 21 +++++++++++++++------
>   1 file changed, 15 insertions(+), 6 deletions(-)

> diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
> index 11a236b..79592d6 100644
> --- a/drivers/usb/serial/f81232.c
> +++ b/drivers/usb/serial/f81232.c
[...]
> @@ -361,12 +361,21 @@ static void f81232_set_termios(struct tty_struct *tty,
>
>
>   	if (cflag & PARENB) {
> -		if (cflag & PARODD)
> -			new_lcr |= UART_LCR_PARITY; /* odd */
> -		else
> -			new_lcr |= SERIAL_EVEN_PARITY; /* even */
> +		if (cflag & CMSPAR) {
> +			if (cflag & PARODD)
> +				new_lcr |= (UART_LCR_PARITY | UART_LCR_SPAR);
> +			else
> +				new_lcr |= (SERIAL_EVEN_PARITY
> +							| UART_LCR_SPAR);
> +		} else {
> +			if (cflag & PARODD)
> +				new_lcr |= UART_LCR_PARITY; /* odd */
> +			else
> +				new_lcr |= SERIAL_EVEN_PARITY; /* even */
> +		}
>   	}
>
> +

    Not needed at all.

>   	if (cflag & CSTOPB)
>   		new_lcr |= UART_LCR_STOP;
>   	else
> @@ -445,7 +454,7 @@ static int f81232_open(struct tty_struct *tty, struct usb_serial_port *port)
>
>   	result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
>   	if (result) {
> -		dev_err(&port->dev, "failed submitting interrupt urb, error %d\n",
> +		dev_err(&port->dev, "failed submitting urb, error %d\n",

    What are you fixing here?

WBR, Sergei

