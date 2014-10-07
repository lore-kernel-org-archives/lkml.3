Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaJGILz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:11:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:1928 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbaJGIK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:10:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,668,1406617200"; 
   d="scan'208";a="601633918"
Date: Tue, 7 Oct 2014 13:08:20 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, subhransu.s.prusty@intel.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.jf.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/27] mfd: ab8500-gpadc: use
 pm_runtime_last_busy_and_autosuspend helper
Message-ID: <20141007073820.GS1638@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
 <1411575342-31048-12-git-send-email-vinod.koul@intel.com>
 <20141006214047.GI18035@lee--X1>
 <20141007072125.GL18035@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141007072125.GL18035@lee--X1>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 08:21:25AM +0100, Lee Jones wrote:
> On Mon, 06 Oct 2014, Lee Jones wrote:
> 
> > On Wed, 24 Sep 2014, Vinod Koul wrote:
> > 
> > > Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
> > > coding the same code
> > > 
> > > Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> > > ---
> > >  drivers/mfd/ab8500-gpadc.c |    6 ++----
> > >  1 files changed, 2 insertions(+), 4 deletions(-)
> > 
> > Applied with Linus' Ack.
> 
> Okay, I just had to search online for the other patches (as you left
> me off PATCH 00/27).  It appears this approach has gone down like a
> lead balloon.  For this reason I'm pulling these patches from my v3.19
> branch.
I was about to reply to you to revert.
I need to fix the script I used to do CC on 0th patch, looks like few
people were left off while collecting the names. Sorry about that

-- 
~Vinod

> 
> > > diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
> > > index 36000f9..46bea3a 100644
> > > --- a/drivers/mfd/ab8500-gpadc.c
> > > +++ b/drivers/mfd/ab8500-gpadc.c
> > > @@ -571,8 +571,7 @@ int ab8500_gpadc_double_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
> > >  	}
> > >  
> > >  	/* Disable VTVout LDO this is required for GPADC */
> > > -	pm_runtime_mark_last_busy(gpadc->dev);
> > > -	pm_runtime_put_autosuspend(gpadc->dev);
> > > +	pm_runtime_last_busy_and_autosuspend(gpadc->dev);
> > >  
> > >  	mutex_unlock(&gpadc->ab8500_gpadc_lock);
> > >  
> > > @@ -910,8 +909,7 @@ static int ab8500_gpadc_resume(struct device *dev)
> > >  	if (ret)
> > >  		dev_err(dev, "Failed to enable vtvout LDO: %d\n", ret);
> > >  
> > > -	pm_runtime_mark_last_busy(gpadc->dev);
> > > -	pm_runtime_put_autosuspend(gpadc->dev);
> > > +	pm_runtime_last_busy_and_autosuspend(gpadc->dev);
> > >  
> > >  	mutex_unlock(&gpadc->ab8500_gpadc_lock);
> > >  	return ret;
> > 
> 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

-- 
