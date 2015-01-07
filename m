Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbbAGGku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 01:40:50 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:55428 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbbAGGks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 01:40:48 -0500
Date: Tue, 6 Jan 2015 22:40:39 -0800
From: Tristan Lelong <tristan@lelong.xyz>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add soft kill switch for input devices
Message-ID: <20150107064038.GB4681@lenderer>
References: <1420352645-3706-1-git-send-email-tristan@lelong.xyz>
 <20150106221732.1cbbe3ae@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150106221732.1cbbe3ae@neptune.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 10:17:32PM +0100, Bruno Prémont wrote:
> 
> One big issue I see here is that you start dropping all events at a random
> point in time.
> You may end up within a gesture or just while a button is down and remain
> so until that same button gets pressed again on unmute.
> 
> On your touchscreen, how do things behave if you trigger the muting while
> you are dragging or doing some gesture (and unmute when noone touches
> the touchscreen)?

That is right, I thought of it for pointing devices, and it seemed that it should not be
too much of a problem, even thought it would be better to handle it properly.

> 
> If applied to a keyboard, what happens when you mute while keys are pressed
> and unmute when they have long been released?

This case is actually a bigger problem and I didn't think of it.
> 
> 
> If you could send a "reset" event to input listeners when muting you could
> work around most issues as any application making use of events would know
> that after this "reset" event things should not depend on any past state.

I could definitely do something like this and make sure all the events are handled properly.

> 
> 
> Possibly a better way to achieve your aim is to just unbind and re-bind
> the device from device driver, causing software hotplug.
> That way you are sure no application will perform incorrect guesses while
> device is "muted".

This is another good solution that would work in my case.

If somebody think this patch can be of any interest, I'll be happy to
submit a v2 with correct handling of current events at the time of mutting.

Best regards
