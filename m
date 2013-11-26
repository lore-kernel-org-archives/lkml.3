Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab3KZTpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:45:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47624 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab3KZTpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:45:07 -0500
Message-ID: <5294F942.8070401@ti.com>
Date: Tue, 26 Nov 2013 21:40:50 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mark.rutland@arm.com>,
        <wim@iguana.be>, <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <galak@kernel.crashing.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>
Subject: Re: [PATCH v3 0/6] Update Davinci watchdog driver
References: <1385388285-10553-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1385388285-10553-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On 11/25/2013 04:04 PM, Ivan Khoronzhuk wrote:
> These patches are intended to update Davinci watchdog to use WDT core
> and reuse driver for keystone arch, because Keystone uses the similar
> IP like Davinci.
> 
> See Documentation:
> Davinci DM646x - http://www.ti.com/lit/ug/spruer5b/spruer5b.pdf
> Keystone - http://www.ti.com/lit/ug/sprugv5a/sprugv5a.pdf
> 
> Also:
>   - improved to support GET_TIMELEFT option.
>   - added "clocks" and "timeout-sec" properties to DT.
> 
> Based on
> git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
> keystone/master
> 

Could you confirm that regression detected in v2 of series is gone?

Also would it be acceptable if this series will go via WDT tree?
- The first patch patch in series contains changes in both
 Davinci platform & wdt driver.

> v2..v3:
> - watchdog: davinci: change driver to use WDT core
> 	removed "ti,keystone-wdt" compatible from driver
> 	renamed wdt device names for mach-davinci from
> 		"watchdog" to "davinci-wdt"
> 
> - watchdog: davinci: reuse driver for keystone arch
> 	moved "clocks" property under "Optional properties"
> 	improved decsription of "clocks" property
> 
> - arm: dts: keystone: add watchdog entry
> 	replaced "ti,keystone-wdt" compatible on
> 		 "ti,keystone-wdt","ti,davinci-wdt"
> 
> Ivan Khoronzhuk (6):
>    watchdog: davinci: change driver to use WDT core
>    watchdog: davinci: use davinci_wdt_device structure to hold device
>      data
>    watchdog: davinci: add GET_TIMELEFT option support
>    watchdog: davinci: add "timeout-sec" property
>    watchdog: davinci: reuse driver for keystone arch
>    arm: dts: keystone: add watchdog entry
> 
>   .../devicetree/bindings/watchdog/davinci-wdt.txt   |   16 +-
>   arch/arm/boot/dts/keystone.dtsi                    |    6 +
>   arch/arm/mach-davinci/da8xx-dt.c                   |    2 +-
>   arch/arm/mach-davinci/devices-da8xx.c              |    4 +-
>   arch/arm/mach-davinci/devices.c                    |    2 +-
>   drivers/watchdog/Kconfig                           |    6 +-
>   drivers/watchdog/davinci_wdt.c                     |  225 +++++++++-----------
>   7 files changed, 126 insertions(+), 135 deletions(-)
> 

Thanks,
- grygorii
