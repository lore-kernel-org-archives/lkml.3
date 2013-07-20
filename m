Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3GTMXI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 08:23:08 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47935 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab3GTMWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 08:22:37 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: The future of DT binding maintainership
To: Wolfram Sang <w.sang@pengutronix.de>, Tomasz Figa <tomasz.figa@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>, devicetree@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <CACxGe6vtJPbbqwpH8Th5S36Hx50f39j1P4OpLb-Um9xQie6Lng@mail.gmail.com>
References: <CACxGe6vtJPbbqwpH8Th5S36Hx50f39j1P4OpLb-Um9xQie6Lng@mail.gmail.com>
Date: Sat, 20 Jul 2013 04:46:47 +0100
Message-Id: <20130720034647.2B7B43E14BF@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of us had a face-to-face meeting in Dublin last week to talk
about DT maintainership and the fact that it simply isn't working right
now. Neither Rob nor I can keep up with the load and there are a lot of
poorly designed bindings appearing in the tree.

Device tree binding maintainership needs to be split off to a separate
group, and we've started with a few people willing to help, Pawel Moll,
Mark Rutland, Stephen Warren and Ian Campbell.

(BTW, even though I've already sent a patch adding that group
MAINTAINERS, this is not set in stone. Anyone else wanting to help
maintain should volunteer)

Another thing discussed is that we need to start validating DT schema
with an extension to dtc. Tomasz Figa has volunteered to do this work
and has support from his employer to spend time on it. What I'm hoping
to have is that the DT schema will get checked as part of the dts build
process so that any DT file that doesn't match the documented schema
will get flagged, and that the schema files will be human readable and
will double as documentation.

There is not yet any process for binding maintainership. We talked about
a few ideas, but they really need to be hashed out here on the mailing
list. A couple of the questions:

- How are bindings allowed to be merged? Through subsystem trees, or
  only through the bindings tree?
  - Through the bindings tree is more work but it will provide more
    control.
  - Through subsystem trees means drivers and bindings get merged
    together.
  - If we have a schema tool that reports errors on missing or
    unapproved schema, then spliting the driver from the binding won't
    matter that much.
- Do we need to differentiate between 'staging' and 'stable' bindings?
- What is the schedule for splitting the bindings and .dts files out of
  the kernel?
  - Ian Campbell is maintaining a DT bindings and .dts mirror tree which
    should eventually become the 'master' for merging DT bindings.

g.

