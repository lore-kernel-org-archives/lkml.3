Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab3E3VGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 17:06:33 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36583 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690Ab3E3VGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 17:06:23 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6vP0F+E_UwULykPLyurO_uDQMVQhShR5VXJ7k0FynuTDw@mail.gmail.com>
References: <1369793454-19197-1-git-send-email-grant.likely@linaro.org>
	<1369793454-19197-4-git-send-email-grant.likely@linaro.org>
	<CACRpkdYjph7swctH0VUJTnEX3O2EKEhX3_HcZz0JvK9L+NKhdA@mail.gmail.com>
	<CACxGe6vP0F+E_UwULykPLyurO_uDQMVQhShR5VXJ7k0FynuTDw@mail.gmail.com>
Date: Thu, 30 May 2013 23:06:22 +0200
Message-ID: <CACRpkdbNW2JAGuvhrQW3xshDCoLRd+Nbyy+YtF26CMQjdo0anQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] irqchip: Make versatile fpga irq driver a generic chip
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 9:56 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, May 29, 2013 at 6:55 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

>> Hm, I could test this but what is the needed baseline? I think
>> I need Thomas' patches underneath right?
>>
>> Could you publish a branch that I can test?
>
> Try this one:
>
> git://git.secretlab.ca/git/linux irqdomain/generic-chip

Hey it works!

Compiled and booted on Integrator/AP which uses this
controller exclusively.

But you need this hunk:

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 8765502..0cca010 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -36,6 +36,7 @@ config RENESAS_IRQC

 config VERSATILE_FPGA_IRQ
        bool
+       select GENERIC_IRQ_CHIP
        select IRQ_DOMAIN

 config VERSATILE_FPGA_IRQ_NR

With that:
Tested-by: Linus Walleij <linus.walleij@linaro.org>

For the series.

Yours,
Linus Walleij
