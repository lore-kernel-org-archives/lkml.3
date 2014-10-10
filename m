Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaJJIq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:46:27 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42690 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaJJIqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:46:23 -0400
Date: Fri, 10 Oct 2014 14:16:09 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Igor Bogomazov <ygrex@ygrex.ru>
Cc: devel@driverdev.osuosl.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        navin patidar <navin.patidar@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: rtl8188eu: coding style fixup
Message-ID: <20141010084609.GA5396@sudip-PC>
References: <20141010110920.18d90eee@ygrex-lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010110920.18d90eee@ygrex-lenovo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 11:09:20AM +0400, Igor Bogomazov wrote:
> checkpatch.pl tiny fix
> get rid of 2 warnings and 2 errors for hal/fw.c:
> 
> WARNING: braces {} are not necessary for single statement blocks
> WARNING: line over 80 characters
> ERROR: space required before the open brace '{'
> ERROR: space required after that ',' (ctx:VxV)
you should usually do only one type of fix in a patch.

> 
> Signed-off-by: Igor Bogomazov <ygrex@ygrex.ru>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: navin patidar <navin.patidar@gmail.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
> for linux-next 3.17.0
> 
> this is an updated version of the patch I've sent yesterday, that one
> did not provide a clear description
> 
> diff --git a/drivers/staging/rtl8188eu/hal/fw.c b/drivers/staging/rtl8188eu/hal/fw.c
> --- a/drivers/staging/rtl8188eu/hal/fw.c
> +++ b/drivers/staging/rtl8188eu/hal/fw.c
> @@ -154,9 +154,8 @@ static int _rtl88e_fw_free_to_go(struct adapter *adapt)
>  			break;
>  	} while (counter++ < POLLING_READY_TIMEOUT_COUNT);
>  
> -	if (counter >= POLLING_READY_TIMEOUT_COUNT) {
> +	if (counter >= POLLING_READY_TIMEOUT_COUNT)
>  		goto exit;
> -	}
>  
>  	value32 = usb_read32(adapt, REG_MCUFWDL);
>  	value32 |= MCUFWDL_RDY;
> @@ -193,13 +192,13 @@ int rtl88eu_download_fw(struct adapter *adapt)
>  	u32 fwsize;
>  	int err;
>  
> -	if (request_firmware(&fw, fw_name, device)){
> +	if (request_firmware(&fw, fw_name, device)) {
>  		dev_err(device, "Firmware %s not available\n", fw_name);
>  		return -ENOENT;
>  	}
>  
>  	if (fw->size > FW_8188E_SIZE) {
> -		dev_err(device,"Firmware size exceed 0x%X. Check it.\n",
> +		dev_err(device, "Firmware size exceed 0x%X. Check it.\n",
>  			 FW_8188E_SIZE);

align this with the open parenthesis

>  		return -1;
>  	}
> @@ -226,7 +225,8 @@ int rtl88eu_download_fw(struct adapter *adapt)
>  		rtl88e_firmware_selfreset(adapt);
>  	}
>  	_rtl88e_enable_fw_download(adapt, true);
> -	usb_write8(adapt, REG_MCUFWDL, usb_read8(adapt, REG_MCUFWDL) | FWDL_ChkSum_rpt);
> +	usb_write8(adapt, REG_MCUFWDL,
> +		usb_read8(adapt, REG_MCUFWDL) | FWDL_ChkSum_rpt);
same here also. 
check your patch with --strict option of checkpatch

thanks
sudip

>  	_rtl88e_write_fw(adapt, pfwdata, fwsize);
>  	_rtl88e_enable_fw_download(adapt, false);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
