Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaKHHYl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 02:24:41 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:20356 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbaKHHYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 02:24:39 -0500
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat6hNPvz+mM
X-RZG-CLASS-ID: mo00
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [Gta04-owner] [PATCH] mfd: twl4030-power: Support compatible = "ti, twl4030-power" again.
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20141108112227.256f93ce@notabene.brown>
Date: Sat, 8 Nov 2014 08:24:28 +0100
Cc: Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        List for communicating with real GTA04 owners 
	<gta04-owner@goldelico.com>
Content-Transfer-Encoding: 7bit
Message-Id: <ABCF9D6C-DD71-4DE3-BF1E-3C41DC8086FF@goldelico.com>
References: <20141108112227.256f93ce@notabene.brown>
To: NeilBrown <neilb@suse.de>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 08.11.2014 um 01:22 schrieb NeilBrown <neilb@suse.de>:

> 
> commit e7cd1d1eb16fcdf53001b926187a82f1f3e1a7e6
>    mfd: twl4030-power: Add generic reset configuration
> 
> claims:
>    Let's add device tree support and configure things for warm reset
>    as the default when compatible = "ti,twl4030-power".
> and
>    Documentation/devicetree/bindings/mfd/twl4030-power.txt
> claims that "ti,twl4030-power" is still a valid "compatible" setting.
> 
> However the current driver fails to probe with that 'compatible'
> setting.
> Restore the old default.

I think this is a duplicate to 

599a1ca80d1d8269d54fdc4abdec8e65141381fe

(in linux-next)

> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> index 4d3ff3771491..1a7794f6be15 100644
> --- a/drivers/mfd/twl4030-power.c
> +++ b/drivers/mfd/twl4030-power.c
> @@ -776,6 +776,10 @@ static struct twl4030_power_data osc_off_idle = {
> 
> static struct of_device_id twl4030_power_of_match[] = {
> 	{
> +		.compatible = "ti,twl4030-power",
> +		.data = NULL,
> +	},
> +	{
> 		.compatible = "ti,twl4030-power-reset",
> 		.data = &omap3_reset,
> 	},
> _______________________________________________
> Gta04-owner mailing list
> Gta04-owner@goldelico.com
> http://lists.goldelico.com/mailman/listinfo.cgi/gta04-owner

