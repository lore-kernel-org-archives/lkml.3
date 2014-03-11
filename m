Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbaCKV0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 17:26:10 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:32879 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbaCKV0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 17:26:08 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:c017:3fe5:a5f1:ca5e]
In-Reply-To: <ae4583176ee5c9d8a8a2d53c000b86711eb66287.1389018985.git.michal.simek@xilinx.com>
References: <cover.1389018985.git.michal.simek@xilinx.com>
	<ae4583176ee5c9d8a8a2d53c000b86711eb66287.1389018985.git.michal.simek@xilinx.com>
Date: Tue, 11 Mar 2014 14:26:07 -0700
Message-ID: <CAOesGMjzNWXs26T2ZxGi=ASk2ETk0P5re-QdfwGT6O8M=5tDkA@mail.gmail.com>
Subject: Re: [PATCH 3/7] ARM: zynq: Hang iomapped slcr address on device_node
From: Olof Johansson <olof@lixom.net>
To: Michal Simek <michal.simek@xilinx.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Michal Simek <monstr@monstr.eu>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 6, 2014 at 6:36 AM, Michal Simek <michal.simek@xilinx.com> wrote:
> From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
>
> For later usage by zynq clk driver.
>
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>  arch/arm/mach-zynq/slcr.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
> index 9746de7..2891dcf 100644
> --- a/arch/arm/mach-zynq/slcr.c
> +++ b/arch/arm/mach-zynq/slcr.c
> @@ -121,6 +121,8 @@ int __init zynq_early_slcr_init(void)
>                 BUG();
>         }
>
> +       np->data = (__force void *)zynq_slcr_base;


This is quite unusual, we normally remap again if needed. Is there a
reason you can't just have the driver request the resource and map it
like most other ones do?


-Olof
