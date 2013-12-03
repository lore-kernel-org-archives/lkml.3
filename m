Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab3LCM30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:29:26 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55594 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3LCM3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:29:23 -0500
Date: Tue, 3 Dec 2013 12:29:17 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: alsa-devel@alsa-project.org, broonie@kernel.org, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 1/2] ASoC: ux500_pcm: Differentiate between
 pdata and DT initialisation
Message-ID: <20131203122917.GD12031@lee--X1>
References: <1386066427-6862-1-git-send-email-lee.jones@linaro.org>
 <529DC6BE.3080607@metafoo.de>
 <20131203120420.GC12031@lee--X1>
 <529DCB76.4070705@metafoo.de>
 <529DCD8A.30600@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <529DCD8A.30600@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Dec 2013, Lars-Peter Clausen wrote:

> On 12/03/2013 01:15 PM, Lars-Peter Clausen wrote:
> > On 12/03/2013 01:04 PM, Lee Jones wrote:
> >> On Tue, 03 Dec 2013, Lars-Peter Clausen wrote:
> >>
> >>> On 12/03/2013 11:27 AM, Lee Jones wrote:
> >>>> If booting with full DT support (i.e. DMA too, the last piece of the
> >>>> puzzle), then we don't need to use the compatible_request_channel call
> >>>> back or require some of the historical bumph which probably isn't
> >>>> required by a platform data start-up now either. This will also be
> >>>> ripped out in upcoming commits.
> >>>>
> >>>> Cc: alsa-devel@alsa-project.org
> >>>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >>>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >>>
> >>> Strictly speaking you do not need the second config, but well considering
> >>> that this will all hopefully be removed soon anyway it should be fine.
> >>
> >> That's true it will, but why don't we need the second config? I won't
> >> want the compat function to be called in the DT case.
> > 
> > It will only be called if it was not possible to request the DMA channel
> > from the DT.
> 
> The logic used to request the channel is basically this (in pseudo code).
> 
> chan = NULL.
> 
> if (of_node && !(flags & NO_DT))
> 	chan = dma_request_slave_channel(...)
> 
> if (!chan && (flags & COMPAT))
> 	chan = dma_request_channel(compat_filter_fn, compat_filter_data);

Okay, fair enough.

But as you say, this should be fine for now. I'll tend to the
left-over cruft when I convert the driver to DT only.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
