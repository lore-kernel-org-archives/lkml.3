Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbbAZLP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:15:58 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:49809 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086AbbAZLPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:15:54 -0500
Message-ID: <1422270952.9483.2.camel@x220>
Subject: Re: [PATCH] modify the IO_TLB_SEGSIZE to configtable as flexible
 requirement about IOMMU/SW-IOMMU.
From: Paul Bolle <pebolle@tiscali.nl>
To: xiaomin1 <xiaoming.wang@intel.com>
Cc: konrad.wilk@oracle.com, akpm@linux-foundation.org, linux@horizon.com,
        lauraa@codeaurora.org, heiko.carstens@de.ibm.com,
        d.kasatkin@samsung.com, takahiro.akashi@linaro.org,
        chris@chris-wilson.co.uk, u.kleine-koenig@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Zhang Dongxing <dongxing.zhang@intel.com>
Date: Mon, 26 Jan 2015 12:15:52 +0100
In-Reply-To: <1422300621-4453-1-git-send-email-xiaoming.wang@intel.com>
References: <1422300621-4453-1-git-send-email-xiaoming.wang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2015 11:15:52.0766 (UTC) FILETIME=[726245E0:01D03959]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(For some reason the "Date:" header of this message is 16 hours into the
future. Ie, it claims to be for (UTC) 2015-01-26, 19.30 but actually was
probably sent around (UTC) 2015-01-26, 03.30. This made this message
stick at the top of the mail folder it ended up in. And that was about
the only reason why I even scanned it.)

On Tue, 2015-01-27 at 03:30 +0800, xiaomin1 wrote:
> The maximum of SW-IOMMU is limited to 2^11*128 = 256K.
> While in different platform and different requirements this seems improper.
> So modify the IO_TLB_SEGSIZE to configtable is make sense.
                                  configurable?

Ditto for the summary.

> Example:
> If 1M bytes are requied. There has an error like.
                  required one will run into an error like:

or something similar.

> [ 33.293120] DMA: Out of SW-IOMMU space for 1048576 bytes at device gadget

So in order to solve that and use 1M this new option needs to be set at
512?

> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> Signed-off-by: xiaomin1 <xiaoming.wang@intel.com>
> ---
>  include/linux/swiotlb.h |    2 +-
>  lib/Kconfig             |    4 ++++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index e7a018e..5ab10b9 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -14,7 +14,7 @@ extern int swiotlb_force;
>   * must be a power of 2.  What is the appropriate value ?
>   * The complexity of {map,unmap}_single is linearly dependent on this value.
>   */
> -#define IO_TLB_SEGSIZE	128
> +#define IO_TLB_SEGSIZE	CONFIG_DEFAULT_IO_TLB_SEGSIZE
>  
>  /*
>   * log of the size of each IO TLB slab.  The number of slabs is command line
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 54cf309..76f1108 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -518,4 +518,8 @@ source "lib/fonts/Kconfig"
>  config ARCH_HAS_SG_CHAIN
>  	def_bool n
>  
> +config DEFAULT_IO_TLB_SEGSIZE
> +	int

No "prompt", so to change this value one needs to edit the .config
manually. Is that intended?

> +	default 128

According to include/linux/swiotlb.h this needs to be a power of 2.
Shouldn't that be explained here too? Ditto the 2K unit size. And should
a range of useful values be specified?

(These are not rhetorical questions: I know nothing about all this. This
also means I might just not be part of the intended audience for this
option.)

>  endmenu


Paul Bolle

