Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab3IJTwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:52:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44827 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab3IJTwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:52:31 -0400
Message-ID: <522F7878.30800@wwwdotorg.org>
Date: Tue, 10 Sep 2013 13:52:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Lars Poeschel <poeschel@lemonage.de>, Mark Brown <broonie@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
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
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <52279524.8090006@wwwdotorg.org> <20130909161924.GT29403@sirena.org.uk> <2052193.CMUEUJFRgS@lem-wkst-02> <522F2521.4090806@collabora.co.uk>
In-Reply-To: <522F2521.4090806@collabora.co.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 07:56 AM, Javier Martinez Canillas wrote:
...
> The only thing that this patch tries to solve is when a driver expect to request
> a IRQ and it doesn't care if is a real IRQ line from an interrupt controller or
> a GPIO pin mapped as an IRQ.

That can be solved in the interrupt chip driver. The fact the previous
attempt didn't work doesn't mean that it's impossible.

> With board files we used to explicitly do the GPIO setup
> (gpio_{request,direction_input}) but with DT these board files are gone and we
> need a way to setup a GPIO implicitly when is mapped as an IRQ.

Well, that's just an example of hacking around something in a board file
that should have been fixed in the GPIO/IRQ controller.

> That's the only use case that this patch covers.
...
> Also, it would be great if we can find a temporary solution so we can finally
> have ethernet working with DT on most OMAP2+ boards. Since I expect that doing
> the mentioned change on gpiolib would take at least a couple of kernel releases.

Really? I thought this patch was error-checking to make sure that
different drivers didn't request a GPIO and an IRQ that are actually the
same signal. This patch shouldn't affect any functionality except in
cases where there's a bug in the DT (incorrect GPIO/IRQ passed to some
driver).
