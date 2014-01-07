Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266AbaAGObI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:31:08 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:39784 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaAGObE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:31:04 -0500
MIME-Version: 1.0
In-Reply-To: <20140107135409.GA21190@thinkpad-t410>
References: <1389088723-30959-1-git-send-email-artagnon@gmail.com> <20140107135409.GA21190@thinkpad-t410>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 7 Jan 2014 20:00:23 +0530
Message-ID: <CALkWK0nL3JOvznns2vApzV9+d1JDLgLX=x=6epw-JMEzANMWDA@mail.gmail.com>
Subject: Re: [PATCH 0/4] Get EDID late for VGA switcheroo
To: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Andreas Heider <andreas@meetr.de>,
        Chris Wilson <chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Forshee wrote:
>  1. On many Macbook models the firmware isn't putting LVDS information
>     in opregion. Reading the EDID during device initialization also
>     fails since the DDC is muxed to the DGPU, so i915 concludes there's
>     no LVDS and doesn't register an LVDS connector at all. I also think
>     it was impossible to register a new connector at a later time,
>     though I'm not sure about that.

On a different thread, Chris is helping me write a series to fill in
the switcheroo-reprobe callback with corresponding get-edid functions.
Do you think it'll be useful?

>  2. If i915 is forced to register the LVDS connector (say via a quirk)
>     it still may not know the panel mode and guesses something rather
>     conservative. This mode it assumes is used to allocate framebuffer
>     memory, which is likely to end up being too small, and I don't think
>     there was any support for resizing it later. This resulted in VTs
>     not working because there isn't enough framebuffer memory for the
>     mode they're trying to use.

I saw your quirk-patch (https://lkml.org/lkml/2012/8/4/128). Seems
like a rather inelegant approach to register the LVDS connector
unconditionally during initialization; I'll try to avoid going down
this road.

>  3. So what is really wanted is to be able to mux just the DDC over to
>     the IGPU when the device is initialized to read the panel mode. One
>     possible problem is that the hw might not support muxing the DDC
>     separately, but Apple hw does so we'll ignore that for now. The
>     basic code for muxing only the DDC isn't too difficult, and I had
>     some patches for this at one point. The problem is that the handler
>     must register with vga_switcheroo before this is possible, so
>     there's a module initialization ordering issue that wasn't easily
>     solved. Maybe now it would be possible to do something with
>     EPROBE_DEFER, though I'm not sure how i915 would know whether or not
>     it should wait for a switcheroo handler.

I didn't understand much of the above; I suppose it'll start making
sense when I'm deeper into the issue.

> I just didn't have enough time to spend on this issue to work through
> all of this. I also never looked at doing this with eDP, which is what I
> thought all the Macbooks have been using for the last couple of years.
> Are you sure your machine uses LVDS and not eDP?

I just assumed that it was LVDS; turns out it's eDP.

I have time to work on the issue now, so I'd appreciate any help I can get.
