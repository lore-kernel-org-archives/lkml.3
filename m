Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaJGJYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:24:11 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:65133 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbaJGJYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:24:09 -0400
Date: Tue, 7 Oct 2014 10:24:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Johan Hovold <johan@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/6] mfd: core: add helper function to register hotplug
 devices
Message-ID: <20141007092403.GS25331@lee--X1>
References: <1411728933-13351-1-git-send-email-johan@kernel.org>
 <1411728933-13351-4-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411728933-13351-4-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014, Johan Hovold wrote:

> Hot-pluggable multi-function devices should always be registered with
> PLATFORM_DEVID_AUTO to avoid name collisions on the platform bus. This
> helper also hides the memory map and irq parameters, which aren't used
> by hot-pluggable (e.g. USB-based) devices.
> 
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  include/linux/mfd/core.h | 7 +++++++
>  1 file changed, 7 insertions(+)

Applied for v3.19.

> diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
> index f543de91ce19..1e47262a1c63 100644
> --- a/include/linux/mfd/core.h
> +++ b/include/linux/mfd/core.h
> @@ -108,6 +108,13 @@ extern int mfd_add_devices(struct device *parent, int id,
>  			   struct resource *mem_base,
>  			   int irq_base, struct irq_domain *irq_domain);
>  
> +static inline int mfd_add_hotplug_devices(struct device *parent,
> +		const struct mfd_cell *cells, int n_devs)
> +{
> +	return mfd_add_devices(parent, PLATFORM_DEVID_AUTO, cells, n_devs,
> +			NULL, 0, NULL);
> +}
> +
>  extern void mfd_remove_devices(struct device *parent);
>  
>  #endif

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
