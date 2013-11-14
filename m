Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3KNO5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:57:18 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:42405 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab3KNO5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:57:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Simon Horman [Horms]" <horms@verge.net.au>
Subject: Re: [PATCH 01/03] gpio: rcar: Use lazy disable and mask on suspend
Date: Thu, 14 Nov 2013 15:57:49 +0100
Message-ID: <2298370.sXN8x2E2mt@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CANqRtoSkTBG1o1Vrfay_qPxwoyCuitH5cJNCjDdEuiPf0XjvUw@mail.gmail.com>
References: <20131113225927.21449.78044.sendpatchset@w520> <4743540.rTIWauTJHg@avalon> <CANqRtoSkTBG1o1Vrfay_qPxwoyCuitH5cJNCjDdEuiPf0XjvUw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Thursday 14 November 2013 17:50:09 Magnus Damm wrote:
> On Thu, Nov 14, 2013 at 11:17 AM, Laurent Pinchart wrote:
> > On Thursday 14 November 2013 11:03:06 Magnus Damm wrote:
> >> On Thu, Nov 14, 2013 at 9:07 AM, Laurent Pinchart wrote:
> >> > On Thursday 14 November 2013 07:59:36 Magnus Damm wrote:
> >> >> From: Magnus Damm <damm@opensource.se>
> >> >> 
> >> >> Set the ->irq_enable() and ->irq_disable() methods to NULL
> >> >> to enable lazy disable of interrupts.
> >> > 
> >> > Is that just for optimization purpose, or is there another reason ?
> >> 
> >> It is needed for IRQCHIP_MASK_ON_SUSPEND operation, which in turn is
> >> needed for Suspend-to-RAM.
> >> 
> >> >> Also extend the code to set IRQCHIP_MASK_ON_SUSPEND which tells the
> >> >> core that only IRQs marked as wakeups need to stay enabled during
> >> >> Suspend-to-RAM.
> >> > 
> >> > Shouldn't this be split to a separate patch ?
> >> 
> >> I could split them up, but since there is a dependency and since I
> >> mainly care about making sure Suspend-to-RAM works I preferred to keep
> >> them together.
> > 
> > Fine with me. Could you then please update the commit message to mention
> > that lazy disabling is required for IRQCHIP_MASK_ON_SUSPEND ? Same
> > comment for patch 03/03.
> 
> Since when is it common practise to describe the dependencies for the
> various components included in a single commit?

It's common practice to describe the reason for a commit in the commit 
message. In this case the two changes seemed unrelated at first sight, I 
believe explained why they're both needed would be good. 

> My opinion is that the person reading the code if requiring more information
> will have to grep for IRQCHIP_MASK_ON_SUSPEND in the friendly source code
> and learn how the subsystem is held together.
> 
> In the case you have some special detailed commit message that you would
> like me to use then please feel free to propose that. If not then I will
> then split up the patches.

I would have use something like

"gpio: rcar: Use mask on suspend

Set IRQCHIP_MASK_ON_SUSPEND to tell the core that only IRQs marked as wakeups 
need to stay enabled during Suspend-to-RAM. This requires lazy interrupt 
disabling, so set the ->irq_enable() and ->irq_disable() methods to NULL."

Alternatively you can split the patches, I have no preference.

-- 
Regards,

Laurent Pinchart

