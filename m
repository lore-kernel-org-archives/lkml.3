Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbaDWMgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:36:44 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55137 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaDWMgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:36:13 -0400
Date: Wed, 23 Apr 2014 13:34:54 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Thomas Pfaff <tpfaff@pcs.com>
Cc: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] serial_core: fix uart PORT_UNKNOWN handling
Message-ID: <20140423133454.402af61e@alan.etchedpixels.co.uk>
In-Reply-To: <alpine.LNX.2.00.1404231135450.4361@lxtpfaff.pcs.ditec.de>
References: <alpine.LNX.2.00.1404231135450.4361@lxtpfaff.pcs.ditec.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014 12:33:22 +0200
Thomas Pfaff <tpfaff@pcs.com> wrote:

> From: "Thomas Pfaff" <tpfaff@pcs.com>
> 
> While porting a RS485 driver from 2.6.29 to 3.14, i noticed that the serial tty 
> driver could break it by using uart ports that it does not own :
> 
> 1. uart_change_pm ist called during uart_open and calls the uart pm function
>    without checking for PORT_UNKNOWN.
>    The fix is to move uart_change_pm from uart_open to uart_port_startup.
> 2. The return code from the uart request_port call in uart_set_info is not
>    handled properly, leading to the situation that the serial driver also
>    thinks it owns the uart ports.
>    This can triggered by doing following actions :
> 
>    setserial /dev/ttyS0 uart none    # release the uart ports
>    modprobe lirc-serial              # or any other device that uses the uart
>    setserial /dev/ttyS0 uart 16550   # gives no error and the uart tty driver
>                                      # can use the ports as well
> 
> Signed-off-by: Thomas Pfaff <tpfaff@pcs.com>
Reviewed-by: Alan Cox <alan@linux.intel.com>
