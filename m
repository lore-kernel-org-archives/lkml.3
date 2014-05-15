Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbaEOOSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:18:14 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46275 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbaEOOSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:18:11 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
In-Reply-To: <E204285C-D6CD-4518-A94F-26BF0570C1B1@konsulko.com>
References: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com>
	<1396615441-29630-3-git-send-email-pantelis.antoniou@konsulko.com>
	<20140514100856.5198DC4153D@trevor.secretlab.ca>
	<E204285C-D6CD-4518-A94F-26BF0570C1B1@konsulko.com>
Date: Thu, 15 May 2014 15:18:01 +0100
Message-Id: <20140515141801.1E28BC4095B@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pantelis,

Thanks for writing this up. A few responses below...

On Thu, 15 May 2014 00:12:17 -0700, Pantelis Antoniou <pantelis.antoniou@konsulko.com> wrote:
> On May 14, 2014, at 3:08 AM, Grant Likely wrote:
> > On Fri,  4 Apr 2014 15:43:55 +0300, Pantelis Antoniou <pantelis.antoniou@konsulko.com> wrote:
> > The notification infrastructure bothers me. It duplicates the
> > notification that the core DT code already performs. I do understand
> > that the current notifications don't do what you need them to because
> > you need it all deferred until the complete set of batch changes are
> > applied. However, instead of creating a new infrastructure, the existing
> > notifier should be reworked to be batch-change aware.
> > 
> 
> If I understood correctly, you're asking of rolling in this per-bus notifier
> mechanism in the standard DT notifier infrastructure already in place.
> I can't be absolutely sure about the details right now, but seems possible.
> 
> I don't know if the kernel notifier framework will be unmodified, but I hope so.

It should be. It will need to be the dt code that buffers up the
notification events to be played out after the batch of changes has been
applied. That shouldn't have any impact on core notifier framework.

[...]
> > Is it the base DT that needs the __symbols__ node, or the overlay tree?
> > I had thought it was the overlay tree that contained the __symbols__
> > node. Regardless, this is the first mention in this file of __symbols__.
> > It would be good to discuss briefly how it works.
> > 
> 
> The __symbols__ usage is explained in the resolve patch.
> Since target-path has been added the base DT no longer needs a __symbols__ node.

Can the target-phandle method be removed entirely then?

> >> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> >> index 4d39c88..cfb7ff8 100644
> >> --- a/drivers/of/Kconfig
> >> +++ b/drivers/of/Kconfig
> >> @@ -86,4 +86,14 @@ config OF_RESOLVE
> >> 	  Enable OF dynamic resolution support. This allows you to
> >> 	  load Device Tree object fragments are run time.
> >> 
> >> +config OF_OVERLAY
> >> +	bool "OF overlay support"
> >> +	depends on OF
> >> +	select OF_DYNAMIC
> >> +	select OF_DEVICE
> >> +	select OF_RESOLVE
> >> +	help
> >> +	  OpenFirmware overlay support. Allows you to modify on runtime the
> >> +	  live tree using overlays.
> > 
> > Should not be a user-visable option. Drivers using it should select it
> > or otherwise cause it to be enabled.
> 
> Hmm. I don't know; if I let it up to drivers, platform devices will select it, in turn
> making it always selected for 99.9% of the platforms out there.
> 
> Some people might not want to incur the code size penalty.

The only code ever selecting this function would be code that actually
calls the overlay functions.

g.
