Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaCaCCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 22:02:52 -0400
Received: from smtprelay0201.hostedemail.com ([216.40.44.201]:48322 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753070AbaCaCCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 22:02:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:4321:4605:5007:6119:7652:10004:10400:10848:11026:11232:11658:11914:12043:12294:12296:12438:12517:12519:12740:13069:13160:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: doll58_34da91f5d9a4c
X-Filterd-Recvd-Size: 2038
Message-ID: <1396231361.21529.14.camel@joe-AO722>
Subject: Re: [PATCH] staging: serqt_usb2: Add blank lines after declarations.
From: Joe Perches <joe@perches.com>
To: Thomas Vegas <thomas_75@safe-mail.net>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Date: Sun, 30 Mar 2014 19:02:41 -0700
In-Reply-To: <d1406d30f213cce36c8974925642fe19@mwinf5d23.me-wanadoo.net>
References: <d1406d30f213cce36c8974925642fe19@mwinf5d23.me-wanadoo.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-30 at 23:29 +0200, Thomas Vegas wrote:
> Use a more common kernel coding style.
[]
> diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
[]
> @@ -995,8 +995,8 @@ static void qt_close(struct usb_serial_port *port)
>  	struct tty_struct *tty;
>  	int status;
>  	unsigned int index;
> -	status = 0;
>  
> +	status = 0;

My preference would be to change the declarations to

	struct tty_struct *tty = tty_port_tty_get(&port->port);
	unsigned int index = port->port_number;
	int status = 0;

>  	tty = tty_port_tty_get(&port->port);
>  	index = port->port_number;
>  
> @@ -1268,8 +1268,8 @@ static void qt_set_termios(struct tty_struct *tty,
>  	if (I_IXOFF(tty) || I_IXON(tty)) {
>  		unsigned char stop_char = STOP_CHAR(tty);
>  		unsigned char start_char = START_CHAR(tty);
> -		status =
> -		    box_set_sw_flow_ctrl(port->serial, index, stop_char,
> +
> +		status = box_set_sw_flow_ctrl(port->serial, index, stop_char,
>  				      start_char);

Please realign start_char to the open parenthesis

		status = box_set_sw_flow_ctrl(port->serial, index, stop_char,
					      start_char);


