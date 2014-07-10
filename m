Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190AbaGJXJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 19:09:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaGJXJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 19:09:16 -0400
Date: Thu, 10 Jul 2014 16:13:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alex Elder <elder@linaro.org>
Cc: heikki.krogerus@linux.intel.com, david.daney@cavium.com,
        loic.poulain@intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] serial: 8250_dw: support high baudrates if possible
Message-ID: <20140710231342.GA9557@kroah.com>
References: <1404227734-14180-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404227734-14180-1-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 10:15:34AM -0500, Alex Elder wrote:
> Currently the Synopsys DesignWare 8250 driver assumes its UART clock
> runs at a fixed rate.  If a "real" clock was set up using the common
> clock framework, and that clock's rate is adjustable, it may be
> possible to support a wider range of baud rates by changing the
> UART clock rate.
> 
> This is done by setting up a uart_port->set_termios method that
> requests a clock rate change if a different rate might make it
> more likely to achieve a specified baud.  A new function
> dw8250_adjustable_clk() determines whether such clock rate
> adjustment is an option.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> v2: Limit clock changing to specific compatible devices.
> 
>  drivers/tty/serial/8250/8250_dw.c | 57 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)

This no longer applies due to other changes in this driver.  Can you
please refresh it against my tty-next branch of the tty.git tree and
resend?

thanks,

greg k-h
