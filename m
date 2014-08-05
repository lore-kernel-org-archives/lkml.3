Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbaHELpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:45:47 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:48709 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbaHELpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:45:45 -0400
Date: Tue, 5 Aug 2014 12:43:43 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org,
        gregkh@linuxfoundation.org, jslaby@suse.cz, grant.likely@linaro.org,
        heikki.krogerus@linux.intel.com, alan@linux.intel.com,
        paul.gortmaker@windriver.com, asierra@xes-inc.com, mwelling@ieee.org,
        dianders@chromium.org, m-karicheri2@ti.com, jschultz@xes-inc.com,
        mingo@elte.hu, balbi@ti.com, heiko@sntech.de,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 1/3] tty: serial: 8250: Add new capability for highspeed
 register
Message-ID: <20140805124343.27ff9b32@alan.etchedpixels.co.uk>
In-Reply-To: <1407236054-30994-2-git-send-email-matthias.bgg@gmail.com>
References: <1407236054-30994-1-git-send-email-matthias.bgg@gmail.com>
	<1407236054-30994-2-git-send-email-matthias.bgg@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
>  	/*
> +	 * Mediatek UARTs use an extra highspeed register (UART_MTK_HIGHS)
> +	 *
> +	 * We need to recalcualte the quot register, as the claculation depends
> +	 * on the vaule in the highspeed register.
> +	 *
> +	 * Some baudrates are not supported by the chip, so we use the next
> +	 * lower rate supported.
> +	 *
> +	 * If highspeed register is set to 3, we need to specify sample count
> +	 * and sample point to increase accuracy. If not, we reset the
> +	 * registers to their default values.
> +	 */

Don't put stuff in the core driver core for your chip specific weirdness,
wrap the termios method with your own in your driver code as a fair
number of other 8250ish drivers do.

If you do that then you don't need to waste a UART CAPS flag and you
don't need to put anything in the core driver code.

Alan
