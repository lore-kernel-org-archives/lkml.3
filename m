Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3BPVnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 16:43:35 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:37727 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab3BPVne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 16:43:34 -0500
Date: Sat, 16 Feb 2013 13:39:40 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] power: rx51_battery: Fix reporting correct values
Message-ID: <20130216213937.GE1741@lizard.sbx05280.losalca.wayport.net>
References: <1360969010-8571-1-git-send-email-pali.rohar@gmail.com>
 <1360969010-8571-2-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1360969010-8571-2-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 11:56:50PM +0100, Pali Rohár wrote:
> Tell twl4030_madc_conversion that this driver needs raw values.
> Driver twl4030_madc has some hardcoded values and conversation
> functions which are incorrect for Nokia RX-51 board. This driver
> rx51_battery expects raw values which convert itself.
> 
> This patch fixing values reported by power supply interface.
> Before this patch driver reported always incorrect values on
> 3.8 kernel (sometimes design capacity was negative).
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

Assuming you want to pass the series via MFD tree,

Acked-by: Anton Vorontsov <anton@enomsg.org>

Thanks!

> ---
>  drivers/power/rx51_battery.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/power/rx51_battery.c b/drivers/power/rx51_battery.c
> index 527d256..d1e17b0 100644
> --- a/drivers/power/rx51_battery.c
> +++ b/drivers/power/rx51_battery.c
> @@ -42,6 +42,7 @@ static int rx51_battery_read_adc(int channel)
>  	req.method = TWL4030_MADC_SW1;
>  	req.func_cb = NULL;
>  	req.type = TWL4030_MADC_WAIT;
> +	req.raw = true;
>  
>  	if (twl4030_madc_conversion(&req) <= 0)
>  		return -ENODATA;
> -- 
> 1.7.10.4
