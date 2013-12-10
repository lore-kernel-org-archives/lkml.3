Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab3LJTqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:46:47 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19447 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3LJTqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:46:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 10 Dec 2013 11:39:49 -0800
Date: Tue, 10 Dec 2013 11:46:43 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
X-X-Sender: pwalmsley@tamien
To: Takashi Iwai <tiwai@suse.de>
CC: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Jaroslav Kysela <perex@perex.cz>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ALSA: at73c213: clk_round_rate() can return a zero upon
 error
In-Reply-To: <s5hzjo9p2ap.wl%tiwai@suse.de>
Message-ID: <alpine.DEB.2.02.1312101054570.4127@tamien>
References: <alpine.DEB.2.02.1312091837280.4127@tamien> <s5hzjo9p2ap.wl%tiwai@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013, Takashi Iwai wrote:

> At Mon, 9 Dec 2013 18:40:48 -0800, Paul Walmsley wrote:
>>
>> Treat both negative and zero return values from clk_round_rate()
>> as errors.  This is needed since subsequent patches will convert
>> clk_round_rate()'s return value to be an unsigned type, rather
>> than a signed type, since some clock sources can generate rates higher
>> than (2^31)-1 Hz.
>
> Is the behavior "returning zero upon error" already in 3.13?  That is,
> should this (and another) patch be taken as a 3.13-fix patch, or it's
> for 3.14?

It depends on the platform.  The Common Clock Framework code returns 0 
upon error right now.  But other clock framework implementations, such as 
the one used by the Atmel AT91 boards, return negative error codes.  And 
looking at the mainline code, it looks like the at73c213 chip is most 
likely to be used on AT91 boards.

So if you want to send this patch for v3.13-rc, it's probably justified,
but it's low-priority.  v3.14 is also fine.

I'll be sending some followup patches to the platform maintainers to 
change the clock framework code to return 0 upon error.  But those can't 
be applied until the drivers are fixed, if we want to avoid regressions in 
error path handling.  So from that point of view, applying these driver 
patches in v3.13-rc would mean there is less delay to getting the platform 
clock framework fixes upstream :-)


- Paul
