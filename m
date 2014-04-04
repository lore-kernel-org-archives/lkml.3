Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaDDQZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 12:25:56 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59160 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaDDQZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 12:25:53 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <533EDD0E.8010304@roeck-us.net>
Date: Fri, 04 Apr 2014 09:25:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Peter Tyser <ptyser@xes-inc.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Adding interrupt support to gpio-ich driver (possibly via SCI)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have an application where I would need interrupt support for the gpio-ich driver.
More specifically, in my application some of the GPIO pins are used to report
interrupt status from a couple of connected chips. This is with a Panther Point
PCH (QM77).

I see that the gpio pins in question (in the 0..15 range) do support interrupts,
but it looks like the only configuration options are to generate SMI, SCI, or NMI.

Is there a clean way to use any of those to implement interrupt support
for this driver ? I thought about hijacking the SCI interrupt by registering
an interrupt handler with acpi_install_sci_handler(), but that would restrict
the driver to kernel only (or the acpi function would have to be exported),
and I have no idea if it would work or, more importantly, if it would be
the best approach to solve the problem, or if the result would be acceptable.
I can figure out the "working" part, but that would not help much if I would
have to carry the patch locally because it is not acceptable for upstream
integration.

Side note: gpio-ich is not currently enabled for Panther Point; that will be
a one-line separate patch for the mfd/lpc_ich driver.

Thanks,
Guenter
