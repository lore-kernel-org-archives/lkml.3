Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaINN65 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 09:58:57 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:43493 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaINN6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 09:58:55 -0400
Date: Sun, 14 Sep 2014 14:58:52 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, matt.fleming@intel.com,
        leif.lindholm@linaro.org, roy.franz@linaro.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] efi: rtc-efi: export platform:rtc-efi as module alias
Message-ID: <20140914135852.GI18582@console-pimps.org>
References: <1410423640-1499-1-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410423640-1499-1-git-send-email-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc'ing rtc maintainer, list and akpm)

On Thu, 11 Sep, at 10:20:40AM, Ard Biesheuvel wrote:
> When the rtc-efi driver is built as a module, we already register the
> EFI rtc as a platform device if UEFI Runtime Services are enabled.
> To wire it up to udev, and let the module be loaded automatically, we
> need to export the 'platform:rtc-efi' alias from the module.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/rtc/rtc-efi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
> index 8225b89de810..59a55e7abf78 100644
> --- a/drivers/rtc/rtc-efi.c
> +++ b/drivers/rtc/rtc-efi.c
> @@ -235,3 +235,4 @@ module_platform_driver_probe(efi_rtc_driver, efi_rtc_probe);
>  MODULE_AUTHOR("dann frazier <dannf@hp.com>");
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("EFI RTC driver");
> +MODULE_ALIAS("platform:rtc-efi");
> -- 
> 1.8.3.2

I haven't picked up any rtc-efi patches before. They appear to have gone
through akpm in the past.

Andrew, would you mind picking this one up?

-- 
Matt Fleming, Intel Open Source Technology Center
