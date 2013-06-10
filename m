Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3FJJEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:04:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40541 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3FJJEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:04:10 -0400
Date: Mon, 10 Jun 2013 10:03:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFC 10/10] irqchip: Make versatile fpga irq driver a generic
	chip
Message-ID: <20130610090357.GQ18614@n2100.arm.linux.org.uk>
References: <1370825362-11145-1-git-send-email-grant.likely@linaro.org> <1370825362-11145-11-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370825362-11145-11-git-send-email-grant.likely@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 01:49:22AM +0100, Grant Likely wrote:
> This is an RFC patch to convert the versatile FPGA irq controller driver
> to use generic irq chip. It builds on the series that extends the
> generic chip code to allow a linear irq domain to contain one or more
> generic irq chips so that each interrupt controller doesn't need to hand
> code the generic chip setup.

NAK, this makes functional changes.  You assume that the validity mask is
a set of zeros followed by a set of ones.  This is not always the case.
The PIC on Integrator/CP only has bits 29-22 and 11-0 set because 21-12
are not valid.
