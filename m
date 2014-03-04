Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbaCDTRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:17:46 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:38855 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbaCDTRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:17:43 -0500
MIME-Version: 1.0
In-Reply-To: <1393862536-9842-3-git-send-email-tomasz.figa@gmail.com>
References: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
	<1393862536-9842-3-git-send-email-tomasz.figa@gmail.com>
Date: Tue, 4 Mar 2014 20:17:41 +0100
Message-ID: <CA+gwMceHSD6-dqsehDuwhVLwdNxdaRVteA=EA9UvhYMjB+xKWQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] drivercore: Bind/unbind power domain on probe/remove
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-pm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Len Brown <len.brown@intel.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Tomasz Figa <t.figa@samsung.com>, Pavel Machek <pavel@ucw.cz>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Mon, Mar 3, 2014 at 5:02 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On a number of platforms, devices are part of controllable power
> domains, which need to be enabled before such devices can be accessed
> and may be powered down when the device is idle to save some power.
> This means that on systems that support power domain control using
> generic power domains subsystem, it is necessary to add device to its
> power domain before binding a driver to it and remove it from its power
> domain after its driver is unbound to make sure that an unused device
> does not affect power domain state.
>
> Since this is not limited to particular busses and specific
> archs/platforms, it is more convenient to do the above directly in
> driver core, just as done with pinctrl default configuration. This patch
> adds necessary code to really_probe() and __device_release_driver() to
> achieve this and maintain consistent stack-like ordering of operations
> happening when binding and unbinding a driver.
>
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>

patches 01 and 02
Reviewed-by: Philipp Zabel <philipp.zabel@gmail.com>
Tested-by: Philipp Zabel <philipp.zabel@gmail.com>
on i.MX6 GK802.

regards
Philipp
