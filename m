Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935617AbaH0TVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:21:10 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33265 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933812AbaH0TVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:21:08 -0400
Message-ID: <53FE2F9E.80501@gmail.com>
Date: Wed, 27 Aug 2014 21:21:02 +0200
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
References: <1409053061-22568-1-git-send-email-javier.martinez@collabora.co.uk> <53FE2446.3040402@gmail.com> <20140827183733.GN17528@sirena.org.uk> <53FE25EB.7060702@gmail.com> <20140827184705.GO17528@sirena.org.uk> <53FE2901.50508@gmail.com> <20140827191526.GS17528@sirena.org.uk>
In-Reply-To: <20140827191526.GS17528@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.08.2014 21:15, Mark Brown wrote:
> On Wed, Aug 27, 2014 at 08:52:49PM +0200, Tomasz Figa wrote:
>> On 27.08.2014 20:47, Mark Brown wrote:
> 
>>> I'm not convinced that's worth it - chances are that if anything changed
>>> the mode it was a previously running Linux which will most likely be
>>> doing the same things when it starts running anyway.
> 
>> The previously running Linux would have changed the opmode accidentally,
>> due to hardware design of PMIC chip, which doesn't allow powering off a
>> regulator in other way than setting opmode to OFF.
> 
>> If you provide the "active" opmode to that Linux, after a warm reboot it
>> will be able to power on such regulator to correct opmode, without
>> defaulting it incorrectly to NORMAL.
> 
> This is in the scenario where the previously running Linux changed the
> mode to something other than normal and where the freshly booted Linux
> can't figure out how to do that when it needs to.  I'm not sure how
> plausible that scenario is, or that real systems would handle it
> robustly.
> 

I'm not sure I'm getting your point.

If the only thing Linux can do is read back the opmode from PMIC
registers, it doesn't explicitly set it to something other, but rather
reuses what was set by something before it (or, after this patch,
defaults to NORMAL if it's OFF), i.e. the low level firmware or Linux.

However the information about original setting is lost whenever Linux
turns the regulator off and performs a warm reboot, which I believe
would be a quite common scenario.

Best regards,
Tomasz
