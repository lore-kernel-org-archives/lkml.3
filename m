Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaFBKPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:15:49 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42583 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbaFBKPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:15:46 -0400
Message-ID: <538C4EC0.6090300@linaro.org>
Date: Mon, 02 Jun 2014 11:15:28 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>
CC: Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] tty: serial: msm_serial.c:  Cleaning up uninitialized
 variables
References: <1401629904-19492-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1401629904-19492-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/14 14:38, Rickard Strandqvist wrote:
> There is a risk that the variable will be used without being initialized.
> 
> This was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/tty/serial/msm_serial.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
> index 053b98e..c67f5c5 100644
> --- a/drivers/tty/serial/msm_serial.c
> +++ b/drivers/tty/serial/msm_serial.c
> @@ -962,7 +962,7 @@ static int __init msm_console_setup(struct console *co, char *options)
>  {
>  	struct uart_port *port;
>  	struct msm_port *msm_port;
> -	int baud, flow, bits, parity;
> +	int baud = 0, flow, bits, parity;

This made me wonder my "baud" is special compared to the other three
variables. In fact I don't really think it is special so setting "baud"
from the else clause in the uninitialized branch makes more sense to me.




