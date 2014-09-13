Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaIMTXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 15:23:11 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:49097 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbaIMTXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 15:23:09 -0400
Date: Sat, 13 Sep 2014 21:16:12 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Joe Perches <joe@perches.com>
Cc: linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alexander Clouter <alex@digriz.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] arm: mach-orion5x: Convert pr_warning to pr_warn
Message-ID: <20140913191612.GB24502@lunn.ch>
References: <cover.1410632834.git.joe@perches.com>
 <b438c7c54306f095a150e50df41fbba4d515c2f8.1410632835.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b438c7c54306f095a150e50df41fbba4d515c2f8.1410632835.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 11:31:17AM -0700, Joe Perches wrote:
> Use the more common pr_warn.
> 
> Other miscellanea:
> 
> o Realign arguments
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Andrew Lunn <andrew@lunn.ch>

	  Andrew

> ---
>  arch/arm/mach-orion5x/dns323-setup.c           | 8 ++++----
>  arch/arm/mach-orion5x/terastation_pro2-setup.c | 2 +-
>  arch/arm/mach-orion5x/ts209-setup.c            | 2 +-
>  arch/arm/mach-orion5x/ts409-setup.c            | 2 +-
>  arch/arm/mach-orion5x/ts78xx-setup.c           | 4 ++--
>  5 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/mach-orion5x/dns323-setup.c b/arch/arm/mach-orion5x/dns323-setup.c
> index 56edeab..09d2a26 100644
> --- a/arch/arm/mach-orion5x/dns323-setup.c
> +++ b/arch/arm/mach-orion5x/dns323-setup.c
> @@ -550,7 +550,7 @@ static int __init dns323_identify_rev(void)
>  			break;
>  	}
>  	if (i >= 1000) {
> -		pr_warning("DNS-323: Timeout accessing PHY, assuming rev B1\n");
> +		pr_warn("DNS-323: Timeout accessing PHY, assuming rev B1\n");
>  		return DNS323_REV_B1;
>  	}
>  	writel((3 << 21)	/* phy ID reg */ |
> @@ -562,7 +562,7 @@ static int __init dns323_identify_rev(void)
>  			break;
>  	}
>  	if (i >= 1000) {
> -		pr_warning("DNS-323: Timeout reading PHY, assuming rev B1\n");
> +		pr_warn("DNS-323: Timeout reading PHY, assuming rev B1\n");
>  		return DNS323_REV_B1;
>  	}
>  	pr_debug("DNS-323: Ethernet PHY ID 0x%x\n", reg & 0xffff);
> @@ -577,8 +577,8 @@ static int __init dns323_identify_rev(void)
>  	case 0x0e10: /* MV88E1118 */
>  		return DNS323_REV_C1;
>  	default:
> -		pr_warning("DNS-323: Unknown PHY ID 0x%04x, assuming rev B1\n",
> -			   reg & 0xffff);
> +		pr_warn("DNS-323: Unknown PHY ID 0x%04x, assuming rev B1\n",
> +			reg & 0xffff);
>  	}
>  	return DNS323_REV_B1;
>  }
> diff --git a/arch/arm/mach-orion5x/terastation_pro2-setup.c b/arch/arm/mach-orion5x/terastation_pro2-setup.c
> index 6208d12..1208674 100644
> --- a/arch/arm/mach-orion5x/terastation_pro2-setup.c
> +++ b/arch/arm/mach-orion5x/terastation_pro2-setup.c
> @@ -349,7 +349,7 @@ static void __init tsp2_init(void)
>  			gpio_free(TSP2_RTC_GPIO);
>  	}
>  	if (tsp2_i2c_rtc.irq == 0)
> -		pr_warning("tsp2_init: failed to get RTC IRQ\n");
> +		pr_warn("tsp2_init: failed to get RTC IRQ\n");
>  	i2c_register_board_info(0, &tsp2_i2c_rtc, 1);
>  
>  	/* register Terastation Pro II specific power-off method */
> diff --git a/arch/arm/mach-orion5x/ts209-setup.c b/arch/arm/mach-orion5x/ts209-setup.c
> index 9136797..c725b7c 100644
> --- a/arch/arm/mach-orion5x/ts209-setup.c
> +++ b/arch/arm/mach-orion5x/ts209-setup.c
> @@ -314,7 +314,7 @@ static void __init qnap_ts209_init(void)
>  			gpio_free(TS209_RTC_GPIO);
>  	}
>  	if (qnap_ts209_i2c_rtc.irq == 0)
> -		pr_warning("qnap_ts209_init: failed to get RTC IRQ\n");
> +		pr_warn("qnap_ts209_init: failed to get RTC IRQ\n");
>  	i2c_register_board_info(0, &qnap_ts209_i2c_rtc, 1);
>  
>  	/* register tsx09 specific power-off method */
> diff --git a/arch/arm/mach-orion5x/ts409-setup.c b/arch/arm/mach-orion5x/ts409-setup.c
> index 5c079d31..cf2ab53 100644
> --- a/arch/arm/mach-orion5x/ts409-setup.c
> +++ b/arch/arm/mach-orion5x/ts409-setup.c
> @@ -302,7 +302,7 @@ static void __init qnap_ts409_init(void)
>  			gpio_free(TS409_RTC_GPIO);
>  	}
>  	if (qnap_ts409_i2c_rtc.irq == 0)
> -		pr_warning("qnap_ts409_init: failed to get RTC IRQ\n");
> +		pr_warn("qnap_ts409_init: failed to get RTC IRQ\n");
>  	i2c_register_board_info(0, &qnap_ts409_i2c_rtc, 1);
>  	platform_device_register(&ts409_leds);
>  
> diff --git a/arch/arm/mach-orion5x/ts78xx-setup.c b/arch/arm/mach-orion5x/ts78xx-setup.c
> index db16dae..1b704d3 100644
> --- a/arch/arm/mach-orion5x/ts78xx-setup.c
> +++ b/arch/arm/mach-orion5x/ts78xx-setup.c
> @@ -403,8 +403,8 @@ static void ts78xx_fpga_supports(void)
>  		/* enable devices if magic matches */
>  		switch ((ts78xx_fpga.id >> 8) & 0xffffff) {
>  		case TS7800_FPGA_MAGIC:
> -			pr_warning("unrecognised FPGA revision 0x%.2x\n",
> -					ts78xx_fpga.id & 0xff);
> +			pr_warn("unrecognised FPGA revision 0x%.2x\n",
> +				ts78xx_fpga.id & 0xff);
>  			ts78xx_fpga.supports.ts_rtc.present = 1;
>  			ts78xx_fpga.supports.ts_nand.present = 1;
>  			ts78xx_fpga.supports.ts_rng.present = 1;
> -- 
> 1.8.1.2.459.gbcd45b4.dirty
> 
