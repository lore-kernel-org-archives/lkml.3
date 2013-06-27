Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab3F0IcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:32:05 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:39701 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3F0IcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:32:01 -0400
MIME-Version: 1.0
In-Reply-To: <51CA0FB0.7090608@wwwdotorg.org>
References: <201306251455.01540.heiko@sntech.de>
	<201306251456.36499.heiko@sntech.de>
	<51C99581.2010403@imgtec.com>
	<CACRpkdaVsKCNzQ9zAG5DXfDO2BFpcCzw5VbmARazOrXCW1kmeQ@mail.gmail.com>
	<51C9AFC4.1020305@imgtec.com>
	<51CA0FB0.7090608@wwwdotorg.org>
Date: Thu, 27 Jun 2013 10:32:01 +0200
Message-ID: <CACRpkdZ6KOa=bXqm_S7LbUXp8AeWzCTCS6pRSFDiRu5ELgypQg@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: remove slew-rate parameter from tz1090
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: James Hogan <james.hogan@imgtec.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 11:46 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/25/2013 08:57 AM, James Hogan wrote:
>> 0: slow (half frequency)
>> 1: fast
>>
>> I just got a reply back from a hardware engineer, who said that the
>> relationship with the actual volts/usec will depend on both the drive
>> strength and the load on the pad, and that a definite answer probably
>> requires running a simulation.
>
> Tegra is similar here. The docs just say (for a 2-bit field expressed in
> binary) "Code 11 is the least slewing of the signal, code 00 is the
> highest slewing of the signal".
>
> I'm not sure that a generic parameter actually needs specific units. Why
> can't we simply specify the units as HW-defined, even while using a
> standardized DT property name and kernel-internal enum to represent the
> concept of slew rate?

That is fine I guess, that is how it is currently defined for the
kernel internals in
<linux/pinconf/pinconf-generic.h>:

 * @PIN_CONFIG_SLEW_RATE: if the pin can select slew rate, the argument to
 *      this parameter (on a custom format) tells the driver which alternative
 *      slew rate to use.

It's just that the very phrase "device tree" bring out the
standards body slow-and-impersonal considering all aspects
of the world side of me.

Unless someone from the DT camp think it is horrible to have
this value vendor-specific I'm all game.

But I guess it needs some binding doc for each and every pin
controller in that case, so referring to the generic binding will
not work. (And the driver needs to do some range checking
etc I guess.)

Yours,
Linus Walleij
