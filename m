Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab3H3Nc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:32:58 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48806 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3H3Nc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:32:57 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 10/16] Move EFI_READ_CHUNK_SIZE define to shared location.
To: Roy Franz <roy.franz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        matt.fleming@intel.com, linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
In-Reply-To: <1376090777-20090-11-git-send-email-roy.franz@linaro.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org> <1376090777-20090-11-git-send-email-roy.franz@linaro.org>
Date: Fri, 30 Aug 2013 14:33:02 +0100
Message-Id: <20130830133302.E163A3E102A@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Aug 2013 16:26:11 -0700, Roy Franz <roy.franz@linaro.org> wrote:
> This #define is only used the the shared code, so move
> it there.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>

Can this be squashed into patch 1?

g.

> ---
>  arch/x86/boot/compressed/eboot.h       |    1 -
>  drivers/firmware/efi/efi-stub-helper.c |    2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
> index faa0bdf..bafbd94 100644
> --- a/arch/x86/boot/compressed/eboot.h
> +++ b/arch/x86/boot/compressed/eboot.h
> @@ -12,7 +12,6 @@
>  #define DESC_TYPE_CODE_DATA	(1 << 0)
>  
>  #define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
> -#define EFI_READ_CHUNK_SIZE	(1024 * 1024)
>  
>  #define EFI_CONSOLE_OUT_DEVICE_GUID    \
>  	EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4, 0x9a, 0x46, 0x0, 0x90, 0x27, \
> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
> index 0f4d6e6..b707a9f 100644
> --- a/drivers/firmware/efi/efi-stub-helper.c
> +++ b/drivers/firmware/efi/efi-stub-helper.c
> @@ -9,7 +9,7 @@
>   * under the terms of the GNU General Public License version 2.
>   *
>   */
> -
> +#define EFI_READ_CHUNK_SIZE	(1024 * 1024)
>  
>  struct file_info {
>  	efi_file_handle_t *handle;
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

