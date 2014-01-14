Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaANAnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:43:04 -0500
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:37851 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752957AbaANAmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:42:47 -0500
MIME-Version: 1.0
In-Reply-To: <201401132043.52491.arnd@arndb.de>
References: <1389135041-16062-1-git-send-email-fkan@apm.com>
	<201401131619.35030.arnd@arndb.de>
	<CAL85gmCTsxng3jCaAcCjePE6Pxu7Jg98TDUqQrDFzsfW2GQwEg@mail.gmail.com>
	<201401132043.52491.arnd@arndb.de>
Date: Mon, 13 Jan 2014 16:42:46 -0800
Message-ID: <CAL85gmCA4kBsRUMC_ENjGfCq5jM11iY5Jx_+A3V9XQDU0b7E0A@mail.gmail.com>
Subject: Re: [PATCH V2 1/6] Documentation: add dts binding for X-Gene reboot
 dts node.
From: Feng Kan <fkan@apm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Is this related to the standard ARM SCU that manages multiprocessor
> systems, or a different unit that uses the same name?

FKAN: You mean the snoop control unit in ARM. This is different from
that, the main function of this unit is clk control.

>
> Since this is a global register range with a variety of things in it,
> the best candidate IMHO would be to use the "syscon" driver. You can
> mark the device node as 'compatible="apm,xgene-scu","syscon"' to let
> it get picked up by the drivers/mfd/syscon driver, which creates
> a "regmap" structure for it.
>
> The reset driver then uses a DT reference with a phandle to the
> SCU node and calls syscon_regmap_lookup_by_phandle() to get the
> regmap. It can get the register number inside the regmap from DT
> as well and use the regmap API to perform the reset.

Thanks, will do.
>
>         Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
