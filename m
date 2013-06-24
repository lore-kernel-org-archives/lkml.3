Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3FXJve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:51:34 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:41858 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3FXJvd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:51:33 -0400
MIME-Version: 1.0
In-Reply-To: <51C22C5F.5020402@wwwdotorg.org>
References: <201306141741.46077.heiko@sntech.de>
	<201306141742.49923.heiko@sntech.de>
	<51C22C5F.5020402@wwwdotorg.org>
Date: Mon, 24 Jun 2013 11:51:32 +0200
Message-ID: <CACRpkdbKOWEjnkzY2zGOqWPQ7okBjhK4=QR0tHhJYQa42nefXQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] pinctrl: clarify some dt pinconfig options
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 12:10 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/14/2013 09:42 AM, Heiko Stübner wrote:

>> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
>
>> -low-power-mode               - low power mode
>> +low-power-enable     - enable low power mode
>> +low-power-disable    - disable low power mode
>
> Hmmm. That's changing the binding definition. What if somebody already
> wrote their device tree according previous definition?

It's not merged so see it as alterations to a WIP in the
turners workshop or something.

> It seems to be that tri-states are preferable for pinctrl DT:
>
> no entry: do nothing
> = 0: disable
> = 1: enable

Better with explict enable/disable strings instead of
<0> or <1> I think, but the semantic effect would be the
same I guess, the upside with *enable/*disable strings is
that we do not have to handle cases like
tristate = <2>; ...

>> +Arguments for parameters:
>> +
>> +- bias-pull-up, -down and -pin-default take as optional argument 0 to disable
>> +  the pull, on hardware supporting it the pull strength in Ohm. bias-disable
>> +  will also disable any active pull.
>
> Does this agree with the latest definition of the kernel-internal
> meaning of 0 for pull-up/down?

No that is wrong. Heiko, care to fix this binding doc?

>> +- input-schmitt takes as argument the adjustable hysteresis in a
>> +  driver-specific format
>> +
>> +- input-debounce takes the debounce time as argument or 0 to disable debouncing
>> +
>> +- power-source argument is the custom value describing the source to select
>> +
>> +- slew-rate takes as argument the target rate in a driver-specific format
>
> If those things have driver-specific (note: should be
> DT-binding-specific, not driver-specific) values, then I'm not convinced
> that having a generic parameter name for them is a good idea; it makes
> things look the same when they aren't. By forcing each binding to
> include the vendor prefix on those properties and hence define a custom
> property name, you're making it clear that the semantics may be different.

Hmmm I don't think they're used right now, let's deal with them when
we have something to showcase them with. Patches to delete the
unclear bindings will be considered...

Yours,
Linus Walleij
