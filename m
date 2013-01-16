Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab3APXSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 18:18:47 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:53731 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab3APXSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 18:18:45 -0500
Message-ID: <1358378350.7405.2.camel@gitbox>
Subject: Re: [PATCH] tty: serial/vt8500_serial.c: fix bug caused by missing
 "{}"
From: Tony Prisk <linux@prisktech.co.nz>
To: Cong Ding <dinggnu@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2013 12:19:10 +1300
In-Reply-To: <1358375103-11703-1-git-send-email-dinggnu@gmail.com>
References: <1358375103-11703-1-git-send-email-dinggnu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 23:25 +0100, Cong Ding wrote:
> It is obviously here should be braced by "{}" in the "if" branch (more than 1
> line in the "if" branch), and by the
> coding style document of the kernel I also add "{}" to the else branch.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  drivers/tty/serial/vt8500_serial.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
> index 8fd1814..ac46a6e 100644
> --- a/drivers/tty/serial/vt8500_serial.c
> +++ b/drivers/tty/serial/vt8500_serial.c
> @@ -567,12 +567,13 @@ static int vt8500_serial_probe(struct platform_device *pdev)
>  	if (!mmres || !irqres)
>  		return -ENODEV;
>  
> -	if (np)
> +	if (np) {
>  		port = of_alias_get_id(np, "serial");
>  		if (port > VT8500_MAX_PORTS)
>  			port = -1;
> -	else
> +	} else {
>  		port = -1;
> +	}
>  
>  	if (port < 0) {
>  		/* calculate the port id */

Correct. This patch is good but unnecessary now as the patch series I
pushed out removes this code anyway.

It should be applied if the series I sent out is not accepted in this
merge windows.

Regards
Tony P

