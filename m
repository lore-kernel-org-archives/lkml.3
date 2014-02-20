Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaBTIsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:48:04 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:45749 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaBTIsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:48:03 -0500
Message-ID: <5305C13D.7040907@linaro.org>
Date: Thu, 20 Feb 2014 09:47:57 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
CC: khilman@linaro.org, arnd@arndb.de, linux-sh@vger.kernel.org,
        horms@verge.net.au, john.stultz@linaro.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH V6 0/3] clocksource: Consolidate SH and ARM mach-shmobile
 Kconfig bits
References: <1392670532-21523-1-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1392670532-21523-1-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 09:55 PM, Wolfram Sang wrote:
> This is V6 of the SH and ARM mach-shmobile clocksource Kconfig consolidation
> series. It is a rebased version of V5 (which did not get any comments) on top
> of the latest renesas/devel tag. This series is not just an optimization, it
> also makes it possible to enable the clocksource for the r7s72100 platform.
> Without it, the current kernel is hardly usable for these devices at the moment
> (broken userland). So, it would be nice to have the series in 3.15. For more
> details, I quote the cover-letter from Magnus for V5 at the end. I successfully
> tested the patches on r7s72100 and r8a7791 platforms. The branch can be found
> here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git renesas/rework-clock-configs

Hi Wolfram,

actually I was waiting for Magnus to send me the patchset respinned 
against timers/core [1].

So if you mind, please refresh the series against timers/core as this 
series does not apply for my tree.

Thanks
   -- Daniel

[1] https://lkml.org/lkml/2013/12/18/911

> Changes since V5:
>
>   - rebased on top of renesas-devel-v3.14-rc3-20140217
>
> Signed-off-by: Wolfram Sang <wsa@sang-engineering.com>
>
>
> === original cover letter
>
> By sharing Kconfig entires in drivers/clocksource/Kconfig we
> can get rid of duplicated bits that do not belong under arch/.
>
> With this series applied it is possible to build the timer
> drivers for CMT, MTU2, TMU and STI in case of SH or ARM. The timer
> drivers are automatically selected by default. It is also possible
> to select and/or deselect freely when COMPILE_TEST has been selected.
>
> Many thanks to Olof, John, Daniel and Arnd for feedback!
>
> Changes since V4:
>   - Use SYS_SUPPORTS_SH/EM to avoid name space pollution, thanks Olof!
>   - Remove old SH entries for SYS_SUPPORTS_xxx, use above SH prefix instead
>
> Changes since V3:
>   - Updated patch 1/3 with more detailed help texts
>   - Updated patch 2/3 to fit latest renesas-devel tag, see below
>   - Included acks from John Stultz for patch 2/3 and 3/3
>
> Signed-off-by: Magnus Damm <damm@opensource.se>


> ---
>
> Magnus Damm (3):
>    clocksource: Add Kconfig entries for CMT, MTU2, TMU and STI
>    ARM: shmobile: Remove CMT, TMU and STI Kconfig entries
>    sh: Remove Kconfig entries for TMU, CMT and MTU2
>
>   arch/arm/mach-shmobile/Kconfig | 35 ++++++++++---------
>   arch/sh/Kconfig                | 76 +++++++++++++-----------------------------
>   drivers/clocksource/Kconfig    | 44 ++++++++++++++++++++++++
>   3 files changed, 84 insertions(+), 71 deletions(-)
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

