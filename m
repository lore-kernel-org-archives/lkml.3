Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab3FJKdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:33:41 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:60326 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab3FJKdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:33:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130610090357.GQ18614@n2100.arm.linux.org.uk>
References: <1370825362-11145-1-git-send-email-grant.likely@linaro.org>
 <1370825362-11145-11-git-send-email-grant.likely@linaro.org> <20130610090357.GQ18614@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@linaro.org>
Date: Mon, 10 Jun 2013 11:33:19 +0100
X-Google-Sender-Auth: ypgoJ-D3frgojUl3L7HA6wQ0PaY
Message-ID: <CACxGe6tCfvbwxAmTn3EKXifg+GYnTDAQCXuEaEAoHD_QCzmQqw@mail.gmail.com>
Subject: Re: [RFC 10/10] irqchip: Make versatile fpga irq driver a generic chip
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 10:03 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jun 10, 2013 at 01:49:22AM +0100, Grant Likely wrote:
>> This is an RFC patch to convert the versatile FPGA irq controller driver
>> to use generic irq chip. It builds on the series that extends the
>> generic chip code to allow a linear irq domain to contain one or more
>> generic irq chips so that each interrupt controller doesn't need to hand
>> code the generic chip setup.
>
> NAK, this makes functional changes.  You assume that the validity mask is
> a set of zeros followed by a set of ones.  This is not always the case.
> The PIC on Integrator/CP only has bits 29-22 and 11-0 set because 21-12
> are not valid.

Actually, I don't (at least I don't intend to). It chooses the size of
the irq_domain based on fls(), but that is only because the size has
to allocates for both the holes and the active irqs. You'll notice
that gc->unused is set to ~valid, and the generic chip code will
refuse to map in interrupt that isn't supported. If you see something
different, please point out where because that would be a bug.

g.
