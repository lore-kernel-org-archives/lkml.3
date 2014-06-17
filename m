Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbaFQPR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:17:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46242 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754462AbaFQPR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:17:57 -0400
Date: Tue, 17 Jun 2014 16:17:56 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] mfd: arizona: Don't use devres for DCVDD
Message-ID: <20140617151756.GF26741@opensource.wolfsonmicro.com>
References: <1401699043-16835-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1401699043-16835-4-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140617143610.GD29841@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617143610.GD29841@lee--X1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 03:36:10PM +0100, Lee Jones wrote:
> On Mon, 02 Jun 2014, Charles Keepax wrote:
> 
> > Currently the Arizona core uses a devm_regulator_get against its own
> > device node to obtain DCVDD. The Arizona core is an MFD device and DCVDD
> > is usually supplied by a child node (arizona-ldo1) of the core. As
> > devres destruction for the MFD device will run after all its children
> > have been destroyed, the regulator will be destroyed before devres
> > calls regulator_put. This causes a warning from both the destruction of
> > the child node, as the regulator is still open, and from the put of the
> > regulator as the regulator device has already been destroyed.
> > 
> > This patch handles the regulator get and put without devres to avoid
> > this issue.
> > 
> > Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> > ---
> >  drivers/mfd/arizona-core.c |    9 ++++++---
> >  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> For the fear of someone coming along and undoing this work, can you
> write a nice succinct comment above regulator_get() that describes why
> you're not using managed resources as a subsequent patch please?
> 
> Patch applied though.

Good point I should have thought to do that myself, I will get a
patch out for this shortly.

Thanks,
Charles
