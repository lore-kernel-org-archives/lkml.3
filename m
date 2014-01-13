Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaAMPEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:04:16 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:39294 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbaAMPEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:04:12 -0500
Date: Mon, 13 Jan 2014 15:04:06 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org,
        grant.likely@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        patches@linaro.org
Subject: Re: [PATCH V6 3/8] Add helper function to get and convert EFI
 command line
Message-ID: <20140113150406.GE3256@console-pimps.org>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
 <1389371417-379-4-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389371417-379-4-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jan, at 08:30:12AM, Roy Franz wrote:
> Add an EFI stub helper function to retrieve the EFI command line using
> the LOADED_IMAGE_PROTOCOL, and convert it to ASCII.  This function will
> be shared by the various EFI stub implementations.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  drivers/firmware/efi/efi-stub-helper.c |   30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
> index eb5d2eb..f657456 100644
> --- a/drivers/firmware/efi/efi-stub-helper.c
> +++ b/drivers/firmware/efi/efi-stub-helper.c
> @@ -637,3 +637,33 @@ static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
>  	*cmd_line_len = options_size;
>  	return (char *)cmdline_addr;
>  }
> +
> +/*
> + * get the command line from EFI, using the LOADED_IMAGE
> + * protocol, and convert to ASCII.
> + *
> + */
> +static void efi_get_cmdline(efi_system_table_t *sys_table,
> +			      efi_loaded_image_t **image,
> +			      void *handle, char **cmdline_ptr)
> +{

Wouldn't this prototype make more sense?

static char *efi_get_cmdline(efi_system_table_t *sys_table,
			     efi_loaded_image_t **image,
			     void *handle);

Is this function really worth implementing at all? Certainly on x86, we
lookup the loaded image protocol for reasons other than parsing the
command line, and so would need to do it in the caller anyway.

-- 
Matt Fleming, Intel Open Source Technology Center
