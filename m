Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934858Ab3DHRO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:14:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54391 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934712Ab3DHROq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:14:46 -0400
Date: Mon, 8 Apr 2013 18:14:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: gregkh@linuxfoundation.org, tony@atomide.com, khilman@linaro.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCHv3] driver: serial: prevent UART console idle on suspend
	while using "no_console_suspend"
Message-ID: <20130408171432.GY30923@n2100.arm.linux.org.uk>
References: <1365167733-28083-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365167733-28083-1-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 06:45:33PM +0530, Sourav Poddar wrote:
> With dt boot, uart wakeup after suspend is non functional while using
> "no_console_suspend" in the bootargs. With "no_console_suspend" used, we
> should prevent the runtime suspend of the uart port which is getting used
> as an console.
> 
> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
> Cc: Felipe Balbi<balbi@ti.com>
> Cc: Rajendra nayak<rnayak@ti.com>
> Tested on omap5430evm, omap4430sdp.
> 
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> ---
> v2->v3
> Based on Kevin Hilman and Santosh Shilimkar comments, modified
> serial core/driver layer to bypass runtime suspend 
> for console uart while using "no_console_suspend".
> 
> This patch is based on Santosh Shilimkar serial patch[1]

Rather than introducing this "port_is_console" thing, please move
uart_console() into the serial_core.h header file, making it an inline
function, and use that in omap-serial.c.

Remember to fix drivers/tty/serial/mpc52xx_uart.c as well for that change.
