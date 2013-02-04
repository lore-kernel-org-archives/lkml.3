Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3BDMAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:00:47 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33674 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab3BDMAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:00:44 -0500
Message-ID: <510FA2D4.7090807@mvista.com>
Date: Mon, 04 Feb 2013 16:00:20 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: "Kumar, Anil" <anilkumar.v@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com, linux@arm.linux.org.uk,
        b-cousson@ti.com, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca, hs@denx.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: davinci: da850: add wdt OF_DEV_AUXDATA entry
References: <1359016695-10362-1-git-send-email-anilkumar.v@ti.com> <1359016695-10362-3-git-send-email-anilkumar.v@ti.com> <510FA09F.7030604@ti.com>
In-Reply-To: <510FA09F.7030604@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04-02-2013 15:50, Sekhar Nori wrote:

> Auxdata is not evm specific. This can instead be called da850_auxdata_lookup[].

> Also, I dont think it is necessary to add auxdata in a separate patch
> from dt nodes. So, I fixed these issues and came up with below patch. I
> tested basic wdt reboot. reboot command is still broken (with or
> without this patch). Can you please look at that?

> Thanks,
> Sekhar

> ----8<----
> From: "Kumar, Anil" <anilkumar.v@ti.com>
> Date: Thu, 24 Jan 2013 14:08:14 +0530
> Subject: [PATCH 1/1] ARM: davinci: da850: add wdt DT node

> Add da850 wdt DT node.

> Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
[...]

> diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
> index 8dd15c0..2800090 100644
> --- a/arch/arm/boot/dts/da850.dtsi
> +++ b/arch/arm/boot/dts/da850.dtsi
> @@ -88,6 +88,11 @@
>   				      19>;
>   			status = "disabled";
>   		};
> +		wdt: wdt@1c21000 {
> +			compatible = "ti,davinci-wdt";
> +			reg = <0x21000 0xfff>;

    Not 0x1000? This is region size, not upper limit.

WBR, Sergei

