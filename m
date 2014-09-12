Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaILQZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:25:11 -0400
Received: from mail.kernel.org ([198.145.19.201]:55192 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaILQZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:25:07 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Doug Anderson <dianders@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Heiko Stuebner <heiko@sntech.de>, Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nishanth Menon <nm@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        olof@lixom.net, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>, Addy Ke <addy.ke@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, sre@kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, dwmw2@infradead.org,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v3] PM / AVS: rockchip-io: add driver handling Rockchip io domains
References: <1410475735-10278-1-git-send-email-dianders@chromium.org>
Date: Fri, 12 Sep 2014 09:25:04 -0700
In-Reply-To: <1410475735-10278-1-git-send-email-dianders@chromium.org> (Doug
	Anderson's message of "Thu, 11 Sep 2014 15:48:55 -0700")
Message-ID: <7hy4tog61r.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

Doug Anderson <dianders@chromium.org> writes:

> From: Heiko Stübner <heiko@sntech.de>
>
> IO domain voltages on some Rockchip SoCs are variable but need to be
> kept in sync between the regulators and the SoC using a special
> register.
>
> A specific example using rk3288:
> - If the regulator hooked up to a pin like SDMMC0_VDD is 3.3V then
>   bit 7 of GRF_IO_VSEL needs to be 0.  If the regulator hooked up to
>   that same pin is 1.8V then bit 7 of GRF_IO_VSEL needs to be 1.
>
> Said another way, this driver simply handles keeping bits in the SoC's
> general register file (GRF) in sync with the actual value of a voltage
> hooked up to the pins.
>
> Note that this driver specifically doesn't include:
> - any logic for deciding what voltage we should set regulators to
> - any logic for deciding whether regulators (or internal SoC blocks)
>   should have power or not have power
>
> If there were some other software that had the smarts of making
> decisions about regulators, it would work in conjunction with this
> driver.  When that other software adjusted a regulator's voltage then
> this driver would handle telling the SoC about it.  A good example is
> vqmmc for SD.  In that case the dw_mmc driver simply is told about a
> regulator.  It changes the regulator between 3.3V and 1.8V at the
> right time.  This driver notices the change and makes sure that the
> SoC is on the same page.
>
> Signed-off-by: Heiko Stübner <heiko@sntech.de>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
> Changes in v3:
> - Changed compatible string as per Santosh.

Thanks, I like the new string better.

> - Added code docs about the slop in 1.8V and 3.3V as per Santosh.
> - Moved some #defines to the top as per Santosh.

All nice changes, thanks Santosh!

Reviewed-by: Kevin Hilman <khilman@linaro.org>

Rafael, how do you want to handle drivers/avs/* ?  Along with Nishanth,
I'm maintaining everything there currently (only one driver :)), and
since I recommended $SUBJECT driver go into drivers/avs[1], I'm happy to
queue it for you and update MAINTAINERS to cover drivers/avs/* instead
of just smartreflex.c.

Let me know how you'd like to proceed.

Kevin

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/286276.html

