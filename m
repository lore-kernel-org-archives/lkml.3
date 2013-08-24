Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab3HXVpL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 17:45:11 -0400
Received: from 2.mo2.mail-out.ovh.net ([188.165.53.149]:43640 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755754Ab3HXVpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 17:45:09 -0400
Message-ID: <521928F2.4060605@overkiz.com>
Date: Sat, 24 Aug 2013 23:43:14 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [RFC PATCH 0/3] pinctrl: at91: add support for generic pinconf
References: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 2977723780502091897
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -85
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/08/2013 23:32, Boris BREZILLON wrote:
> Hello,
>
> This patch series is an attempt to add support for generic pin config
> syntax to at91 pinctrl driver.
>
> My primary goal is to add support for output configuration from dt definition.
> This is needed to fully move at91rm9200ek board to dt (other boards may have
> the same needs).
> This board use a pin to drive an external switch which select between 2
> functionnalities:
>   - mmc interface
>   - spi interface
> The pin level is currently configured in the board init (init_machine) function
> based on user config choices (CONFIG_MTD_AT91_DATAFLASH_CARD).
>
> Instead of adding a new flag to the current (native) pin config binding, I
> tried to add support for the generic pin config used by some pinctrl drivers
> (i.e. rockchip).
>
> Is this the right way to do this or should I add a new at91 native flags for
> output config (OUTPUT_HIGH/LOW) ?
>
> The second patch introduce a new config parameter to add a glitch filter on a
> specific pin.
The first patch, not the second.
> Glitch filter is similar to bounce filter (or debounce) but with a smaller
> delay (expressed in nsecs ?).
>
> I'm not sure this is the right approach.
> Maybe we should reuse the debounce parameter and add a flag to specify the delay
> unit (usec or nsec).
>
> What do you think ?
>
> The third patch migrate sama5 dt boards to the new generic config syntax.
>
> Please feel free to share your thoughts.
>
> Best Regards,
>
> Boris
>
>
> Boris BREZILLON (3):
>    pinctrl: add new generic pinconf config for deglitch filter
>    pinctrl: at91: add support for generic pinconf
>    ARM: at91/dt: move sama5 to generic pinconf
>
>   .../bindings/pinctrl/atmel,at91-pinctrl.txt        |   43 ++-
>   .../bindings/pinctrl/pinctrl-bindings.txt          |    1 +
>   arch/arm/boot/dts/sama5d3.dtsi                     |  363 ++++++++++----------
>   arch/arm/boot/dts/sama5d3xdm.dtsi                  |    2 +-
>   arch/arm/boot/dts/sama5d3xmb.dtsi                  |   12 +-
>   drivers/pinctrl/Kconfig                            |    2 +-
>   drivers/pinctrl/pinconf-generic.c                  |    2 +
>   drivers/pinctrl/pinctrl-at91.c                     |  265 +++++++++++++-
>   include/linux/pinctrl/pinconf-generic.h            |    5 +
>   9 files changed, 494 insertions(+), 201 deletions(-)
>

