Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab3LFCm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 21:42:28 -0500
Received: from zimbra.real-time.com ([63.170.91.9]:45870 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab3LFCm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 21:42:26 -0500
Date: Fri, 6 Dec 2013 13:42:11 +1100
From: James Cameron <quozl@laptop.org>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Crispin <blogic@openwrt.org>, Jiri Slaby <jslaby@suse.cz>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        Zhou Zhu <zzhu3@marvell.com>
Subject: Re: [PATCH] serial: rewrite pxa2xx-uart to use 8250_core
Message-ID: <20131206024211.GK16425@us.netrek.org>
References: <20131205043544.GA28580@kroah.com>
 <1386286149-2855-1-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386286149-2855-1-git-send-email-ynvich@gmail.com>
Organization: Netrek Vanilla Server Dictator
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 03:28:37AM +0400, Sergei Ianovich wrote:
> pxa2xx-uart was a separate uart platform driver. It was declaring
> the same device names and numbers as 8250 driver. As a result,
> it was impossible to use 8250 driver on PXA SoCs.
> 
> Upon closer examination pxa2xx-uart turned out to be a clone of
> 8250_core driver.

[...]

> +/* Uart divisor latch write */
> +static void serial_pxa_dl_write(struct uart_8250_port *up, int value)
> +{
> +	serial_out(up, UART_DLL, value & 0xff);
> +	serial_out(up, UART_DLM, value >> 8 & 0xff);
> +}

This is a change.  drivers/tty/serial/pxa.c did read back UART_DLL as
an errata work around:

> -	/*
> -	 * work around Errata #75 according to Intel(R) PXA27x Processor Family
> -	 * Specification Update (Nov 2005)
> -	 */
> -	dll = serial_in(up, UART_DLL);
> -	WARN_ON(dll != (quot & 0xff));

If this is no longer needed, serial_pxa_dl_write can be removed
because it is same as default_serial_dl_write.

I did not check the other errata work arounds.

--
James Cameron
http://quozl.linux.org.au/
