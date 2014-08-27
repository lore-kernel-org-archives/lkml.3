Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018AbaH0T7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:59:03 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:35463 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaH0T7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:59:00 -0400
Message-ID: <53FE387F.3030302@gmail.com>
Date: Wed, 27 Aug 2014 21:58:55 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] regulator: max77802: set opmode to normal if off
 is read from hw
References: <1409053061-22568-1-git-send-email-javier.martinez@collabora.co.uk> <53FE2446.3040402@gmail.com> <20140827183733.GN17528@sirena.org.uk> <53FE25EB.7060702@gmail.com> <20140827184705.GO17528@sirena.org.uk> <53FE2901.50508@gmail.com> <20140827191526.GS17528@sirena.org.uk> <53FE2F9E.80501@gmail.com> <20140827194411.GU17528@sirena.org.uk>
In-Reply-To: <20140827194411.GU17528@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.08.2014 21:44, Mark Brown wrote:
> On Wed, Aug 27, 2014 at 09:21:02PM +0200, Tomasz Figa wrote:
>> On 27.08.2014 21:15, Mark Brown wrote:
> 
>>> This is in the scenario where the previously running Linux changed the
>>> mode to something other than normal and where the freshly booted Linux
>>> can't figure out how to do that when it needs to.  I'm not sure how
>>> plausible that scenario is, or that real systems would handle it
>>> robustly.
> 
>> I'm not sure I'm getting your point.
> 
>> If the only thing Linux can do is read back the opmode from PMIC
>> registers, it doesn't explicitly set it to something other, but rather
>> reuses what was set by something before it (or, after this patch,
>> defaults to NORMAL if it's OFF), i.e. the low level firmware or Linux.
> 
>> However the information about original setting is lost whenever Linux
>> turns the regulator off and performs a warm reboot, which I believe
>> would be a quite common scenario.
> 
> The point is that if anything was setting the mode to something other
> than normal it was almost certainly a previously running copy of Linux
> and one would expect that if the mode does need to be changed the new
> copy will be doing that anyway.  It's rare enough to need to actively
> manage modes in the first place.
> 

>From what I know based on my experience with Samsung boards we used, the
opmodes of regulators are preconfigured by board bootloader to certain
values based on power design of the board (i.e. there is no need to keep
a regulator in full power mode, if on given board only a little fraction
of it is needed).

Now Linux should not change this mode (excluding cases when the values
in the bootloader are wrong - they happen unfortunately), so I'm not
getting why you say that it is Linux which changes the mode to something
other than normal. Linux should only toggle between the value resulting
from power design and off.

Best regards,
Tomasz
