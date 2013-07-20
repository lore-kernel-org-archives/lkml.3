Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3GTNt0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 09:49:26 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:41812 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab3GTNtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 09:49:25 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>, devicetree@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: The future of DT binding maintainership
Date: Sat, 20 Jul 2013 15:49:21 +0200
Message-ID: <2962401.WRRoYlXkRr@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130720034647.2B7B43E14BF@localhost>
References: <CACxGe6vtJPbbqwpH8Th5S36Hx50f39j1P4OpLb-Um9xQie6Lng@mail.gmail.com> <20130720034647.2B7B43E14BF@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 of July 2013 04:46:47 Grant Likely wrote:
> A number of us had a face-to-face meeting in Dublin last week to talk
> about DT maintainership and the fact that it simply isn't working right
> now. Neither Rob nor I can keep up with the load and there are a lot of
> poorly designed bindings appearing in the tree.
> 
> Device tree binding maintainership needs to be split off to a separate
> group, and we've started with a few people willing to help, Pawel Moll,
> Mark Rutland, Stephen Warren and Ian Campbell.
> 
> (BTW, even though I've already sent a patch adding that group
> MAINTAINERS, this is not set in stone. Anyone else wanting to help
> maintain should volunteer)
> 
> Another thing discussed is that we need to start validating DT schema
> with an extension to dtc. Tomasz Figa has volunteered to do this work
> and has support from his employer to spend time on it. What I'm hoping
> to have is that the DT schema will get checked as part of the dts build
> process so that any DT file that doesn't match the documented schema
> will get flagged, and that the schema files will be human readable and
> will double as documentation.
> 
> There is not yet any process for binding maintainership. We talked about
> a few ideas, but they really need to be hashed out here on the mailing
> list. A couple of the questions:
> 
> - How are bindings allowed to be merged? Through subsystem trees, or
>   only through the bindings tree?
>   - Through the bindings tree is more work but it will provide more
>     control.
>   - Through subsystem trees means drivers and bindings get merged
>     together.
>   - If we have a schema tool that reports errors on missing or
>     unapproved schema, then spliting the driver from the binding won't
>     matter that much.
> - Do we need to differentiate between 'staging' and 'stable' bindings?
> - What is the schedule for splitting the bindings and .dts files out of
>   the kernel?
>   - Ian Campbell is maintaining a DT bindings and .dts mirror tree which
> should eventually become the 'master' for merging DT bindings.

I remember getting to a conclusion that:
 - bindings should enter staging state after being introduced,
 - from time to time a binding review meeting should take place (on IRC 
possibly) and discuss which of introduced staging bindings are ready to 
enter stable state,
 - in stable state such binding would be considered an ABI.

>From remaining questions I remember:
 - How should we mark bindings as staging and stable? (i.e. 
documentation/schema files in different folders or something else?)
 - Should we also split parts of dts/dtsi using staging bindings from 
those using stable ones? (This could mean including stable dts/dtsi file 
from inside unstable one, which would allow having a stable dts with basic 
functionality that could be extended over the time after validating 
staging bindings used in unstable part.)

As for my part, I'm now looking into existing infrastructure inside of dtc 
to get some hints that would allow me to design the initial schema syntax 
in a most dtc-friendly way. Give me a bit more time and I will then write 
down everything I have and post to the ML to start a discussion.

Best regards,
Tomasz

