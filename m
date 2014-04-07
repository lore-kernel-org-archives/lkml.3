Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaDGIMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 04:12:36 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:62045 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbaDGIMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 04:12:33 -0400
Message-ID: <1396858351.8506.8.camel@x220>
Subject: Re: [PATCH v6 01/36] mtd: st_spi_fsm: Allocate resources and
 register with MTD framework
From: Paul Bolle <pebolle@tiscali.nl>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, Angus.Clark@st.com
Date: Mon, 07 Apr 2014 10:12:31 +0200
In-Reply-To: <1395307268-12721-2-git-send-email-lee.jones@linaro.org>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
	 <1395307268-12721-2-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Apr 2014 08:12:32.0322 (UTC) FILETIME=[20293A20:01CF5239]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 09:20 +0000, Lee Jones wrote:
> This is a new driver. It's used to communicate with a special type of
> optimised Serial Flash Controller called the FSM. The FSM uses a subset
> of the SPI protocol to communicate with supported NOR-Flash devices.
> 
> Acked-by Angus Clark <angus.clark@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This patch seems to be commit d90db4a07429 ("mtd: st_spi_fsm: Allocate
resources and register with MTD framework") in current linux-next. 

> ---
>  drivers/mtd/devices/Kconfig      |   8 +++
>  drivers/mtd/devices/Makefile     |   1 +
>  drivers/mtd/devices/st_spi_fsm.c | 106 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 115 insertions(+)
>  create mode 100644 drivers/mtd/devices/st_spi_fsm.c
> 
> diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
> index 0128138..1210bc2 100644
> --- a/drivers/mtd/devices/Kconfig
> +++ b/drivers/mtd/devices/Kconfig
> @@ -210,6 +210,14 @@ config MTD_DOCG3
>  	  M-Systems and now Sandisk. The support is very experimental,
>  	  and doesn't give access to any write operations.
>  
> +config MTD_ST_SPI_FSM
> +	tristate "ST Microelectronics SPI FSM Serial Flash Controller"
> +	depends on ARM || SH

That should probably be
          depends on ARM || SUPERH

> +	help
> +	  This provides an MTD device driver for the ST Microelectronics
> +	  SPI Fast Sequence Mode (FSM) Serial Flash Controller and support
> +	  for a subset of connected Serial Flash devices.
> +
>  if MTD_DOCG3
>  config BCH_CONST_M
>  	default 14

Can this still be fixed in a future version of this series or should I
send a trivial patch?


Paul Bolle

