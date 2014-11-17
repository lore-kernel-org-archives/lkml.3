Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaKQPNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:13:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38769 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbaKQPNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:13:21 -0500
Date: Mon, 17 Nov 2014 15:13:18 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: Lee Jones <lee.jones@linaro.org>, broonie@kernel.org,
        linus.walleij@linaro.org, gnurou@gmail.com,
        alsa-devel@alsa-project.org, tiwai@suse.de,
        patches@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: arizona: Add support for CS47L24
Message-ID: <20141117151318.GE12443@opensource.wolfsonmicro.com>
References: <20141111165227.GA24344@opensource.wolfsonmicro.com> <20141111171532.GA26106@opensource.wolfsonmicro.com> <20141113101228.GE24004@x1> <20141113164017.GA12443@opensource.wolfsonmicro.com> <20141117121648.GP24004@x1> <20141117125433.GA29518@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117125433.GA29518@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 12:54:33PM +0000, Richard Fitzgerald wrote:
> On Mon, Nov 17, 2014 at 12:16:48PM +0000, Lee Jones wrote:
> > On Thu, 13 Nov 2014, Charles Keepax wrote:
> > > This looks good to me. I don't quite follow what you are
> > > requesting with the header file? This still uses the header file
> > > for the registers but just defining which are available on this
> > > chip.
> > 
> > Looks like I was a little hasty with my comments.  However 8000 lines
> > over 4 platforms just to describe which registers are readable is all
> > a little bit grim.  Is there any way you can use ranges instead of
> > listing every single register on the chip?  How many gaps are there? 
> > 
> 
> It's debatable. Ranges would be possible but there are a lot of gaps.
> Personally, speaking as someone who has to maintain these drivers, I
> like that fact that I can look at this file and see exactly which registers
> are readable and volatile because they are all explicitly listed. It's also
> useful that the files are searchable for specific registers.
> 
> I'll point Charles at this to get his opinion.

Main thing is I do quite like being able to easily grep/search
for a register and have it turn up. Would get pretty annoying
having to search for the register and a few guesses at reasonable
start/end of ranges it might be in. There are also quite a lot of
gaps as the designers tend to leave some room to expand between
IP blocks.

I do see what you are saying here the Arizona devices are pretty
massive and the tables get pretty large and there is a fair
amount of duplication between chips. A couple of ideas come to
mind but they all have fairly debatable properties:

1) We could add #defines for various IP blocks and the readable
callback could include these defines for various blocks. Which
would reduce the duplication between chips. Although a lot of the
blocks have small differences between chips which might hurt some
of the benefits and this does also have some negative affects on the
greppability of it all. This could also be done as functions then
some of the differences could be taken into account locally for
each block but that hurts the performance and probably
readability.

2) We could add a function to the regmap core that makes any
register with a default or marked as volatile readable. That
would remove the readable callback completely and not really hurt
greppability (assuming we could change the default array to use
the #defines for the register) but at fairly large runtime cost.
We would have to search the default array everytime we wanted to
check if a register is readable.

I would probably like to see Mark's thoughts on either of those
before we did anything as neither of them feel like great
suggestions to me.

Thanks,
Charles


