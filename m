Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965224AbaD3VZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:25:23 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:50413 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933552AbaD3VZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:25:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Kevin Hilman <khilman@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Felipe Balbi <balbi@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH/RFC 3/4] of/clk: Register clocks suitable for Runtime PM with the PM core
Date: Wed, 30 Apr 2014 23:25:35 +0200
Message-ID: <2401458.kIFL7AxWq0@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140429131610.29859C4094A@trevor.secretlab.ca>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be> <7hoazpdldx.fsf@paris.lan> <20140429131610.29859C4094A@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2014 14:16:10 Grant Likely wrote:
> On Fri, 25 Apr 2014 16:44:58 -0700, Kevin Hilman <khilman@linaro.org> wrote:
> > Geert Uytterhoeven <geert+renesas@glider.be> writes:
> > > When adding a device from DT, check if its clocks are suitable for
> > > Runtime PM, and register them with the PM core.
> > > If Runtime PM is disabled, just enable the clock.
> > > 
> > > This allows the PM core to automatically manage gate clocks of devices
> > > for Runtime PM.
> > 
> > ...unless the device is already in an existing pm_domain, right?
> > 
> > I like this approach, and it extends nicely what we already do on
> > platforms using drivers/base/power/clock_ops.c into DT land.
> > 
> > My only concern is how this will interact if it's used along with
> > devices that have existing pm_domains.  I don't have any specific
> > concerns (yet, because it's Friday, and my brain is turing off), but it
> > just made me wonder if this will be potentially confusing.
> 
> I have big concerns about this approach. First, it will only work if
> a clock is available at deivce creation time. The conversion of irq
> controllers to normal device drivers has already shown that is a bad
> idea.
> 
> I also don't like that it tries to set up every clock, but there is no
> guarantee that the driver will even use it. I would rather see this
> behaviour linked into the function that obtains the clock at driver
> .probe() time. That way it can handle deferred probe correctly and it
> only sets up clocks that are actually used by the driver.

I like the idea, as it gives an opt-in approach to the problem: drivers could 
decide whether they want the runtime PM core to handle clocks automatically 
(which should cover most cases), but would have the option of handling clocks 
manually if needed for special purposes.

-- 
Regards,

Laurent Pinchart

