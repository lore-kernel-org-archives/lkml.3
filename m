Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab3LJOCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:02:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:42405 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351Ab3LJOCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:02:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,865,1378882800"; 
   d="scan'208";a="447675239"
Date: Tue, 10 Dec 2013 16:01:42 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com,
        sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com, kishon@ti.com,
        jg1.han@samsung.com, jwerner@chromium.org
Subject: Re: [PATCH RFC 1/4] phy: Add provision for tuning phy.
Message-ID: <20131210140142.GB28456@xps8300>
References: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
 <1386672926-26885-2-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386672926-26885-2-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 10, 2013 at 04:25:23PM +0530, Vivek Gautam wrote:
> Some PHY controllers may need to tune PHY post-initialization,
> so that the PHY consumers can call phy-tuning at appropriate
> point of time.
> 
> Signed-off-by: vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/phy/phy-core.c  |   20 ++++++++++++++++++++
>  include/linux/phy/phy.h |    7 +++++++
>  2 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index 03cf8fb..68dbb90 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -239,6 +239,26 @@ out:
>  }
>  EXPORT_SYMBOL_GPL(phy_power_off);
>  
> +int phy_tune(struct phy *phy)
> +{
> +	int ret = -ENOTSUPP;
> +
> +	mutex_lock(&phy->mutex);
> +	if (phy->ops->tune) {
> +		ret =  phy->ops->tune(phy);
> +		if (ret < 0) {
> +			dev_err(&phy->dev, "phy tuning failed --> %d\n", ret);
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	mutex_unlock(&phy->mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(phy_tune);

I think "setup" instead of "tune" is much more clear and reusable.

Thanks,

-- 
heikki
