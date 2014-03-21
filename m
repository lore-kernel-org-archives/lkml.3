Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760649AbaCUMDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:03:30 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:38132 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbaCUMD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:03:28 -0400
Message-ID: <532C2A9D.2080505@linaro.org>
Date: Fri, 21 Mar 2014 07:03:41 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org
CC: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] clk: bcm281xx: updates for 3.15
References: <1393373752-30875-1-git-send-email-elder@linaro.org>
In-Reply-To: <1393373752-30875-1-git-send-email-elder@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike, I've given up on getting these in for 3.15, but
I want to be sure they're considered ASAP for 3.16.

You indicated you had questions about the prerequisite
clocks I proposed.  What I'd like to do is resend only the
first 7 patches of this series, leaving the patches that
implement prerequisite clock functionality to work out
separately.

In that case there is no special device tree dependency
that would require the patches be taken through arm-soc.

They do, however, still depend on the previous work that
was queued through arm-soc, so they don't apply on your
current clk-next branch.

How would you like me to handle this?

Thanks.

					-Alex

http://git.linaro.org/landing-teams/working/broadcom/kernel.git
Branch review/bcm-clk-next-v2

bc38518 clk: bcm281xx: add clock hysteresis support
84f8738 clk: bcm281xx: add clock policy support
825179f clk: bcm281xx: define CCU clock data statically
1d2fbb7 clk: bcm281xx: initialize CCU structures statically
d362801 clk: bcm281xx: change some symbol names
bcacfe5 clk: bcm281xx: use init_data.name for clock name
270dc8f clk: bcm281xx: warn if ccu_wait_bit() fails

(based on)
c771cfb ARM: dts: bcm281xx: define real clocks
14a091d clk: bcm281xx: don't disable unused peripheral clocks
44bc5c4 clk: bcm281xx: add initial clock framework support
dcb99fd Linux 3.14-rc7



On 02/25/2014 06:15 PM, Alex Elder wrote:
> This series includes updates for the bcm281xx clock code for 3.15.
> I had held off posting this until the code on which this is based
> was queued for 3.14, and it now has been:
>     https://github.com/broadcom/mach-bcm/
>     Branch armsoc/for-3.15/drivers
> 	clk: bcm281xx: don't disable unused peripheral clocks
> 	clk: bcm281xx: add initial clock framework support
> followed by:
>     (same repository)
>     Branch armsoc/for-3.15/dt
> 	ARM: dts: bcm281xx: define real clocks
> 
> The patches in this series are available here:
>     http://git.linaro.org/landing-teams/working/broadcom/kernel.git
>     Branch review/bcm-clk-next-v2
> 
> I've grouped them, and offer a little explanation of each of the
> groups below.
> 
> Note:  The final (DT) patch *must* be committed last.
> 
> The first version of this series had a patch from the middle of the
> series that shouldn't have been there, and it has been removed in
> this version (that patch affected mach-bcm, not clk).  I also split
> the final patch into two, with the second one isolating the change
> to a device tree file.
> 
> 		    					-Alex
> 
> Alex Elder (12):
>   clk: bcm281xx: warn if ccu_wait_bit() fails
>   clk: bcm281xx: use init_data.name for clock name
>   clk: bcm281xx: change some symbol names
>        	Three small code improvements.
> 
>   clk: bcm281xx: initialize CCU structures statically
>   clk: bcm281xx: define CCU clock data statically
> 	Rearrange the way CCUs and the clocks they provide are
> 	defined, so that they're defined statically to the extent
> 	possible rather than allocating and initializing things at
> 	runtime.
> 
>   clk: bcm281xx: add clock policy support
>   clk: bcm281xx: add clock hysteresis support
>   clk: bcm281xx: add an initialized flag
>   clk: bcm281xx: implement prerequisite clocks
>   clk: bcm281xx: add bus clock support
>   clk: bcm281xx: define a bus clock
> 	Add a few new features, ultimately for the purpose of adding
> 	support for another type of Kona clock.  Currently only
> 	peripheral clocks are supported; this adds the ability to
> 	define and control bus clocks.  In addition, support is
> 	added for clocks to identify a prerequisite clock; a clock
> 	won't be initialized until after its prerequisite has been.
> 
>   ARM: dts: add bus clock bsc3_apb for bcm281xx
>   	Add the new bus clock to the device tree.
> 
>  arch/arm/boot/dts/bcm11351.dtsi      |    3 +-
>  drivers/clk/bcm/clk-bcm281xx.c       |  254 ++++++++++++--------------
>  drivers/clk/bcm/clk-kona-setup.c     |  331 +++++++++++++++++++++++++++-------
>  drivers/clk/bcm/clk-kona.c           |  331 ++++++++++++++++++++++++++++++++--
>  drivers/clk/bcm/clk-kona.h           |  189 ++++++++++++++++---
>  include/dt-bindings/clock/bcm281xx.h |    3 +-
>  6 files changed, 872 insertions(+), 239 deletions(-)
> 

