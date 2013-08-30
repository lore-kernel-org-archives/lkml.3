Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab3H3Nbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:31:37 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62509 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab3H3Nbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:31:34 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 08/16] Generalize handle_ramdisks() and rename to handle_cmdline_files().
To: Roy Franz <roy.franz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        matt.fleming@intel.com, linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
In-Reply-To: <1376090777-20090-9-git-send-email-roy.franz@linaro.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org> <1376090777-20090-9-git-send-email-roy.franz@linaro.org>
Date: Fri, 30 Aug 2013 14:31:38 +0100
Message-Id: <20130830133138.AEFF83E102A@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Aug 2013 16:26:09 -0700, Roy Franz <roy.franz@linaro.org> wrote:
> The handle_cmdline_files now takes the option to handle as a string,
> and returns the loaded data through parameters, rather than taking
> an x86 specific setup_header structure.  For ARM, this will be used
> to load a device tree blob in addition to initrd images.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>

Minor comment below, but otherwise looks good:

Reviewed-by: Grant Likely <grant.likely@linaro.org>

> ---
> @@ -380,7 +388,7 @@ static efi_status_t handle_ramdisks(efi_system_table_t *sys_table_arg,
>  		status = efi_call_phys5(fh->open, fh, &h, filename_16,
>  					EFI_FILE_MODE_READ, (u64)0);
>  		if (status != EFI_SUCCESS) {
> -			efi_printk(sys_table_arg, "Failed to open initrd file: ");
> +			efi_printk(sys_table_arg, "Failed to open file file: ");

"file file:"? Search and replace artifact?

