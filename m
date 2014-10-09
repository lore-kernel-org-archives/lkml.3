Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaJIGcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 02:32:47 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:55614 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaJIGci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 02:32:38 -0400
MIME-Version: 1.0
In-Reply-To: <20141009103006.6bd8beb0@ygrex-lenovo>
References: <20141009103006.6bd8beb0@ygrex-lenovo>
Date: Thu, 9 Oct 2014 10:32:37 +0400
Message-ID: <CAHj3AVmNTcoZNTHmVUKqsLk6mg6dT1L3ziyceDqPa4JyPQCoPg@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8188eu: coding style fixup
From: Denis Kirjanov <kirjanov@gmail.com>
To: Igor Bogomazov <ygrex@ygrex.ru>
Cc: devel@driverdev.osuosl.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

But you haven't CCed people in the CC list

On 10/9/14, Igor Bogomazov <ygrex@ygrex.ru> wrote:
> checkpatch.pl tiny fix
> get rid of 2 warnings and 2 errors for hal/fw.c
>
> Signed-off-by: Igor Bogomazov <ygrex@ygrex.ru>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: navin patidar <navin.patidar@gmail.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
> for linux-next 3.17.0
>
> this is an updated version of the patch I've sent two days ago, that one
> did not apply cleanly
>
> diff --git a/drivers/staging/rtl8188eu/hal/fw.c
> b/drivers/staging/rtl8188eu/hal/fw.c
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
>  		return -1;
>  	}
> @@ -226,7 +225,8 @@ int rtl88eu_download_fw(struct adapter *adapt)
>  		rtl88e_firmware_selfreset(adapt);
>  	}
>  	_rtl88e_enable_fw_download(adapt, true);
> -	usb_write8(adapt, REG_MCUFWDL, usb_read8(adapt, REG_MCUFWDL) |
> FWDL_ChkSum_rpt);
> +	usb_write8(adapt, REG_MCUFWDL,
> +		usb_read8(adapt, REG_MCUFWDL) | FWDL_ChkSum_rpt);
>  	_rtl88e_write_fw(adapt, pfwdata, fwsize);
>  	_rtl88e_enable_fw_download(adapt, false);
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
>


-- 
Regards,
Denis
