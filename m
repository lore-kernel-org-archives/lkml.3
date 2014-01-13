Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaAMPSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:18:07 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:60281 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbaAMPSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:18:05 -0500
Date: Mon, 13 Jan 2014 15:17:59 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, matt.fleming@intel.com,
        Leif Lindholm <leif.lindholm@linaro.org>, roy.franz@linaro.org,
        patches@linaro.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/6] efi: create memory map iteration helper
Message-ID: <20140113151759.GG3256@console-pimps.org>
References: <1389392950-22457-1-git-send-email-msalter@redhat.com>
 <1389392950-22457-2-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389392950-22457-2-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jan, at 05:29:05PM, Mark Salter wrote:
> There are a lot of places in the kernel which iterate through an
> EFI memory map. Most of these places use essentially the same
> for-loop code. This patch adds a for_each_efi_memory_desc()
> helper to clean up all of the existing duplicate code and avoid
> more in the future.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  include/linux/efi.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 11ce678..9dc5b05 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -618,6 +618,12 @@ extern int efi_set_rtc_mmss(const struct timespec *now);
>  extern void efi_reserve_boot_services(void);
>  extern struct efi_memory_map memmap;
>  
> +/* Iterate through an efi_memory_map */
> +#define for_each_efi_memory_desc(m, md)					   \
> +	for ((md) = (m)->map;						   \
> +	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
> +	     (md) = (void *)(md) + (m)->desc_size)
> +

Err, what? I just picked up your previous patch ("x86/efi: Create memory
map iteration helper") which adds this chunk, and I didn't see a follow
up email telling me not to pick it up.

What's the plan?

-- 
Matt Fleming, Intel Open Source Technology Center
