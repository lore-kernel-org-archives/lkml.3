Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab3KMOYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:24:37 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64379 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758956Ab3KMOYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:24:33 -0500
Date: Wed, 13 Nov 2013 14:24:06 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/5 v2] input: tc3589x-keypad: support probing from
 device tree
Message-ID: <20131113142406.GH21713@e106331-lin.cambridge.arm.com>
References: <1384265618-10590-1-git-send-email-linus.walleij@linaro.org>
 <20131112153057.GA9683@earth.universe>
 <CACRpkdb_bryGJo7CKGP5tj3RFGv=Gh+Q5m9ucVKqJ068tjPC2g@mail.gmail.com>
 <20131112200514.GA15413@earth.universe>
 <CACRpkdaAaLjm_b+OLj3tobxBN8YGUcTPnXJ=qtBqd02=FTxhjQ@mail.gmail.com>
 <20131112204013.GA17674@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112204013.GA17674@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 08:40:14PM +0000, Sebastian Reichel wrote:
> On Tue, Nov 12, 2013 at 09:11:40PM +0100, Linus Walleij wrote:
> > > I could find two boards using "gpio-matrix-keypad" in the mainline
> > > kernel and not a single instance of "linux,no-autorepeat":
> > 
> > In things connected to GPIO, I don't expect the in-kernel
> > device trees to be a good way so survey the usage of these
> > bindings. Anyone doing device trees on any system with a
> > few GPIOs can be using this.
> > 
> > But maybe we're lucky and won't break anyone's setup if
> > we change this?
> 
> AFAIK Device Tree property names are considered as ABI, so existing
> property names must not be removed.

To an extent. We shouldn't pointlessly break existing bindings, and we
can typically support newer / "better" bindings without breaking support
for existing bindings.

There may be cases where we have to remove support for bindings (i.e.
when a binding is so badly used in practice that relying on it means
we're likely to damage hardware, or where it's so ambiguous that it
provides no useful information), but I don't think we've hit any of
those yet.

If a portions of a binding are no longer used in practice, then I see no
problem in removing support from them. However I'd expect them to remain
documented as deprecated / unsupported by Linux, and for those names to
not be re-used.

> 
> But I guess we can add the standardized property name in addition
> to the deprecated one. New drivers can use the standardized property
> name from the beginning.

This is precisely how I'd expect bindings to evolve. New properties can
be added, or existing properties can be extended, as long as those
modifications don't impair existing device trees which are in use.

If we need to change things substantially, then we can allocate a new
compatible string for the new binding. That doesn't seem to be necessary
here.

> 
> Thus I guess we should not use the name, which has the most adopters
> in kernel (or out of kernel). Instead the most fitting name should
> be used. Current suggestions (taken from kernel) are:
> 
> * <<vendor>>,no-autorepeat
> * keypad,autorepeat
> * linux,keypad-no-autorepeat
> * linux,input-no-autorepeat
> * linux,no-autorepeat
> * autorepeat
> 
> I do not really care, which one is chosen, except for two things:
> 
> * <<vendor>> seems wrong. This is not vendor specific.
> * I would prefer "input-" over "keypad-", since then the same name
>   can be used for single keys, buttons, etc.

Both of those sound valid to me, but I think it may make sense to keep
the "linux," prefix. As I understand it this is really telling the Linux
input subsystem to react to a device acting in a certain way, rather
than describing or configuring the device in a certain way.

Thanks,
Mark.
