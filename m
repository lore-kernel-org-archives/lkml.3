Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801Ab3E3SZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:25:31 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:54062 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab3E3SZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:25:23 -0400
MIME-Version: 1.0
In-Reply-To: <1369206634-6778-10-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
	<1369206634-6778-10-git-send-email-avinashphilip@ti.com>
Date: Thu, 30 May 2013 20:25:22 +0200
Message-ID: <CACRpkdZH4w_-K617QNCo0Z9jH7LKQyjzoG9K-dj4UbN3h5Bcxw@mail.gmail.com>
Subject: Re: [PATCH 09/11] gpio: davinci: DT changes for driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Philip Avinash <avinashphilip@ti.com>
Cc: "Nori, Sekhar" <nsekhar@ti.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KV Sujith <sujithkv@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 9:10 AM, Philip Avinash <avinashphilip@ti.com> wrote:

(...)
> +- interrupts: The Starting IRQ number for GPIO
> +- intc_irq_num: The number of IRQs supported by the Interrupt Controller
(...)

No this is not how you pass a number of IRQs in the device tree.

"interrupts" is an array. Pass every interrupt here for a full
resolution of the IRQs.

Further this looks fishy:

+ interrupts = <42>;

Usually you pass flags with the IRQs, I would rather have expected
an array like this:

interrupts = < 90 0x4 96 0x4 14 0x4 15 0x4 79 0x4>;

0x4 is IRQ_TYPE_LEVEL_HIGH, you can use the dts
#include <dt-bindings/interrupt-controller/irq.h> and
define that symbolically.

Doesn't the DaVinci IRQ controller support *any* IRQ flags?

Since the driver code is not reading out the interrupts but
(I guess?) falling back to platform data IRQ assignment,
this seems wrong.

Yours,
Linus Walleij
