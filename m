Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaJGHVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 03:21:17 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:55935 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaJGHVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 03:21:14 -0400
Date: Tue, 7 Oct 2014 08:21:09 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, subhransu.s.prusty@intel.com,
        Samuel Ortiz <sameo@linux.intel.com>,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 12/27] mfd: arizona: use
 pm_runtime_last_busy_and_autosuspend helper
Message-ID: <20141007072109.GK18035@lee--X1>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
 <1411575342-31048-13-git-send-email-vinod.koul@intel.com>
 <20141006214134.GJ18035@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141006214134.GJ18035@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Oct 2014, Lee Jones wrote:

> On Wed, 24 Sep 2014, Vinod Koul wrote:
> 
> > Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
> > coding the same code
> > 
> > Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> > ---
> >  drivers/mfd/arizona-irq.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> Applied to v3.19 (same as patch 11), with Charles' Ack.

Okay, I just had to search online for the other patches (as you left
me off PATCH 00/27).  It appears this approach has gone down like a
lead balloon.  For this reason I'm pulling these patches from my v3.19
branch.

> > diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
> > index d420dbc..dc755d1 100644
> > --- a/drivers/mfd/arizona-irq.c
> > +++ b/drivers/mfd/arizona-irq.c
> > @@ -138,8 +138,7 @@ static irqreturn_t arizona_irq_thread(int irq, void *data)
> >  		}
> >  	} while (poll);
> >  
> > -	pm_runtime_mark_last_busy(arizona->dev);
> > -	pm_runtime_put_autosuspend(arizona->dev);
> > +	pm_runtime_last_busy_and_autosuspend(arizona->dev);
> >  
> >  	return IRQ_HANDLED;
> >  }
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
