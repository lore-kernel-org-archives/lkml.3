Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3FJKu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:50:29 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:48639 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3FJKu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:50:27 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkda+WD5dMoZ9s7mTLgOgUrm+EH3Mqxio=BuLTDr3aOEruw@mail.gmail.com>
References: <1370825362-11145-1-git-send-email-grant.likely@linaro.org>
 <1370825362-11145-11-git-send-email-grant.likely@linaro.org> <CACRpkda+WD5dMoZ9s7mTLgOgUrm+EH3Mqxio=BuLTDr3aOEruw@mail.gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Mon, 10 Jun 2013 11:50:06 +0100
X-Google-Sender-Auth: p3D-g2xYucxAQ66qLU2UL03p-4E
Message-ID: <CACxGe6tW+k6dN6gi6MoPQ2zehP4R+THmzFGZQkhOZGH7oS+S2g@mail.gmail.com>
Subject: Re: [RFC 10/10] irqchip: Make versatile fpga irq driver a generic chip
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 8:40 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Jun 10, 2013 at 2:49 AM, Grant Likely <grant.likely@linaro.org> wrote:
>
>> This is an RFC patch to convert the versatile FPGA irq controller driver
>> to use generic irq chip. It builds on the series that extends the
>> generic chip code to allow a linear irq domain to contain one or more
>> generic irq chips so that each interrupt controller doesn't need to hand
>> code the generic chip setup.
>>
>> I've written this as a proof of concept to see if the new generic irq
>> code does what it needs to. I had to extend it slightly to properly
>> handle the valid mask used by the versatile FPGA driver.
>>
>> Tested on QEMU, but not on real hardware.
>
> Is this the same as the one I tested previously?
>
> If it need re-testing please push a branch and I'll take it
> for a spin.

Yes, it's the same, but if you can test the branch I would appreciate
it. I've done some heavy rework on the irqdomain code that makes
everything simpler, but also makes it likely that I've broken
something.

git://git.secretlab.ca/git/linux.git irqdomain/test

g.
