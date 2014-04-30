Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648AbaD3XOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 19:14:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56154 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565AbaD3XOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 19:14:15 -0400
Date: Thu, 1 May 2014 00:13:07 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jim Quinlan <jim2101024@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mike.turquette@linaro.org" <mike.turquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Linux common clock framework: device with many clocks
Message-ID: <20140430231307.GA10250@e106331-lin.cambridge.arm.com>
References: <CANCKTBuOK41=ZxHcDRthc0uc81-nDr_66veeQvUDNjsKq85OSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANCKTBuOK41=ZxHcDRthc0uc81-nDr_66veeQvUDNjsKq85OSw@mail.gmail.com>
Thread-Topic: [RFC] Linux common clock framework: device with many clocks
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 30, 2014 at 09:39:11PM +0100, Jim Quinlan wrote:
> In most examples of .dtsi files I have perused, a device is associated with
> typically one clock, maybe two.  In the SoC I'm working on, some devices
> need to turn off multiple clocks for PM, as many as 13.   The driver gets
> the clocks from the device tree, and when the driver wants to turn off
> clocks to the device, it loops through all 13 clocks.
> 
> I'm wondering if is possible to abstract a group of many clocks into one
> "software clock". Invoking clk_disable() on said software clock would
> effect the iteration of clk_disable() on all 13 of the clocks it governs.
>  Enabling would effect clk_enable() on all 13.  This would make the driver
> writer's life a little simpler.
> 
> I've looked at the Linux Common Clock Framework, and it doesn't really
> accommodate multiple active parents as it's somewhat contrary to its
> design.  Also, playing with the innards of clk.c is ill-advised.  Should I
> just stick to putting iteration over the clocks in all my drivers, or is
> there a better way?

This doesn't strike me as a DT issue. The DT should describe all the
clocks that a given block takes, and the representation of said clocks
in the DT is completely separate matter from the management of said
clocks in any given driver.

If you want a helpful abstraction for combining clocks for management
purposes you'd be better off talking to Mike Turquette (CC'd), as he's
in charge of the common clock framework.

Cheers,
Mark.
