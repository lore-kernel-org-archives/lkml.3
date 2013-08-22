Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3HVA1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 20:27:55 -0400
Received: from muin.pair.com ([209.68.1.55]:63285 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab3HVA1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 20:27:54 -0400
MIME-Version: 1.0
In-Reply-To: <1377127873.5029.72.camel@snotra.buserror.net>
References: <1375094944-3343-1-git-send-email-hongbo.zhang@freescale.com>
	<1375094944-3343-3-git-send-email-hongbo.zhang@freescale.com>
	<521541EE.4010303@wwwdotorg.org>
	<1377125827.5029.50.camel@snotra.buserror.net>
	<52154A22.4090809@wwwdotorg.org>
	<1377127873.5029.72.camel@snotra.buserror.net>
Date: Wed, 21 Aug 2013 19:27:52 -0500
Message-ID: <CAOZdJXXvyFQZqyKjDerESB7RmZ9J76R40xLtNGfTd1Wv=W-bow@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] DMA: Freescale: Add new 8-channel DMA engine
 device tree nodes
From: Timur Tabi <timur@tabi.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        hongbo.zhang@freescale.com, lkml <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>, djbw@fb.com,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 6:31 PM, Scott Wood <scottwood@freescale.com> wrote:
>
>> > Other than "this is how the existing binding works and we're not going
>> > to break compatibility", it allows the OS more flexibility to choose
>> > whether to bind to controllers or directly to the channels.  Sometimes a
>> > channel will be labelled with a different compatible if it has a fixed
>> > purpose such as being connected to audio hardware (e.g. mpc8610_hpcd.dts
>> > where some channels are "fsl,ssi-dma-channel").
>>
>> That sounds terribly like encoding policy into DT rather than it being a
>> HW description.
>
> It is hardware description.  Those DMA channels are physically wired
> into the audio hardware.  Other DMA channels in the same system aren't.

Well, not quite.  Technically the DMA channel can be dynamically
assigned to the SSI, but there are limits.  At the time the code was
written, there was no way to reserve a DMA channel from the generic
DMA driver, and I didn't want to have to depend on that driver either.
 Using the device tree forced a specific pair of channels to be
assigned to each SSI.  The audio driver has code to program the SoC to
route whichever DMA channels are assigned, but it assumes that the
device tree has a valid assignment.

I believe the generic DMA driver can now accept DMA channel
reservations, but I don't think it works both ways.  That is, if the
audio driver loads first, I don't think there's a clean way to tell
the DMA driver which channels have already been taken by the audio
driver.
