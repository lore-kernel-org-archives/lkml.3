Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbaHYUGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 16:06:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbaHYUGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 16:06:20 -0400
Date: Mon, 25 Aug 2014 13:05:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 04/29] drivers: base: add notifier for failed driver bind
Message-ID: <20140825200539.GA22076@kroah.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
 <1407235677-26324-5-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407235677-26324-5-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 12:47:32PM +0200, Marek Szyprowski wrote:
> This patch adds support for getting a notify for failed device driver
> bind, so all the items done in BUS_NOTIFY_BIND_DRIVER event can be
> cleaned if the driver fails to bind.

But doesn't the bus know if the driver fails to bind, so why would a
notifier be needed here?  Can't it unwind any problems then?

> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/base/dd.c      | 10 +++++++---
>  include/linux/device.h |  4 +++-
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index e4ffbcf..541a41f 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -237,10 +237,14 @@ static int driver_sysfs_add(struct device *dev)
>  	return ret;
>  }
>  
> -static void driver_sysfs_remove(struct device *dev)
> +static void driver_sysfs_remove(struct device *dev, int failed)

I _hate_ having functions with a flag that does something different
depending on it.  If you _really_ need this, just make the notifier call
before calling this function, which should work just fine, right?

thanks,

greg k-h
