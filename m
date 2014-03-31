Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaCaWJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:09:27 -0400
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:45629 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750996AbaCaWJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:09:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3873:3874:4321:5007:6119:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12555:12679:12740:13019:13069:13071:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shoe60_6f31adc13b000
X-Filterd-Recvd-Size: 2687
Message-ID: <1396303762.21529.67.camel@joe-AO722>
Subject: Re: [PATCH v3 2/2] staging: serqt_usb2: Clean up initializations of
 variables.
From: Joe Perches <joe@perches.com>
To: Thomas Vegas <thomas_75@safe-mail.net>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Date: Mon, 31 Mar 2014 15:09:22 -0700
In-Reply-To: <fc172535ee81e02ac60a290f9d5f5fd4@mwinf5d64.me-wanadoo.net>
References: <fc172535ee81e02ac60a290f9d5f5fd4@mwinf5d64.me-wanadoo.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 19:50 +0200, Thomas Vegas wrote:
> Use a more common kernel coding style.

Hi again.

You removed the set of status to 0.

If that was intentional, you should state why in the changelog.

btw:

Status is never really used and might as well be deleted too.

	/* Close uart channel */
	status = qt_close_channel(serial, index);
	if (status < 0)
		dev_dbg(&port->dev, "%s - qt_close_channel failed.\n", __func__);

This could be changed to:

	if (qt_close_channel(serial, index) < 0)
		dev_dbg(etc...

> Signed-off-by: Thomas Vegas <thomas_75@safe-mail.net>
> ---
>  drivers/staging/serqt_usb2/serqt_usb2.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
> index a04cfc3..35d84fd 100644
> --- a/drivers/staging/serqt_usb2/serqt_usb2.c
> +++ b/drivers/staging/serqt_usb2/serqt_usb2.c
> @@ -990,18 +990,11 @@ static void qt_block_until_empty(struct tty_struct *tty,
>  static void qt_close(struct usb_serial_port *port)
>  {
>  	struct usb_serial *serial = port->serial;
> -	struct quatech_port *qt_port;
> -	struct quatech_port *port0;
> -	struct tty_struct *tty;
> +	struct tty_struct *tty = tty_port_tty_get(&port->port);
> +	unsigned int index = port->port_number;
> +	struct quatech_port *qt_port = qt_get_port_private(port);
> +	struct quatech_port *port0 = qt_get_port_private(serial->port[0]);
>  	int status;
> -	unsigned int index;
> -	status = 0;
> -
> -	tty = tty_port_tty_get(&port->port);
> -	index = port->port_number;
> -
> -	qt_port = qt_get_port_private(port);
> -	port0 = qt_get_port_private(serial->port[0]);
>  
>  	/* shutdown any bulk reads that might be going on */
>  	if (serial->num_bulk_out)



