Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaIAPTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:19:15 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:53551 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaIAPTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:19:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-acpi@lists.linaro.org
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Robert Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Lv Zheng <lv.zheng@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-acpi] [RFC PATCH for Juno 1/2] net: smsc911x add support for probing from ACPI
Date: Mon, 01 Sep 2014 17:17:51 +0200
Message-ID: <2861461.8zNpLC3I2n@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409583961-7466-2-git-send-email-hanjun.guo@linaro.org>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org> <1409583961-7466-2-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:04uxxHfP37yV+GkUsmUHgoFiLnbBpB33x03DvnCGfmf
 5GDOklIRbdjqpsB5eLCzQV0wF1g0kqdVwLV2gK5QZ7AqWFYR1O
 8hju53LTR2X/Nq3JQTX8aHaq9iHvJKWFLqVWuCyU9kTrXpZdW5
 QxLvpoIQ1crDIAT3hD4rfgBBww7pKHHsaCb1Tya0DY8lu0p0wO
 4gblDKaUoFtOVAeIyTdhn9iPWFbTteCxCtYUmrK0fP9rua66/W
 QD36u3SwF0Na4F40jFsST6J9mWEk/EhOcyfUL75CgwjcoS4As6
 cniTmCkpg/Zb7L0aF4rc5MYNftLEwr6NKnmErdDKRTzCErV6pt
 Qr0q9gNdnpWXKVOB1y64=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2014 23:06:00 Hanjun Guo wrote:
> +#ifdef CONFIG_ACPI
> +/* Configure some sensible defaults for ACPI mode */
> +static int smsc911x_probe_config_acpi(struct smsc911x_platform_config *config,
> +                                   acpi_handle *ahandle)
> +{
> +       if (!ahandle)
> +               return -ENOSYS;
> +
> +       config->phy_interface = PHY_INTERFACE_MODE_MII;
> 

Please remove the #ifdef and use 

	if (!IS_ENABLED(CONFIG_ACPI) || !ahandle)

to check for ACPI support. This should result in the same object code
in all cases, but give better compile-time coverage when ACPI is
disabled.

Also, -ENOSYS is probably the wrong return value. I think you mean
-ENXIO.

	Arnd
