Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab3IYMBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:01:24 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:51495 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755198Ab3IYMBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:01:23 -0400
Date: Wed, 25 Sep 2013 13:01:18 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, leif.lindholm@linaro.org,
        grant.likely@linaro.org, msalter@redhat.com
Subject: Re: [PATCH 06/18] Enforce minimum alignment of 1 page on allocations.
Message-ID: <20130925120118.GE21381@console-pimps.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
 <1379889942-3135-7-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379889942-3135-7-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Sep, at 03:45:30PM, Roy Franz wrote:
> The efi_high_alloc() and efi_low_alloc() functions
> use the EFI_ALLOCATE_ADDRESS option to the EFI
> function allocate_pages(), which requires a minimum
> of page alignment, and rejects all other requests.
> The existing code could fail to allocate depending
> on allocation size, as although repeated allocation
> attempts were made, none were guaranteed to be page
> aligned.
> 
> 
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> Acked-by: Mark Salter <msalter@redhat.com>
> Reviewed-by: Grant Likely <grant.likely@linaro.org>
> ---
>  drivers/firmware/efi/efi-stub-helper.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)

[...]

> +	/* Enforce minimum alignment that EFI requires when requesting
> +	 * a specific address.  We are doing page-based allocations,
> +	 * so we must be aligned to a page.
> +	 */
> +	if (align < EFI_PAGE_SIZE)
> +		align = EFI_PAGE_SIZE;
> +

FYI I manually fixed up these comments to use the multi-line form, e.g.

	/*
	 * Enforce minimum alignment that EFI requires when requesting
	 * a specific address.  We are doing page-based allocations,
	 * so we must be aligned to a page.
	 */

so that they match the rest of the comments in the file.

-- 
Matt Fleming, Intel Open Source Technology Center
