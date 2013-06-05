Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3FEMlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:41:31 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:65324 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab3FEMla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:41:30 -0400
MIME-Version: 1.0
In-Reply-To: <87k3m92148.fsf@linaro.org>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
	<20130531170437.GA17591@core.coreip.homeip.net>
	<CACRpkdYnhjpFp1CM=P_hddBe4qVigtE0c+CN9NKvk3nFgJS-ig@mail.gmail.com>
	<87k3m92148.fsf@linaro.org>
Date: Wed, 5 Jun 2013 14:41:29 +0200
Message-ID: <CACRpkdbtVnieRZC+WVNrWZfe2X5SEdcq2ZbOj3kaTm3TLcHmHg@mail.gmail.com>
Subject: Re: [PATCH 00/11] drivers: Add Pinctrl PM support
From: Linus Walleij <linus.walleij@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vaibhav Bedia <vaibhav.bedia@ti.com>, sudhakar.raj@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 8:15 PM, Kevin Hilman <khilman@linaro.org> wrote:
> [Me]
>> I think this will save a *lot* of identical code in all the
>> drivers, that will just have to call
>> pinctrl_select_pm_sleep(), pinctrl_select_pm_default()
>> pinctrl_select_pm_idle() instead of all the complex code.
>>
>> This is what I planned to do but never got around to.
>
> What about taking it one tiny step further, and having it done by the PM
> core itself?

Maybe so, but atleast currently we cannot do it
exclusively in the PM core.

We have things like what you find in
drivers/tty/serial/amba-pl011.c
where pl011_shutdown() puts the pins into sleep mode
on unused TTYs.

The same applies to any unused ports like that, we're
thinking of a way to sleep pins for unused I2C hosts
for example.

And that works fine also on systems that does not
enable CONFIG_PM (so the pin control subsystem
is completely orthogonal). But maybe that is
complicating things? I was just thinking it was a bit
thick to require everything and its dog to make a
complete transition to (runtime)PM.

Yours,
Linus Walleij
