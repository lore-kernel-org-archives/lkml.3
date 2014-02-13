Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaBMTPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:15:17 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:33216 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaBMTPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:15:14 -0500
MIME-Version: 1.0
In-Reply-To: <1392137610-27842-2-git-send-email-pawel.moll@arm.com>
References: <1392137610-27842-1-git-send-email-pawel.moll@arm.com>
	<1392137610-27842-2-git-send-email-pawel.moll@arm.com>
Date: Thu, 13 Feb 2014 13:15:13 -0600
Message-ID: <CAL_JsqJQy7ob87=wPOLxn3X0fTrt2QhAEJ2nPTAmCMZqNZp+sw@mail.gmail.com>
Subject: Re: [PATCH 1/3] driver core & of: Mark of_nodes of added device as populated
From: Rob Herring <robherring2@gmail.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        lm-sensors@lm-sensors.org, "arm@kernel.org" <arm@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 10:53 AM, Pawel Moll <pawel.moll@arm.com> wrote:
> In "Device Tree powered" systems, platform devices are usually
> massively populated with of_platform_populate() call, executed
> at some level of initcalls, either by generic architecture
> or by platform-specific code.
>
> There are situations though where certain devices must be
> created (and bound with drivers) before all the others.
> This presents small challenge in DT-driven systems, as
> devices explicitly created in early code would be created
> again by of_platform_populate().
>
> This patch tries to solve that issue in a generic way,
> adding a "populated" flag which is set in the device_node
> structure when a device is being created in the core.
> Later, of_platform_populate() skips such nodes (and
> its children) in a similar way to the non-available ones.
>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>  drivers/base/core.c       |  4 ++++
>  drivers/of/device.c       | 16 ++++++++++++++++
>  drivers/of/platform.c     |  6 ++++--
>  include/linux/of.h        |  6 ++++++
>  include/linux/of_device.h | 11 +++++++++++
>  5 files changed, 41 insertions(+), 2 deletions(-)

Go read Grant's and my comments from your last posting.

Rob
