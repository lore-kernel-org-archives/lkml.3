Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbbASMXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:23:45 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43199 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbbASMXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:23:43 -0500
Date: Mon, 19 Jan 2015 15:23:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Shirish Gajera <gajerashirish@gmail.com>
Cc: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        samuel.thibault@ens-lyon.org, gregkh@linuxfoundation.org,
        domagoj.trsan@gmail.com, roxanagabriela10@gmail.com,
        dilekuzulmez@gmail.com, ben@decadent.org.uk, daeseok.youn@gmail.com,
        sulamiification@gmail.com, aysemelikeyurtoglu@gmail.com,
        rusty@rustcorp.com.au, tapaswenipathak@gmail.com,
        sasha.levin@oracle.com, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: speakup: Fix warning of line over 80 characters.
Message-ID: <20150119122300.GB6456@mwanda>
References: <20150118075753.GA2612@shirish-ThinkPad-Edge-E430>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150118075753.GA2612@shirish-ThinkPad-Edge-E430>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Generally this patch is fine.  There were a couple places which weren't
perfect.

On Sat, Jan 17, 2015 at 11:57:53PM -0800, Shirish Gajera wrote:
> +	if ((spk_bleeps & 2) && (msg_id < edge_quiet)) {
> +		synth_printf("%s\n",
> +		spk_msg_get(MSG_EDGE_MSGS_START + msg_id - 1));
> +	}

This should be:

	if ((spk_bleeps & 2) && (msg_id < edge_quiet)) {
		synth_printf("%s\n",
			     spk_msg_get(MSG_EDGE_MSGS_START + msg_id - 1));
	}

> +#define spk_serial_tx_busy() \
> +((inb(speakup_info.port_tts + UART_LSR) & BOTH_EMPTY) != BOTH_EMPTY)

This should be:

#define spk_serial_tx_busy() \
	((inb(speakup_info.port_tts + UART_LSR) & BOTH_EMPTY) != BOTH_EMPTY)

Otherwise this patch is nice.  I'm fine with merging it as-is if people
want.

regards,
dan carpenter

