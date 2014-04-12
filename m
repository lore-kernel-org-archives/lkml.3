Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaDLQ72 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 12:59:28 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41318 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaDLQ7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 12:59:25 -0400
Date: Sat, 12 Apr 2014 17:58:12 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <balbi@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] serial: uart: add hw flow control support configuration
Message-ID: <20140412175812.107ecbdf@alan.etchedpixels.co.uk>
In-Reply-To: <1397243877-23234-1-git-send-email-m-karicheri2@ti.com>
References: <1397243877-23234-1-git-send-email-m-karicheri2@ti.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> not needed if hw has flow control capabilities. This patch adds a
> DT attribute for enabling hw flow control for a uart port. Also skip
> stop and start if this flag is present in flag field of the port
> structure.

That seems a sensible thing to add.

> -	if (up->capabilities & UART_CAP_AFE && port->fifosize >= 32) {
> +	if ((up->capabilities & UART_CAP_AFE && (port->fifosize >= 32)) ||
> +	    port->flags & UPF_HARD_FLOW) {

Surely you want brackets on the port->flags & UPF_HARD_FLOW ??

Alan
