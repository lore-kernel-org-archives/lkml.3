Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3IXQ7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:59:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51781 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3IXQ7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:59:14 -0400
Message-ID: <5241C4DB.9090200@wwwdotorg.org>
Date: Tue, 24 Sep 2013 10:59:07 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Lars Poeschel <poeschel@lemonage.de>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mark Brown <broonie@kernel.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>,
        joelf@ti.com,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <522FBED9.9000305@collabora.co.uk> <5230C7F6.3080803@wwwdotorg.org> <3653629.tapNZSuWhS@lem-wkst-02> <52373B34.4060709@wwwdotorg.org> <CACRpkdY=cgtf6_eypfAAv-fvmiNgAYyz4StTgDie5THsbrcumg@mail.gmail.com> <5240A2D3.20105@wwwdotorg.org> <CACRpkdZ7E7MGppbkTiObvTDHdmphnbysMKVc1OZjsPXKVuKttQ@mail.gmail.com>
In-Reply-To: <CACRpkdZ7E7MGppbkTiObvTDHdmphnbysMKVc1OZjsPXKVuKttQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 02:31 AM, Linus Walleij wrote:
> On Mon, Sep 23, 2013 at 10:21 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
...
>> Perhaps rather than having the gpio_chip/irq_chip drivers physically
>> implement a function which calls this common code, they could set some
>> flags/data/... in the struct gpio_chip/irq_chip indicating that they
>> desire the core code that implements the error-checking to be enabled.
> 
> I think it should more be like a function they can call to flag
> a GPIO as used for IRQ.

For the record, that's pretty much exactly what I meant by implementing
it in the drivers. The irq_chip driver knows when the IRQ has been
requested, and calls some gpiolib function to mark the GPIO as
in-use-as-an-IRQ.
