Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967200Ab3DRLsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:48:04 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:50434 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966539Ab3DRLsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:48:02 -0400
Date: Thu, 18 Apr 2013 12:47:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 24/32] dmaengine: ste_dma40: Supply full Device Tree
 parsing support
Message-ID: <20130418114756.GE27903@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <201304181306.34835.arnd@arndb.de>
 <20130418113138.GD27903@gmail.com>
 <201304181337.32700.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201304181337.32700.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Apr 2013, Arnd Bergmann wrote:

> On Thursday 18 April 2013, Lee Jones wrote:
> > You're right, I am a little confused by them.
> > 
> > I call them 'device type' because that's what they're called already.
> > Grep for 'dma_dev_type'. This is the number which gets split into
> > event group and line, like this:
> > 
> >         event_group = D40_TYPE_TO_GROUP(dev_type);
> >         event_line = D40_TYPE_TO_EVENT(dev_type);
> > 
> > > and I would put that number first.
> > 
> > So you want me to switch that round so it looks like:
> > 
> >         dmas = <<phandle> <dev_type> <fixed_chan> <flags>;
> > 
> > Instead of what I have at the moment:
> > 
> >         dmas = <<phandle> <fixed_chan> <dev_type> <flags>;
> > 
> > Correct?
> 
> Yes, that's probably better and more in line with what the other
> drivers do. You could also put the fixed_chan last if that helps.

I'd rather keep the flags as the final cell if it's all the same to you?

> I would still like to get a confirmation that we actually still
> require the fixed channel assignment, since it's just used
> in one driver, and that might only be needed for some buggy
> hardware revision if we're lucky.

Unfortunately not:

`git grep "\.use_fixed_channel" <internal_kernel> | grep true | wc -l`
8

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
