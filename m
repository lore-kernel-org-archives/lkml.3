Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab3DWQqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:46:23 -0400
Received: from void.printf.net ([89.145.121.20]:45347 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197Ab3DWQqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:46:22 -0400
From: Chris Ball <cjb@laptop.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 12/21] mmc: sdhci-tegra: fix MODULE_DEVICE_TABLE
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
	<1366734653-488286-13-git-send-email-arnd@arndb.de>
Date: Tue, 23 Apr 2013 12:46:15 -0400
In-Reply-To: <1366734653-488286-13-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Tue, 23 Apr 2013 18:30:44 +0200")
Message-ID: <87bo95tctk.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, Apr 23 2013, Arnd Bergmann wrote:
> The symbol referenced in MODULE_DEVICE_TABLE must match the actual
> table, otherwise we get a build error like
>
> sdhci-tegra.c:206:34: error: '__mod_of_device_table' aliased to undefined symbol 'sdhci_dt_ids'
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Chris Ball <cjb@laptop.org>
> ---
>  drivers/mmc/host/sdhci-tegra.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
> index 08b06e9..85052bf 100644
> --- a/drivers/mmc/host/sdhci-tegra.c
> +++ b/drivers/mmc/host/sdhci-tegra.c
> @@ -214,7 +214,7 @@ static const struct of_device_id sdhci_tegra_dt_match[] = {
>  #endif
>  	{}
>  };
> -MODULE_DEVICE_TABLE(of, sdhci_dt_ids);
> +MODULE_DEVICE_TABLE(of, sdhci_tegra_dt_match);
>  
>  static void sdhci_tegra_parse_dt(struct device *dev,
>  					struct sdhci_tegra *tegra_host)

I was going to take this, but it doesn't apply to mmc-next or
linux-next, because the #endif in your first line of context isn't
present in those trees -- which tree is this based on?

Sounds like it might make more sense for you to take this; if so:
Acked-by: Chris Ball <cjb@laptop.org>

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
