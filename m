Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbaHEJey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 05:34:54 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:48373 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbaHEJew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 05:34:52 -0400
Date: Tue, 5 Aug 2014 10:34:09 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Michael Welling <mwelling@ieee.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Joe Schultz <jschultz@xes-inc.com>, Ingo Molnar <mingo@elte.hu>,
        Doug Anderson <dianders@chromium.org>, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] serial: Add support for Fintek F81216A LPC to 4
 UART
Message-ID: <20140805103409.33afef2a@alan.etchedpixels.co.uk>
In-Reply-To: <CAPybu_2U2jjyY_9gji41mUc5F4N+idDVNO=LAr3F5PpJ0JzYSg@mail.gmail.com>
References: <CAPybu_1Ma+7nGaS0e17HpPcM1vk6ANSFN3C8MNR=JxWrBBmMOA@mail.gmail.com>
	<1406834546-23033-1-git-send-email-ricardo.ribalda@gmail.com>
	<20140801132343.45153300@alan.etchedpixels.co.uk>
	<CAPybu_2U2jjyY_9gji41mUc5F4N+idDVNO=LAr3F5PpJ0JzYSg@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2014 14:28:11 +0200
Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> wrote:

> Hello
> 
> >> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> >
> > This half of things looks good to me.
> 
> 
> Thanks!, What about the other half? Would you accept a two step approach?
> 
> 1st: add support for 8250_core
> 2nd: handle rs485 ioctl on serial_core and modify all the other
> drivers to use that? (to avoid code duplication)

We really want to handle it at the tty layer I think not at serial_core.
I have a patch for that and I'm playing with it but it's taking longer
than I hoped.

In the mean time I think your patch #1 is ok except for the trivial
item that I'd prefer the struct serial_rs485 was further down the struct
uart_8250_port. It's packed so that the bits you need most are in the
first cache line or two.

Alan
