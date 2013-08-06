Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab3HFNxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 09:53:21 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37831 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915Ab3HFNxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 09:53:20 -0400
Date: Tue, 6 Aug 2013 14:53:14 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org
Subject: Re: [PATCH 3/7] Change EFI helper APIs to be more flexible
Message-ID: <20130806135314.GX2515@console-pimps.org>
References: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
 <1375478948-22562-4-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375478948-22562-4-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Aug, at 02:29:04PM, Roy Franz wrote:
> * Change the EFI helper functions to be more flexible to allow their use
> by other architectures.
> * Pass system table pointer as argument to all functions that use it,
> rather than use a global variable.
> * Change name of __get_map to efi_get_memory_map, and add key pointer argument
> so it can be used to get final memory map before the EFI exitBootServices()
> function is called.
> * Change the handle_ramdisks() to handle_cmdline_files(), and make it more
> generic by taking string to match rather than hardcoding 'initrd='
> so it can be used to load device tree files as well.
> * Add 'min' address parameter to limit low_alloc() alloctions
> * Fix type of chunksize to match EFI function (not checked in x86 code
> as wrappers break type checking.)
> * rename alloc/free functions - low_free() is usable by both low_alloc()
> and high_alloc(), so rename them to be more consistent - efi_low_alloc()
> efi_high_alloc(), and efi_free()
> * Enforce minimum pagesize alignment as expected by EFI allocate_pages().
> * check for 0 size in efi_free.
 
This is way too many changes to include in a single patch, and makes
review fairly difficult. Please split this large patch into smaller
patches.

Not only are smaller patches easier to review, they make it much easier
for you to incorporate any feedback.

-- 
Matt Fleming, Intel Open Source Technology Center
