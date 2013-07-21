Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3GUQeA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 12:34:00 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:53916 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab3GUQd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 12:33:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130718182504.GA7497@arwen.pp.htv.fi>
References: <1374165830-6367-1-git-send-email-r.sricharan@ti.com>
	<1374165830-6367-2-git-send-email-r.sricharan@ti.com>
	<20130718182504.GA7497@arwen.pp.htv.fi>
Date: Sun, 21 Jul 2013 18:33:57 +0200
Message-ID: <CACRpkdYdLBzFnzB1xGOPoVt-j11UciPwYiy_c3i+xYY9UOngEw@mail.gmail.com>
Subject: Re: [PATCH 1/3] misc: Add crossbar driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Sricharan R <r.sricharan@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        ext Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nishanth Menon <nm@ti.com>, Rajendra Nayak <rnayak@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 8:25 PM, Felipe Balbi <balbi@ti.com> wrote:

>> The Peripheral irq/dma requests are connected to one crossbar's input
>> and the output of the crossbar is connected to controller's input
>> line. On POR, there are some mappings which are done by default.
>> Those peripherals which do not have a mapping on POR, should be configured
>> to route its requests using the crossbar.
(...)
> why isn't this done under pinctrl ? If all it does is mux DMA and IRQ
> request lines, it should be written as a pinctrl driver no ?

Actually I was thinking about this at one time when designing pinctrl,
"what if we face the problem of arbitrary signal multiplexing?"

However pin control is named for what it does and also controls
things like the electrical properties of pins, biasing and so on which
is ill applicable here.

I would rather say that the pin multiplexing portions of pin control
could be rewritten to use a more generic component dealing with
arbitrary line multiplexing, i.e. something under /lib and maybe then
move over some generic concepts such as the function to group
mapping.

The same concept as found here is found in the muxes used by
drivers/dma/amba-pl08x.c back-ends on ARM reference hardware
which is also multiplexing DMA signals. In that case we have done
platform-specific hooks and implemented this in the per-machine
platform code.

Yours,
Linus Walleij
