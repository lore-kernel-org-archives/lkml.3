Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbaAFSKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:10:49 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60464 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbaAFSKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:10:47 -0500
Date: Mon, 6 Jan 2014 10:10:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] mfd: ti_am335x_tscadc: Don't read back REG_SE
Message-ID: <20140106181043.GC2754@core.coreip.homeip.net>
References: <1387466911-3732-1-git-send-email-bigeasy@linutronix.de>
 <1387466911-3732-4-git-send-email-bigeasy@linutronix.de>
 <20140106093525.GE23772@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106093525.GE23772@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 09:35:25AM +0000, Lee Jones wrote:
> On Thu, 19 Dec 2013, Sebastian Andrzej Siewior wrote:
> 
> > The purpose of reg_se_cache has been defeated. It should avoid the
> > read-back of the register to avoid the latency and the fact that the
> > bits are reset to 0 after the individual conversation took place.
> > 
> > The reason why this is required like this to work, is that read-back of
> > the register removes the bits of the ADC so they do not start another
> > conversation after the register is re-written from the TSC side for the
> > update.
> > To avoid the not required read-back I introduce a "set once" variant which
> > does not update the cache mask. After the conversation completes, the
> > bit is removed from the SE register anyway and we don't plan a new
> > conversation "any time soon". The current set function is renamed to
> > set_cache to distinguish the two operations.
> > This is a small preparation for a larger sync-rework.
> > 
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > ---
> >  drivers/iio/adc/ti_am335x_adc.c           |  4 ++--
> >  drivers/input/touchscreen/ti_am335x_tsc.c |  4 ++--
> 
> Just need Dmitry's Ack now.

Well, that has nothing to do with input per se but rather inner workings
of the device. But yes, FWIW:

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks.

-- 
Dmitry
