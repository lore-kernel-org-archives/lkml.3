Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaBXAjK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 19:39:10 -0500
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:58817 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbaBXAjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 19:39:07 -0500
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <530A931B.3020606@iki.fi>
Date: Mon, 24 Feb 2014 02:32:27 +0200
From: Anssi Hannula <anssi.hannula@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michal_Mal=FD?= <madcatxster@prifuk.cz>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, elias.vds@gmail.com, jkosina@suse.cz,
        simon@mungewell.org
Subject: Re: [PATCH v2 0/4] Add ff-memless-next and make hid-lg4ff use it
References: <1516865.M993BQAYe4@geidi-prime>
In-Reply-To: <1516865.M993BQAYe4@geidi-prime>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

24.02.2014 01:24, Michal Malý kirjoitti:
> Hi everybody,

Hi,

> this patch series is a result of my work to improve FFB support for memoryless
> devices. ff-memless-next is an improvement over the currently available
> ff-memless which is well suited for joypads but cannot handle more advanced
> devices such as racing wheels properly. As I have explained in one of RFCs
> regarding ff-memless-next, the extent of the changes makes implementing
> ff-memless-next as a patch to ff-memless unfeasible. As of now there is a total
> of 27 drivers using ff-memless (including lg4ff) - a lot of them joypads.
> I do not have access to any FFB joypad at the moment so I cannot
> implement the functionality required to handle joypads properly - namely FF_RUMBLE
> and emulation of FF_PERIODIC through FF_RUMBLE.
> The plan is to implement the missing functionality and replace ff-memless completely
> in the future. 

I think we should extend the current ff-memless instead of duplicating
its functionality (even on a "for now" basis).

Having looked at ff-memless-next briefly, it seems very similar to
ff-memless on its basic working principle, and therefore I don't really
see why extending ff-memless would be too cumbersome. Unless I'm missing
something - in that case, feel free to point it out to me :)

Duplicating the module makes reviewing it somewhat difficult since the
changes are not clearly visible.

As for the amount of drivers using ff-memless, those are ~all very
simple (single function call registering a single callback) so it should
be easy to apply any API conversion if needed.
And I don't see a real need for you to have access to a rumble joypad -
that support is already implemented in ff-memless, and other people can
test that it isn't broken by your changes.

Regardless, thanks for looking into this.

> 
> Second part of this series ports lg4ff driver over to ff-memless-next.
> The immediate benefit of this is support of all periodic effects and ramp effect.
> 
> v2 addresses a few issues that have not been noticed at the time v1 was
> submitted. Specific fixes are mentioned in the respective patches.
> 
> Michal M.
> 
>  Michal Malý (4):
>   INPUT: Add ff-memless-next module
>   HID: Port hid-lg4ff to ff-memless-next
>   HID: Add support for periodic effects in hid-lg4ff
>   HID: Add support for ramp effect in hid-lg4ff
> 
>  Documentation/input/ff-memless-next.txt | 141 ++++++
>  drivers/hid/Kconfig                     |   2 +-
>  drivers/hid/hid-lg4ff.c                 |  93 ++--
>  drivers/input/Kconfig                   |  11 +
>  drivers/input/Makefile                  |   1 +
>  drivers/input/ff-memless-next.c         | 789 ++++++++++++++++++++++++++++++++
>  include/linux/input/ff-memless-next.h   |  32 ++
>  7 files changed, 1033 insertions(+), 36 deletions(-)
> --
>  1.9.0
> 
> --
> 


-- 
Anssi Hannula
