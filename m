Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab3HNQx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:53:59 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:58517 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab3HNQx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:53:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130805115118.GF20936@ab42.lan>
References: <20130618092516.GC18663@ab42.lan>
	<1371547751-13873-2-git-send-email-christian.ruppert@abilis.com>
	<CACRpkdZvcF3agP=hK6J6hZn-Sx2Mw=P4dR2Mwzo+NoLxtMkbQg@mail.gmail.com>
	<20130805115118.GF20936@ab42.lan>
Date: Wed, 14 Aug 2013 18:53:56 +0200
Message-ID: <CACRpkdaXqHHF5oDsWSCyhzUOurrxfLhS40=csGJFT8fK4WkA4A@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinmux: Add TB10x pinmux driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 1:51 PM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:
> [Me]
>> I don't see any of the port concept creeping into the device tree
>> in this version and that is how I think it should be kept:
>> the "port" particulars is a thing for the driver and not the
>> device tree.
>
> I'm not sure if everybody is aligned here (or if we even understand each
> other): In my terminology, a "port" is a set of pins controlled by the
> same register/bit field.

OK, that can also be called a "bank" or "register" but whatever.

> An "interface" is a set of pins which form a
> functional unit, e.g. an SPI interface.

This is called a pinmux setting in the pinctrl terminology.

A group is a number of pins, a function is a functionality such as SPI.
When the function SPI is combined with a group of pins in a map, it
creates a pinmux setting.

> One port can contain several
> interfaces

In pinctrl terminology this means it controls several functions.

> which may or may not be mapped at the same time. Inversely
> (especially if every pin can be configured separately), mapping of an
> interface might require the configuration of more than one ports. The
> concept of interfaces is on a higher level of abstraction (in the sense
> "further away from physical pinmux configuration") than the concept of a
> port.

Hm maybe I still do not understand what an "interface" really is
on this hardware.

> In the driver under discussion, pin groups are defined for every
> "interface" to make sure that interfaces can be requested in an
> orthogonal way by different modules and modules don't have to be "aware"
> of which interfaces are grouped into which port (and which other modules
> request which other interfaces). A request either succeeds or fails.
> Resource management (which interfaces can be mapped simultaneously) is
> done inside the pinctrl driver.

OK

> If I understand Stephen correctly, the traditional way of requesting pin
> configurations is at "port" level, e.g. a configuration is defined by a
> port and its mux setting.

Now it is ever more confused.

Pin configuration is about things like pull-up in pinctrl terminology.

Please talk about functions, groups and settings that combine
functions with groups.

> The TB10x driver works on a higher level of
> abstraction ("interface" level), where interfaces are requested and the
> driver internally decides which configuration(s) to apply to which
> port(s). Ports are not used in the device tree indeed, but interfaces
> are.
>
> Based on this, I don't quite understand your comment: You say you don't
> like ports starting to leak outside of the pinctrl driver but according
> to Stephen that's what is common practice today? Did you mean
> interfaces? The TB10x driver's configuration nodes are currently defined
> based on interfaces.

I think that language is part of the problem here.

Can you please double-check my definitions of terms in
Documentation/pinctrl.txt so we are talking the same language?

Yours,
Linus Walleij
