Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099Ab3BHKQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 05:16:41 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2195 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760058Ab3BHKQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 05:16:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 08 Feb 2013 02:16:38 -0800
Date: Fri, 8 Feb 2013 12:16:35 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: Implement locking for super clock
Message-ID: <20130208101635.GS3073@tbergstrom-lnx.Nvidia.com>
References: <1360254261-23000-1-git-send-email-pdeschrijver@nvidia.com>
 <20130207185742.11471.19037@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130207185742.11471.19037@quantum>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 07:57:42PM +0100, Mike Turquette wrote:
> Quoting Peter De Schrijver (2013-02-07 08:24:14)
> > Although tegra_clk_register_super_mux() has a lock parameter, the lock is not
> > actually used by the code. Fixed with this patch.
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > ---
> >  drivers/clk/tegra/clk-super.c |   18 +++++++++++++++---
> >  1 files changed, 15 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/clk/tegra/clk-super.c b/drivers/clk/tegra/clk-super.c
> > index 7ad48a8..2fd924d 100644
> > --- a/drivers/clk/tegra/clk-super.c
> > +++ b/drivers/clk/tegra/clk-super.c
> > @@ -73,7 +73,12 @@ static int clk_super_set_parent(struct clk_hw *hw, u8 index)
> >  {
> >         struct tegra_clk_super_mux *mux = to_clk_super_mux(hw);
> >         u32 val, state;
> > +       int err = 0;
> >         u8 parent_index, shift;
> > +       unsigned long flags = 0;
> 
> I don't think initializing flags to zero is necessary but it is not a
> big deal.  Is gcc throwing a warning?  Otherwise:
> 

Yes. gcc throws a warning if it's not initialized.

Cheers,

Peter.
