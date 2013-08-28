Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab3H1NOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:14:01 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:61137 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab3H1NN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:13:58 -0400
MIME-Version: 1.0
In-Reply-To: <521C587E.6050706@atmel.com>
References: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com>
	<1377380109-11247-1-git-send-email-b.brezillon@overkiz.com>
	<521B875E.1010605@wwwdotorg.org>
	<521B89D1.6010902@overkiz.com>
	<521C2347.4080702@wwwdotorg.org>
	<521C4451.1060908@overkiz.com>
	<521C587E.6050706@atmel.com>
Date: Wed, 28 Aug 2013 15:13:58 +0200
Message-ID: <CACRpkdaRBSGJYrCgOC-dSPEeEMWZ1N=aqhM9O-ZO+mGnEBQ=1g@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] pinctrl: add new generic pinconf config for
 deglitch filter
From: Linus Walleij <linus.walleij@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: boris brezillon <b.brezillon@overkiz.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 9:42 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> On 27/08/2013 08:16, boris brezillon :

> Deglitch and
> Debounce filters are different features in at91 (even if they pursuit the
> same goal). So I do prefer to let the user choose which feature is preferred
> for his application and add a different flag.

Electrically speaking debounce and deglitch are totally different things.

Debounce is for, well debouncing. To even out the effect of pressing
a button which due to mechanical characteristics create a sharp
series of spikes like that:
  _   _
_| |_| |_

I highly suspect that "deglitch" is either:

- A one-spike version of the above (in which case a custom config
  may be warranted) or

- What we usually call schmitt-trigger, i.e. handling of analog
  swing-in.

Can you describe exactly what the two features do, in electrical
terms?

> The question is: how much this "generic" pinconf is... well... generic! And
> it is not a answer I can give.

The generic configs are defined from electrical use-cases that
appear in practice and also have the character of appearing in
similar implementations in I/O cells of several vendors, to the point
that from a software perspective they are identical.

> On the other hand, if the "generic" is not going to overcome the native
> pinctrl, I do not feel like switching to this at the cost of changing the
> whole dtsi/dts entries that we already have.

The question we ask in this case is whether the electrical construction
is so fantastically unique and ingenious that no other ASIC pad
implementer sitting in his chamber working on I/O cells would
possibly ever come up with the same concept.

If that is true, then it warrants its own, custom binding.

If you ask some other randong cell implementer whether this is
something they would do, and they say "yeah I have that in the
next version of my cell library" then it is generic, because we will
see the same thing in other systems as time moves on.

Yours,
Linus Walleij
