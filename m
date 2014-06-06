Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaFFXmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 19:42:06 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:62098 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbaFFXmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 19:42:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tomasz Figa <tomasz.figa@gmail.com>,
        "Doug Anderson" <dianders@chromium.org>,
        "Tomasz Figa" <t.figa@samsung.com>,
        "Kukjin Kim" <kgene.kim@samsung.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <5390EE97.9020702@gmail.com>
Cc: olof@lixom.net, javier.martinez@collabora.co.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rahul.sharma@samsung.com, shaik.ameer@samsung.com, arun.kk@samsung.com,
        alim.akhtar@samsung.com, a.hajda@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
References: <1401467562-5585-1-git-send-email-dianders@chromium.org>
 <1402000514-30752-1-git-send-email-dianders@chromium.org>
 <5390EE97.9020702@gmail.com>
Message-ID: <20140606234155.10062.58609@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v3] clk: exynos5420: Remove aclk66_peric from the clock tree
 description
Date: Fri, 06 Jun 2014 16:41:55 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tomasz Figa (2014-06-05 15:26:31)
> On 05.06.2014 22:35, Doug Anderson wrote:
> > The "aclk66_peric" clock is a gate clock with a whole bunch of gates
> > underneath it.  This big gate isn't very useful to include in our
> > clock tree.  If any of the children need to be turned on then the big
> > gate will need to be on anyway.  ...and there are plenty of other "big
> > gates" that aren't described in our clock tree, some of which shut off
> > collections of clocks that have no relationship in the hierarchy so
> > are hard to model.
> > 
> > "aclk66_peric" is causing earlyprintk problems since it gets disabled
> > as part of the boot process, so let's just remove it.
> > 
> > Strangely (and for no good reason) this clock is exported as part of
> > the common clock bindings.  Remove it since there are no in-kernel
> > device trees using it and no reason anyone out of tree should refer to
> > it either.
> > 
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
> > ---
> > Changes in v3:
> > - Now just remove aclk66_peric from the tree as suggested by Tomasz.
> > 
> > Changes in v2:
> > - Use GATE_A and clk_get().  Save the clock for putting later.
> > - Return 0 from exynos5420_clk_late_init().
> > 
> >  drivers/clk/samsung/clk-exynos5420.c   | 85 ++++++++++++++++++++++------------
> >  include/dt-bindings/clock/exynos5420.h |  1 -
> >  2 files changed, 55 insertions(+), 31 deletions(-)
> > 
> 
> Mike, I can take this patch to my tree as a fix for 3.16-rc, or if still
> possible and you don't mind, feel free to apply it directly with my ACK:
> 
> Acked-by: Tomasz Figa <t.figa@samsung.com>

I'll send a second PR next week that includes this.

Regards,
Mike

> 
> Best regards,
> Tomasz
