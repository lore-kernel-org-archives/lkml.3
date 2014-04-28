Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016AbaD1Ta3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:30:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50717 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaD1TaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:30:17 -0400
Message-ID: <535E9163.3070305@wwwdotorg.org>
Date: Mon, 28 Apr 2014 11:35:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, linux-pm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mark Brown <broonie@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH v3 1/3] base: power: Add generic OF-based power domain
 look-up
References: <1398271618-28932-1-git-send-email-t.figa@samsung.com> <1398271618-28932-2-git-send-email-t.figa@samsung.com>
In-Reply-To: <1398271618-28932-2-git-send-email-t.figa@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 10:46 AM, Tomasz Figa wrote:
> This patch introduces generic code to perform power domain look-up using
> device tree and automatically bind devices to their power domains.
> Generic device tree binding is introduced to specify power domains of
> devices in their device tree nodes.
> 
> Backwards compatibility with legacy Samsung-specific power domain
> bindings is provided, but for now the new code is not compiled when
> CONFIG_ARCH_EXYNOS is selected to avoid collision with legacy code. This
> will change as soon as Exynos power domain code gets converted to use
> the generic framework in further patch.

> diff --git a/Documentation/devicetree/bindings/power/power_domain.txt b/Documentation/devicetree/bindings/power/power_domain.txt

> +==Power domain consumers==
> +
> +Required properties:
> + - power-domain : A phandle and power domain specifier as defined by bindings
> +                  of power controller specified by phandle.

It seems quite likely that a single logical device could have components
in multiple power domains. Consider an HDMI controller with different
power domains for the HDMI core, CEC communication, DDC/I2C
communication, and the I/O pads, with no clear separation between those
two components of the module (no separate register spaces, but the
bits/registers are interleaved all together).

As such, I think that rather than a "power-domain" property, we need a
pair of "power-domains", and "power-domain-names" properties, and
preferably with mandatory usage of name-based lookups, rather than
allowing a random mix of name-based and index-based lookups like we have
with some existing resource bindings.
