Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab3BKR5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:57:00 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:26365 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758612Ab3BKR46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:56:58 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18BBgyHgSYuYp/cFtNZl6IJ
Date: Mon, 11 Feb 2013 09:56:53 -0800
From: Tony Lindgren <tony@atomide.com>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ARM: OMAP2+: Export SoC information to userspace
Message-ID: <20130211175653.GQ4801@atomide.com>
References: <1360191049-24017-1-git-send-email-ruslan.bilovol@ti.com>
 <1360191049-24017-3-git-send-email-ruslan.bilovol@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360191049-24017-3-git-send-email-ruslan.bilovol@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ruslan Bilovol <ruslan.bilovol@ti.com> [130206 14:54]:
> --- a/arch/arm/mach-omap2/io.c
> +++ b/arch/arm/mach-omap2/io.c
> @@ -602,6 +602,7 @@ void __init omap4430_init_late(void)
>  	omap2_common_pm_late_init();
>  	omap4_pm_init();
>  	omap2_clk_enable_autoidle_all();
> +	omap_soc_device_init();
>  }
>  #endif

Looks like this should be called for all omaps instead
of just omap4430?

I suggest you create omap_common_init_late() that
calls all the common init_late functions:

static void __init omap_common_init_late(void)
{
	omap_mux_late_init();
	omap2_common_pm_late_init();
	omap_soc_device_init();
}

Needs to be verified that these really are common to
all omap2+ though :)

Regards,

Tony
