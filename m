Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaIQKzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 06:55:16 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.162]:11313 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbaIQKzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 06:55:14 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-9.tower-38.messagelabs.com!1410951278!12623533!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 17 Sep 2014 12:54:39 +0200
Date: Wed, 17 Sep 2014 12:54:33 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: Re: [PATCH v3] tty: serial: men_z135_uart: Fix driver for changes in
 hardware
Message-ID: <20140917105432.GA17369@jtlinux>
References: <1410845068-2954-1-git-send-email-johannes.thumshirn@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410845068-2954-1-git-send-email-johannes.thumshirn@men.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 07:24:28AM +0200, Johannes Thumshirn wrote:
> 16z135 IP Core has changed so the driver needs to be updated to respect
> these changes. The following changes have been made:
>
> * Don't invert the 16z135 modem status register when reading.
> * Add module parameter to configure the (baud rate dependent) RX timeout.
>   Character timeout in seconds = (timeout_reg * baud_reg * 4)/freq_reg.
> * Enable the handling of UART core's automatic flow control feature.
>   When AFE is active disable generation of modem status IRQs.
> * Rework the handling of IRQs to be conform with newer FPGA versions and
>   take precautions not to miss an interrupt because of the destructive read
>   of the IIR register.
> * Correct men_z135_handle_modem_status(), MSR is stat_reg[15:8] not
>   stat_reg[7:0]
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> ---
> Changes to v1:
> Incorporated comments of Jiri Slaby:
>
> * Timeout value is documented in module parameter description
> * rx_timeout variable is uint
> * Changed IRQ handled variable to bool
> * Changed if statement for RDA or CTI IRQ
>
> Changes to v2:
> Correct men_z135_handle_modem_status(), MSR is stat_reg[15:8] not stat_reg[7:0]

We've found a bug in this patch during our tests so please do not en-queue it yet.

Sorry for the inconvenience.

Thanks,
Johannes
