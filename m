Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab3LCKDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 05:03:47 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:60382 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3LCKDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 05:03:42 -0500
Date: Tue, 3 Dec 2013 10:03:34 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, broonie@kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [PATCH 2/3] ASoC: ux500_pcm: Differentiate between
 pdata and DT initialisation
Message-ID: <20131203100334.GI11828@lee--X1>
References: <1386007222-10081-1-git-send-email-lee.jones@linaro.org>
 <1386007222-10081-2-git-send-email-lee.jones@linaro.org>
 <529CCDAF.7050205@metafoo.de>
 <20131203083600.GB11828@lee--X1>
 <529D9CD1.3020208@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <529D9CD1.3020208@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Dec 2013, Lars-Peter Clausen wrote:

> On 12/03/2013 09:36 AM, Lee Jones wrote:
> >On Mon, 02 Dec 2013, Lars-Peter Clausen wrote:
> >
> >>On 12/02/2013 07:00 PM, Lee Jones wrote:
> >>>If booting with full DT support (i.e. DMA too, the last piece of the
> >>>puzzle), then we don't need to use the compatible request channel call
> >>>back. We also require slightly different flags to inform the core that
> >>>we are booting with DT.
> >>
> >>I don't think you need differentiate between DT and non-DT here.
> >>If the SND_DMAENGINE_PCM_FLAG_COMPAT is set and the
> >>SND_DMAENGINE_PCM_FLAG_NO_DT is not set it will first try to request the
> >>channels from the DT if that fails it will fallback to the compat path. So
> >>all this patch needs to do is remove the SND_DMAENGINE_PCM_FLAG_NO_DT, that
> >>should be it.
> >
> >I have no way of testing that, as we are currently 80% through
> >shutting down platform data altogether. In fact, I think there is only
> >ASoC to be converted. Most of this stuff is going to be ripped out
> >within the next couple of weeks in any case. It will happen as soon as
> >I can find an hour or two to work on it.
> >
> >For that reason I didn't want to disturb the current semantics. I've
> >already found that a bunch of he generic (oh, you can just use the
> >central) functions (for that) don't actually work for us for one
> >reason or another.
> 
> All SND_DMAENGINE_PCM_FLAG_NO_DT does is to skip trying to request
> the channel from the dt. If of_node is NULL this step will be
> skipped anyway. So only setting SND_DMAENGINE_PCM_FLAG_NO_DT if we
> already know that the node is NULL is redundant.

I'll just have to trust you on this and resubmit with the other patch.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
