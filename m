Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab3APBsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:48:18 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:65142 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab3APBsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:48:16 -0500
Date: Tue, 15 Jan 2013 17:44:43 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Marcus Cooper <marcus.xm.cooper@stericsson.com>
Subject: Re: [PATCH 06/18] power: ab8500_bm: Recharge condition not optimal
 for battery
Message-ID: <20130116014442.GA17659@lizard.fhda.edu>
References: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
 <1357909986-9262-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1357909986-9262-7-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 01:12:54PM +0000, Lee Jones wrote:
> From: Marcus Cooper <marcus.xm.cooper@stericsson.com>
> 
> Today the battery recharge is determined with a voltage threshold. This
> voltage threshold is only valid when the battery is relaxed. In charging
> algorithm the voltage read is the loaded battery voltage and no
> compensation is done to get the relaxed voltage. When maintenance
> charging is not selected, this makes the recharging condition to almost
> immediately activate when there is a discharge present on the battery.
> 
> Depending on which vendor the battery comes from this behavior can wear
> out the battery much faster than normal.
> 
> The fuelgauge driver is responsible to monitor the actual battery
> capacity and is able to estimate the remaining capacity. It is better to
> use the remaining capacity as a limit to determine when battery should
> be recharged.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
> Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
> Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
> ---
> +	.maint_thres = 95,
>  	.user_cap_limit = 15,
>  	.maint_thres = 97,
>  };

95 or 97? These are both specified. I removed 97, assuming it was a merge
error on your side. But please double check, it could be that you really
want 97 here.
