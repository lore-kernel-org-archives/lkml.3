Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433AbaFQPQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:16:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46236 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933051AbaFQPQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:16:44 -0400
Date: Tue, 17 Jun 2014 16:16:42 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: arizona: Destroy regulators after the other
	MFD cells
Message-ID: <20140617151642.GE26741@opensource.wolfsonmicro.com>
References: <1401699704-17902-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1401699704-17902-2-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140617145420.GH29841@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617145420.GH29841@lee--X1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 03:54:20PM +0100, Lee Jones wrote:
> On Mon, 02 Jun 2014, Charles Keepax wrote:
> 
> > Several of the cells depend on the regulators provided by the
> > arizona-micsupp and arizona-ldo1 cells. As such use the new remove_level
> > feature of the MFD core to ensure the regulators are destroyed after all
> > the other cells.
> > 
> > Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> > ---
> >  drivers/mfd/arizona-core.c |   20 ++++++++++++++++----
> >  1 files changed, 16 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> > index 51c0110..76248bc 100644
> > --- a/drivers/mfd/arizona-core.c
> > +++ b/drivers/mfd/arizona-core.c
> > @@ -570,7 +570,10 @@ static inline int arizona_of_get_core_pdata(struct arizona *arizona)
> >  #endif
> >  
> >  static const struct mfd_cell early_devs[] = {
> > -	{ .name = "arizona-ldo1" },
> > +	{
> > +		.name = "arizona-ldo1",
> > +		.remove_level = 1,
> > +	},
> >  };
> 
> Not keen on this approach at all.
> 
> +1 for the new reverse-probe-helpers.

Yeah that does seem like a better solution, I am looking at it
but it is a little more complex than I hoped so will be a
slight delay on getting a patch out for it.

Thanks,
Charles
