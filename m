Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbbA1Bvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:51:49 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:46740 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760640AbbA1Bvq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:51:46 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Marek Vasut <marex@denx.de>, "Zhi Li" <lznuaa@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <201501220039.02073.marex@denx.de>
Cc: "Stefan Wahren" <stefan.wahren@i2se.com>,
        "kernel list" <linux-kernel@vger.kernel.org>,
        "Sascha Hauer" <kernel@pengutronix.de>, harald@ccbib.org,
        "Shawn Guo" <shawn.guo@linaro.org>,
        "Fabio Estevam" <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1419762402-4548-1-git-send-email-stefan.wahren@i2se.com>
 <CAHrpEqQ-eoqM3W1hYcS6EPTmur1FSfm8TeEjYrtZ+PquavL86w@mail.gmail.com>
 <201501220039.02073.marex@denx.de>
Message-ID: <20150128015131.22722.22882@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH V2] clk: mxs: Fix invalid 32-bit access to frac registers
Date: Tue, 27 Jan 2015 17:51:31 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Marek Vasut (2015-01-21 15:39:01)
> On Wednesday, January 21, 2015 at 05:16:03 PM, Zhi Li wrote:
> > On Sun, Dec 28, 2014 at 4:26 AM, Stefan Wahren <stefan.wahren@i2se.com> wrote:
> > > According to i.MX23 and i.MX28 reference manual the fractional
> > > clock control registers must be addressed by byte instructions.
> > 
> > I don't think mx23 and mx28 have such limitation. I will double check
> > with IC team about this.
> > RTL is generated from a xml file. All registers implement is unified.
> > I don't think only clock control register have such limitation and
> > other registers not.
> 
> Hi,
> 
> Section 10.8.24 in the MX28 datasheet (Fractional Clock Control Register 0) 
> states otherwise, but maybe the documentation is simply not matching the
> silicon.
> 
> Here's a quote:
> "
> This register controls the 9-phase fractional clock dividers. The fractional 
> clock frequencies are a product of the values in these registers. NOTE: This 
> register can only be addressed by byte instructions. Addressing word or half-
> word are not allowed.
> "
> 
> I also recall seeing weird behavior when these registers were accessed by word
> access in U-Boot, so I believe the datasheet is correct.

Hi Frank,

Are you satisfied with this patch?

Regards,
Mike

> 
> Best regards,
> Marek Vasut
