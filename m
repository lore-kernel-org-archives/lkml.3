Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbbAUOmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:42:06 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:53752 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbbAUOmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:42:03 -0500
Date: Wed, 21 Jan 2015 14:41:36 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hung <hpeter@gmail.com>
Cc: johan@kernel.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom_tsai@fintek.com.tw,
        peter_hong@fintek.com.tw, Peter Hung <hpeter+linux_kernel@gmail.com>
Subject: Re: [PATCH v2 3/4] usb: serial: implement function for F81232
Message-ID: <20150121144136.31f328cf@lxorguk.ukuu.org.uk>
In-Reply-To: <1421836214-25582-1-git-send-email-hpeter+linux_kernel@gmail.com>
References: <1421836214-25582-1-git-send-email-hpeter+linux_kernel@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	if (cflag & PARENB) {
> +		if (cflag & PARODD)
> +			new_lcr |= UART_LCR_PARITY; /* odd */
> +		else
> +			new_lcr |= SERIAL_EVEN_PARITY; /* even */
> +	}

If you don't support mark/space also clear CMSPAR in the passed termios

> -	if (old_termios)
> -		tty_termios_copy_hw(&tty->termios, old_termios);

Also when you set the baud rate compute the resulting actual baud rate
you generated and set it with

	/* Don't rewrite B0 */
	if (tty_termios_baud_rate(termios))
		tty_termios_encode_baud_rate(termios, baud, baud);

so that the application gets told the baud rate it actually got if it
isn't close to the one they requested.

Alan
