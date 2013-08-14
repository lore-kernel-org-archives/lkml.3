Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375Ab3HNVfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:35:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53107 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933203Ab3HNVfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:35:53 -0400
Message-ID: <520BF835.5080309@wwwdotorg.org>
Date: Wed, 14 Aug 2013 15:35:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Joseph Lo <josephl@nvidia.com>, Jassi Brar <jassisinghbrar@gmail.com>,
        gnurou@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] ARM: add basic Trusted Foundations support
References: <1376360992-1508-1-git-send-email-acourbot@nvidia.com> <1376360992-1508-2-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1376360992-1508-2-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 08:29 PM, Alexandre Courbot wrote:
> Trusted Foundations is a TrustZone-based secure monitor for ARM that
> can be invoked  using a consistent smc-based API on all supported
> platforms. This patch adds initial basic support for Trusted
> Foundations using the ARM firmware API. Current features are limited
> to the ability to boot secondary processors.

> diff --git a/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt

> +Trusted Foundations
> +
> +Boards that use the Trusted Foundations secure monitor can signal its
> +presence by declaring a node compatible with "tl,trusted-foundations"
> +(the name and location of the node does not matter).
> +
> +Required properties:
> +- compatible : "tl,trusted-foundations"

> +- version : Must contain the version number string of the Trusted Foundation
> +	firmware.

Can the version be queried at run-time from the firmware itself?

If not, I wonder if we shouldn't instead encode the version number into
the compatible value.

Some comments on the exact format of the version property would be
useful; from the example I assume it's "%02d.%02d" % (major_ver, minor_ver)?

> diff --git a/arch/arm/firmware/Kconfig b/arch/arm/firmware/Kconfig

> +config ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
> +	bool

Shouldn't that be "config ARCH_SUPPORTS_FIRMWARE", since presumably in
the future there will be more entries in the menu, and hence we want the
menu to appear if any of those entries are useful?

> +
> +menu "Firmware options"
> +	depends on ARCH_SUPPORTS_TRUSTED_FOUNDATIONS

Or perhaps that comment is more appropriate for that "depends".

