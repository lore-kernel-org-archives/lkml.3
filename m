Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab3H1NWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:22:43 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:54920 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3H1NWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:22:41 -0400
MIME-Version: 1.0
In-Reply-To: <521D1B19.6080204@wwwdotorg.org>
References: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com>
	<1377380109-11247-1-git-send-email-b.brezillon@overkiz.com>
	<521B875E.1010605@wwwdotorg.org>
	<521B89D1.6010902@overkiz.com>
	<521C2347.4080702@wwwdotorg.org>
	<521C4451.1060908@overkiz.com>
	<521C587E.6050706@atmel.com>
	<521D1B19.6080204@wwwdotorg.org>
Date: Wed, 28 Aug 2013 15:22:40 +0200
Message-ID: <CACRpkda+92ZAWs1umtXeemLQu+zzi6iak=Nwb27+SO6oD9TOzg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] pinctrl: add new generic pinconf config for
 deglitch filter
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        boris brezillon <b.brezillon@overkiz.com>,
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

On Tue, Aug 27, 2013 at 11:33 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/27/2013 01:42 AM, Nicolas Ferre wrote:

>> The question is: how much this "generic" pinconf is... well... generic!
>
> This is why I don't really like the concept of generic pinconf; it ends
> up being more: whoever defines something first imposes their SoCs'
> viewpoint on that feature/property, and then everything else is declared
> non-generic.

I do not see it that way. For pinconf what we're dealing with is a very
small community of electrical engineers that produce the cell libraries
for the pads of these ASICs, and connect some of the control lines to
software-controlled registers and sometimes hard-code their
characteristics. Or a mix.

They are all learning from each other and reproducing the design
patterns of other engineers, much in the same way as software
engineers do. That is why everyone is implementing some things
like pull-up/pull-down/drive strength/schmitt-trigger etc.

We already have 7 drivers using GENERIC_PINCONF without
any ontological conflicts like this so even if the rest of the world
end up not using it we have already saved a few thousand lines
of code by not reimplementing this (including DT bindings and
parsing code) over and over again for each.

And given that pinctrl-single is one of these, I do hope and think
that the ACPI people are taking notice and in their case, since
standardized ACPI tables must describe all systems out there,
a top-down ten commandments type of pin config is necessary
for their specs. (My interpretation though.)

Yours,
Linus Walleij
