Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbaDPSi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:38:26 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46937 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbaDPSiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:38:24 -0400
Date: Wed, 16 Apr 2014 19:35:32 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Paul Bolle <pebolle@tiscali.nl>,
        Stefan Seyfried <seife+kernel@b1-systems.com>,
        James Cameron <quozl@laptop.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-serial@vger.kernel.org (open list:SERIAL DRIVERS)
Subject: Re: [PATCH v4 12/21] serial: support for 16550A serial ports on
 LP-8x4x
Message-ID: <20140416193532.0782f045@alan.etchedpixels.co.uk>
In-Reply-To: <1397668667-27328-6-git-send-email-ynvich@gmail.com>
References: <1397668411-27162-7-git-send-email-ynvich@gmail.com>
	<1397668667-27328-1-git-send-email-ynvich@gmail.com>
	<1397668667-27328-6-git-send-email-ynvich@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	baud = uart_get_baud_rate(port, termios, old,
> +				  port->uartclk / 16 / 0xffff,
> +				  port->uartclk / 16);
> +	switch (baud) {
> +	case 2400:
> +		len |= 1;
> +		break;
> +	case 4800:
> +		len |= 2;
> +		break;
> +	case 19200:
> +		len |= 4;
> +		break;
> +	case 38400:
> +		len |= 5;
> +		break;
> +	case 57600:
> +		len |= 6;
> +		break;
> +	case 115200:
> +		len |= 7;
> +		break;
> +	case 9600:
> +	default:
> +		len |= 3;
> +		break;
> +	};

Some explanation of this would be useful - eg why is it set to 7 for
115200 baud and 3 for 115201 baud ?
