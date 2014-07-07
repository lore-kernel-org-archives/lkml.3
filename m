Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaGGNKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:10:10 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35822 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbaGGNKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:10:08 -0400
Date: Mon, 7 Jul 2014 14:09:11 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com
Subject: Re: [RFC PATCH 1/4] tty: serial: 8250 core: provide a function to
 export uart_8250_port
Message-ID: <20140707140911.5ee517d2@alan.etchedpixels.co.uk>
In-Reply-To: <1404491651-1388-1-git-send-email-bigeasy@linutronix.de>
References: <1404491651-1388-1-git-send-email-bigeasy@linutronix.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Jul 2014 18:34:08 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> There is no access to access a struct uart_8250_port for a specific
> line. This is only required outside of the 8250/uart callbacks like for
> devices' suspend & remove callbacks. For those the 8250-core provides
> wrapper like serial8250_unregister_port() which passes the struct
> to the proper function based on the line argument.
> 
> For runtime suspend I need access to this struct not only to make
> serial_out() work but also to properly restore up->ier and up->mcr.

Please update the patch to clearly describe the locking
assumptions/requirements for the caller (and not to use it unless you
have no other choice)


