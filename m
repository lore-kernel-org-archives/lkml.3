Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab3DYJYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:24:20 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:36866 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3DYJYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:24:19 -0400
Date: Thu, 25 Apr 2013 10:24:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 14/32] dmaengine: ste_dma40: Remove 'always true' checking
Message-ID: <20130425092413.GH4623@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-15-git-send-email-lee.jones@linaro.org>
 <CACRpkdZ5BzmjFNxHrhXVyRhMTMsH4Cq1XRmgiWQjU2e6cCO1bA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZ5BzmjFNxHrhXVyRhMTMsH4Cq1XRmgiWQjU2e6cCO1bA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Linus Walleij wrote:

> On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Before allocating memory for logical channels, the current driver
> > checks to see if there are any. Well as the dma40_memcpy_channels[]
> > array is always populated, the check is always true. Best to
> > remove the check.
> >
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Dan Williams <djbw@fb.com>
> > Cc: Per Forlin <per.forlin@stericsson.com>
> > Cc: Rabin Vincent <rabin@rab.in>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> (...)
> 
> > -       if (num_log_chans + ARRAY_SIZE(dma40_memcpy_channels)) {
> 
> So I guess this was changed when moving the memcpy channels
> into the driver.

Right.

> > -               /*
> > -                * The max number of logical channels are event lines for all
> > -                * src devices and dst devices
> > -                */
> > -               base->lookup_log_chans = kzalloc(num_log_chans *
> > -                                                sizeof(struct d40_chan *),
> > -                                                GFP_KERNEL);
> 
> And at that point you forgot to rewrite this as
> kzalloc((num_log_chans + ARRAY_SIZE(dma40_memcpy_channels)), ...)?

I guess I didn't notice that, yes.

> > -               if (!base->lookup_log_chans)
> > -                       goto failure;
> > -       }
> > +       base->lookup_log_chans = kzalloc(num_log_chans *
> > +                                        sizeof(struct d40_chan *),
> > +                                        GFP_KERNEL);
> > +       if (!base->lookup_log_chans)
> > +               goto failure;
> 
> So this change should also include the memcpy channels.
> 
> I'll go back and comment again on the patch moving the
> memcpy channels into the driver.

Okay, NP.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
