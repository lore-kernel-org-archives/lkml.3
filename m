Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaKRLeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:34:11 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:54529 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbaKRLeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:34:08 -0500
Date: Tue, 18 Nov 2014 11:34:01 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        linus.walleij@linaro.org, gnurou@gmail.com,
        alsa-devel@alsa-project.org, tiwai@suse.de,
        patches@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: arizona: Add support for CS47L24
Message-ID: <20141118113401.GW24004@x1>
References: <20141111165227.GA24344@opensource.wolfsonmicro.com>
 <20141111171532.GA26106@opensource.wolfsonmicro.com>
 <20141113101228.GE24004@x1>
 <20141113164017.GA12443@opensource.wolfsonmicro.com>
 <20141117121648.GP24004@x1>
 <20141117125433.GA29518@opensource.wolfsonmicro.com>
 <20141117150107.GF2722@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141117150107.GF2722@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, Mark Brown wrote:

> On Mon, Nov 17, 2014 at 12:54:33PM +0000, Richard Fitzgerald wrote:
> > On Mon, Nov 17, 2014 at 12:16:48PM +0000, Lee Jones wrote:
> 
> > > Looks like I was a little hasty with my comments.  However 8000 lines
> > > over 4 platforms just to describe which registers are readable is all
> > > a little bit grim.  Is there any way you can use ranges instead of
> > > listing every single register on the chip?  How many gaps are there? 
> 
> > It's debatable. Ranges would be possible but there are a lot of gaps.
> > Personally, speaking as someone who has to maintain these drivers, I
> > like that fact that I can look at this file and see exactly which registers
> > are readable and volatile because they are all explicitly listed. It's also
> > useful that the files are searchable for specific registers.
> 
> > I'll point Charles at this to get his opinion.
> 
> It's probably also worth pointing out that while ranges do compress the
> data a bit they make it harder to answer questions like "is this
> register mapped properly" since the question becomes "is the numeric
> value of this symbol between the numeric values of any of these other
> pairs of symbols we have listed here".  I generally find it harder to
> review drivers using ranges since when checking that things are mapped
> voatile or whatever you have to do lookups like that.

Very well, thanks Mark and Charles.

How about we go back to my original idea then and chucking all of
these massive tables into a nice header file in include?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
