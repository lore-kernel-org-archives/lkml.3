Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaBLCRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:17:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47439 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaBLCRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:17:44 -0500
Date: Tue, 11 Feb 2014 20:15:25 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] of: Turn of_match_node into a static inline when
 CONFIG_OF isn't set
Message-ID: <20140212021525.GK841@joshc.qualcomm.com>
References: <1392122211-11422-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1596542.hkJp71u3OJ@avalon>
 <20140211164825.GC841@joshc.qualcomm.com>
 <6446980.WMjvBYStRY@avalon>
 <20140211180845.GG841@joshc.qualcomm.com>
 <CAMuHMdVkPLe5986hYPApoQr7oJSb6U2P71=nP+9mtvtaskdHXg@mail.gmail.com>
 <CAL_JsqKnsr-9nSjCGvroC0nDK36vQUnwMWj=cPjvUbRymmHFOQ@mail.gmail.com>
 <20140211215519.GJ841@joshc.qualcomm.com>
 <CAL_JsqJdbBuv0TgN7Okrxa4MmEon6a74hv458VFS=8RpcyX5tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJdbBuv0TgN7Okrxa4MmEon6a74hv458VFS=8RpcyX5tw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 05:14:51PM -0600, Rob Herring wrote:
> On Tue, Feb 11, 2014 at 3:55 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
[..]
> > Okay, so maybe caching a pointer in the device isn't the best option,
> > what if we considered extending the platform_driver callbacks to include
> > a set of per-method (?) probe callbacks which do provide a handle to
> > matched identifiers.
> >
> > In the case of a totally contrived platform_driver supporting ACPI, OF,
> > and !OF configurations, it might look something like:
> >
> >         static const struct of_device_id acme_of_table[] = {
> >                 /* ... */
> >                 { },
> >         };
> >         MODULE_DEVICE_TABLE(of, acme_of_table);
> >
> >         static int acme_probe_of(struct platform_device *pdev,
> >                                  const struct of_device_id *id)
> 
> I don't think this is the right direction. You might want to look at
> of_platform_driver in git history...

Thanks for the pointer, of_platform_driver was on it's way out the door
while I was still coming up to speed on devicetree.

To be clear, I'm not proposing that we reintroduce a new bus_type, or
duplicate driver instances, or anything that made of_platform_driver a
pain to deal with.

I'm only suggesting that we consider providing a set of interfaces that
1) provide a simpler/more convenient way for a driver to get at matched
id table entries, and 2) provide a clearer, declarative mechanism by
which a platform driver might isolate it's firmware-specific glue bits
from core driver logic.

Anyway, thanks for hearing me out!

  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
