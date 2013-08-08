Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965571Ab3HHRNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:13:38 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:60495 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965337Ab3HHRNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:13:36 -0400
Date: Thu, 8 Aug 2013 10:13:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH 1/2] include: dt-binding: input: create a DT header
 defining key codes.
Message-ID: <20130808171331.GA6960@core.coreip.homeip.net>
References: <1375798370-2231-1-git-send-email-ldewangan@nvidia.com>
 <52014E50.6030508@wwwdotorg.org>
 <5203D138.4030107@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5203D138.4030107@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 10:41:20PM +0530, Laxman Dewangan wrote:
> On Wednesday 07 August 2013 12:58 AM, Stephen Warren wrote:
> >(CC'ing DT bindings maintainers too, hence quoting a bit of the patch)
> >
> >On 08/06/2013 08:12 AM, Laxman Dewangan wrote:
> >>Many of Key device tree bindings uses the constant number as key code
> >>which matches with kernel header key code and then comment as follows
> >>for reference/better readability:
> >>	linux,code = <102>; /* KEY_HOME */
> >>
> >>Create a DT header which defines all the key code so that DT key bindings
> >>can use it as follows:
> >>	linux,code = <KEY_HOME>;
> >This looks fine to me.
> >Reviewed-by: Stephen Warren <swarren@nvidia.com>
> >
> >A comment in support of the patch: This is adding OS-specific content to
> >the DT. However, the bindings this header file supports are already
> >written that way. There's not really any alternative here, since some
> >numbering scheme had to be chosen for keycodes, and it may as well be
> >the same set as the first/primary OS that'll use the binding.
> >
> >As far as merging it, this patch should probably go through the core DT
> >tree, perhaps in a topic branch so that e.g. Tegra an MVEBU can merge it
> >in to apply your subsequent patches (or we can just wait until the next
> >kernel release to merge them in).
> 
> Do I need to include anyone for this patch to be applied or can go
> through Dmitry's input git branch?

I am uncomfortable that we are duplicating the whole list of keycodes
here. Do you think we could split keycodes and other event codes from
include/uapi/linux/input.h into include/uapi/linux/input-events.h and
unclude it directly into DTS?

Thanks.

-- 
Dmitry
