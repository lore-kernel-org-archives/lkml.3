Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaGBExh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 00:53:37 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:65429 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaGBExe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 00:53:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, grant.likely@linaro.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1403848871-26519-1-git-send-email-peter.ujfalusi@ti.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, ldewangan@nvidia.com,
        linux-doc@vger.kernel.org, nm@ti.com, robh+dt@kernel.org
References: <1403848871-26519-1-git-send-email-peter.ujfalusi@ti.com>
Message-ID: <20140702045320.23338.25@quantum>
User-Agent: alot/0.3.5
Subject: Re: [RESEND 0/2] clk: Support for Palmas clk32kg and clk32kgaudio clocks
Date: Tue, 01 Jul 2014 21:53:20 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter Ujfalusi (2014-06-26 23:01:09)
> Hi Mike,
> 
> This is a resend of the v2 version of the palmas clock driver which seamingly
> missed the 3.16 merge window. I have added Nishanth's Reviewed-by tag to the
> patches.

Thanks for the resend. Applied to clk-next.

Regards,
Mike

> 
> Changes since v1:
> - binding documentation and driver has been separated based on Nishanth Menon's
>   comment
> 
> v2 of the series:
> https://lkml.org/lkml/2014/5/6/323
> 
> v1 of the driver can be found:
> https://lkml.org/lkml/2014/4/3/104
> 
> Palmas class of devices can provide 32K clock(s) to be used by other devices
> on the board. Depending on the actual device the provided clocks can be:
> CLK32K_KG and CLK32K_KGAUDIO
> or only one:
> CLK32K_KG (TPS659039 for example)
> 
> Use separate compatible flags for the two 32K clock.
> A system which needs or have only one of the 32k clock from
> Palmas will need to add node(s) for each clock as separate section
> in the dts file.
> The two compatible property is:
> "ti,palmas-clk32kg" for clk32kg clock
> "ti,palmas-clk32kgaudio" for clk32kgaudio clock
> 
> Apart from the register control of the clocks - which is done via
> the clock API there is a posibility to enable the external sleep
> control. In this way the clock can be enabled/disabled on demand by the
> user of the clock.
> 
> Regards,
> Peter
> ---
> Peter Ujfalusi (2):
>   dt/bindings: Binding documentation for Palmas clk32kg and clk32kgaudio
>     clocks
>   clk: Add driver for Palmas clk32kg and clk32kgaudio clocks
> 
>  .../bindings/clock/clk-palmas-clk32kg-clocks.txt   |  35 +++
>  drivers/clk/Kconfig                                |   7 +
>  drivers/clk/Makefile                               |   1 +
>  drivers/clk/clk-palmas.c                           | 307 +++++++++++++++++++++
>  include/dt-bindings/mfd/palmas.h                   |  18 ++
>  5 files changed, 368 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/clk-palmas-clk32kg-clocks.txt
>  create mode 100644 drivers/clk/clk-palmas.c
>  create mode 100644 include/dt-bindings/mfd/palmas.h
> 
> -- 
> 2.0.0
> 
