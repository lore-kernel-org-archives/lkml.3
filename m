Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaFBXUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 19:20:40 -0400
Received: from ec2-54-201-57-178.us-west-2.compute.amazonaws.com ([54.201.57.178]:54393
	"EHLO ip-172-31-12-36.us-west-2.compute.internal"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751875AbaFBXUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 19:20:39 -0400
Date: Mon, 2 Jun 2014 23:15:10 +0000
From: dwalker@fifo99.com
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] tty: serial: msm_serial.c:  Cleaning up uninitialized
 variables
Message-ID: <20140602231509.GA26069@fifo99.com>
References: <1401629904-19492-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401629904-19492-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 03:38:24PM +0200, Rickard Strandqvist wrote:
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
>  

It looks valid .. We might want to just set it to 115200 which is what your change eventually does later in
the code.

Daniel
