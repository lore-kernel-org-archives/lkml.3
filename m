Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbbAIUwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:52:34 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:44128 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbbAIUwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:52:32 -0500
Date: Fri, 9 Jan 2015 20:52:31 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Thierry Reding <thierry.reding@gmail.com>
cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <gnurou@gmail.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Bill Huang <bilhuang@nvidia.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Allen Martin <amartin@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] clk: tegra: Add support for the Tegra132 CAR IP
 block
In-Reply-To: <20150109111954.GB16465@ulmo>
Message-ID: <alpine.DEB.2.02.1501092030180.28771@utopia.booyaka.com>
References: <20141216203813.22980.2301.stgit@chromeos-P9X79> <20141216203829.22980.64446.stgit@chromeos-P9X79> <20150109111954.GB16465@ulmo>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry

On Fri, 9 Jan 2015, Thierry Reding wrote:

> On Tue, Dec 16, 2014 at 12:38:29PM -0800, Paul Walmsley wrote:
> > 
> > This patch is based on several patches from others:
> > 
> > 1. a  patch from Peter De Schrijver:
> > 
> > http://lkml.iu.edu/hypermail/linux/kernel/1407.1/06094.html
> > 
> > 2. a patch from Bill Huang ("clk: tegra: enable cclk_g at boot on
> > Tegra132"), and
> > 
> > 3. a patch from Allen Martin ("clk: Enable tegra clock driver for
> > tegra132").
> 
> Doesn't this technically require Signed-off-bys from each of the above,
> then?

I don't think so.  Documentation/SubmittingPatches states:

---
The rules are pretty simple: if you can certify the below:

        Developer's Certificate of Origin 1.1

        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

	(d) I understand and agree that this project and the contribution
	    are public and that a record of the contribution (including 
	    all personal information I submit with it, including my sign-off) 
	    is maintained indefinitely and may be redistributed consistent 
	    with this project or the open source license(s) involved.
---

My Signed-off-by: is based on paragraphs (a), (b), and (d).

The intention of my statement is to ensure that credit is appropriately 
provided to everyone who I drew significant inspiration or code from, and 
that such credit makes it into the official commits (e.g., is not dropped 
when the patches are applied.)  However, the patch that I sent is 
differs from the patches that I reviewed while preparing it.

Of course, if anyone would like to add Acked-by or Reviewed-by tags, etc., 
or comment if I've misunderstood something technically etc., that's 
definitely welcome.

> > diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
> [...]
> > +/**
> > + * tegra124_132_clock_init_pre - clock initialization preamble for T124/T132
> > + * @np: struct device_node * of the DT node for the SoC CAR IP block
> > + *
> > + * Register most of the clocks controlled by the CAR IP block, along
> > + * with a few clocks controlled by the PMC IP block.  Everything in
> > + * this function should be common to Tegra124 and Tegra132.  XXX The
> > + * PMC clock initialization should probably be moved to PMC-specific
> > + * driver code.  No return value.
> > + */
> > +static void __init tegra124_132_clock_init_pre(struct device_node *np)
> 
> I would've personally named this tegra124_clock_init_pre(). In the past
> we've named these functions after the first chip that needed them and if
> later chips remained compatible they would simply use the one from an
> earlier chip. That's consistent with the naming of compatible strings
> and doesn't require changes to the function names if yet another SoC
> generation were to need the same functionality.

Yes, I agree it's unwieldy.  It would be nice to find some concise way to 
refer to "the family of NVIDIA SoCs that includes T124 and T132".  Maybe 
tegra124_family_clock_init_pre() might be a better choice...


- Paul
