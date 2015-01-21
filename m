Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbbAUNhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 08:37:09 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:57066 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbbAUNhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 08:37:05 -0500
Date: Wed, 21 Jan 2015 14:36:59 +0100 (CET)
From: robert.jarzmik@free.fr
To: Lee Jones <lee.jones@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Daniel Mack <daniel@zonque.org>
Message-ID: <332399927.402665086.1421847419490.JavaMail.root@zimbra1-e1.priv.proxad.net>
In-Reply-To: <20150121123551.GD9258@x1>
Subject: Re: [PATCH v3 2/3] mfd: lubbock_io: add lubbock_io board
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.198.151.44]
X-Mailer: Zimbra 7.2.0-GA2598 (ZimbraWebClient - GC31 (Linux)/7.2.0-GA2598)
X-Authenticated-User: robert.jarzmik@free.fr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ----- Mail original -----
> De: "Lee Jones" <lee.jones@linaro.org>
First of all, this is my web mail interface, so please be kind with
my mail formatting ...

> Looking at one of the other patches in the series it appears the flag
> you're trying to capture is IORESOURCE_IRQ_LOWEDGE.  When I grep for
> where this is being _used_ (think 'consumed, rather than passed.  I
> only see a single entry in drivers/pnp/interface.c.
Look at this call chain :
request_irq()
  setup_irq()
    __setup_irq()
      __irq_set_trigger()
        pxa_gpio_irq_type() (aka. chip->irq_set_type)
          => hardware register manipulation

Moreover, you should be aware of the bijection existing between :
 - IORESOURCE_IRQ_LOWEDGE and IRQF_TRIGGER_RISING
 - it's HIGHEDGE twin
 - it is noted in : include/linux/interrupt.h

> That's what got me thinking... are you sure you're a) making use of
this flag
Yes, I'm quite sure.

> b) assuming the answer to 'a' is "no"
I won't :)

> I think to set an edge trigger on an IRQ, you should instead do so via
> irq_set_irq_type(), or have a missed a line or two?
__setup_irq(), that's the entry point.

Cheers.

--
Robert
