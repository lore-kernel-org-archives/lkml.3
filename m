Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab3DAGWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:22:04 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50267 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3DAGWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:22:02 -0400
Date: Sun, 31 Mar 2013 23:18:04 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] power_supply: tps65090: Setup compatible property
 for dt
Message-ID: <20130401061803.GB30190@lizard>
References: <1363897985-19980-1-git-send-email-rklein@nvidia.com>
 <1363897985-19980-2-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1363897985-19980-2-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 04:33:05PM -0400, Rhyland Klein wrote:
> Setup the compatible property so that when this device is registered
> through device tree, it can match the expected compatiblity string
> used in the tps65090 driver.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
>  drivers/power/tps65090-charger.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/tps65090-charger.c b/drivers/power/tps65090-charger.c
> index 0c66c66..3b3dafd 100644
> --- a/drivers/power/tps65090-charger.c
> +++ b/drivers/power/tps65090-charger.c
> @@ -204,7 +204,7 @@ static int tps65090_charger_probe(struct platform_device *pdev)
>  
>  	pdata = dev_get_platdata(pdev->dev.parent);
>  
> -	if (!pdata && tps65090_mfd->dev->of_node)
> +	if (!pdata && pdev->dev.of_node)

  CC      drivers/power/tps65090-charger.o
drivers/power/tps65090-charger.c: In function ‘tps65090_charger_probe’:
drivers/power/tps65090-charger.c:198:19: warning: unused variable ‘tps65090_mfd’ [-Wunused-variable]

...I fixed this up and applied the patches.

Thanks!

Anton
