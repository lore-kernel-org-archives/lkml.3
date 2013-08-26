Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab3HZNdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:33:09 -0400
Received: from 4.mo3.mail-out.ovh.net ([178.33.46.10]:52581 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751669Ab3HZNdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:33:07 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 09:33:07 EDT
Message-ID: <521B5754.2070603@overkiz.com>
Date: Mon, 26 Aug 2013 15:25:40 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Yang Wenyou <Wenyou.Yang@atmel.com>
CC: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH v2 0/4] watchdog: at91sam9_wdt: handle already configured
 wdt
References: <1371799176-3408-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1371799176-3408-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 6306165379517872249
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Yang,

Did you test/review this series ?

If you did, could you add your Acked, Reviewed and/or Tested-by.
I'd really like to get this series merged to mainline.

Thanks.

Best Regards,
Boris

On 21/06/2013 09:19, Boris BREZILLON wrote:
> Hello,
>
> This patch series is a porposal to enhance the sam9 watchdog timer support.
>
> The at91sam9 watchdog timer can only be configured once, and the current
> implementation tries to configure it in a static way:
> - 2 seconds timeout
> - wdt restart every 500ms
>
> If the timer has already been configured with different values, it returns an
> error and do not create any watchdog device.
>
> This is not critical if the watchdog is disabled, but if it has been enabled
> with different timeout values it will lead to a SoC reset.
>
> This patch series tries to address this issue by adapting the heartbeat value
> according the WDT timer config:
> - it first tries to configure the timer as requested.
> - if it fails it fallbacks to the current config, adapting its heartbeat timer
> to the needs
>
> This patch series also move to a dynamically allocated at91wdt device instead
> of the static instance. I'm not sure this is the best solution, so please tell
> me if you prefer to keep static instance of watchdog.
>
> It adds a new at91 wdt type: software. This new type make use of the at91 wdt
> interrupt to trigger a software reboot.
>
> Finally it adds several properties to the device tree bindings.
>
> Best Regards,
> Boris
>
> Change since v1:
>   - fix typo in documentaion
>   - fix irq dt definition for sama5d3 SoC
>
> Boris BREZILLON (4):
>    watchdog: at91sam9_wdt: better watchdog support
>    watchdog: at91sam9_wdt: update device tree doc
>    ARM: at91/dt: add sam9 watchdog default options to SoCs
>    ARM: at91/dt: add watchdog properties to kizbox board
>
>   .../devicetree/bindings/watchdog/atmel-wdt.txt     |   30 +-
>   arch/arm/boot/dts/at91sam9260.dtsi                 |    5 +
>   arch/arm/boot/dts/at91sam9263.dtsi                 |    5 +
>   arch/arm/boot/dts/at91sam9g45.dtsi                 |    5 +
>   arch/arm/boot/dts/at91sam9n12.dtsi                 |    5 +
>   arch/arm/boot/dts/at91sam9x5.dtsi                  |    5 +
>   arch/arm/boot/dts/kizbox.dts                       |    6 +
>   arch/arm/boot/dts/sama5d3.dtsi                     |    5 +
>   drivers/watchdog/at91sam9_wdt.c                    |  319 +++++++++++++++-----
>   9 files changed, 300 insertions(+), 85 deletions(-)
>

