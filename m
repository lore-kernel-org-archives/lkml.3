Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab3CFRhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 12:37:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45714 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab3CFRhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 12:37:37 -0500
Message-ID: <51377ED7.1060800@zytor.com>
Date: Wed, 06 Mar 2013 09:37:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Josh Boyer <jwboyer@gmail.com>
CC: Yinghai Lu <yinghai@kernel.org>, Robin Holt <holt@sgi.com>, hpa@sgi.com,
        linux-kernel@vger.kernel.org, pjones@redhat.com
Subject: Re: Revert commit 5dcd14ecd4 - breaks EFI boot with SLES11 elilo.efi
References: <20130228205206.GC3438@sgi.com> <512FC697.3090608@zytor.com> <20130228210910.GD3438@sgi.com> <512FC82B.40909@zytor.com> <CAE9FiQU3FBwEiC86N1RC8=aMdN09EbUmRcsWP0yof7bmxBhPew@mail.gmail.com> <512FE3AE.4070903@zytor.com> <20130305081519.GA19165@sgi.com> <9bcd6241-37fd-4ae9-a997-2a5da1eaf997@email.android.com> <CAE9FiQV2Wk+yiqR8FnNM_L-p1iQFxDwopRzFWTwm6VCkyrbuoQ@mail.gmail.com> <CA+5PVA4VRa7z10APcEaoebX3vwtbLzDLq1PAHmfaHBDqtZv=jw@mail.gmail.com> <51377C3A.3030301@zytor.com> <CA+5PVA51-FT14p4CRYKbicykugVb=PiaEycdQ57CK2km_OQuRQ@mail.gmail.com>
In-Reply-To: <CA+5PVA51-FT14p4CRYKbicykugVb=PiaEycdQ57CK2km_OQuRQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 09:36 AM, Josh Boyer wrote:
> 
> Something like this?
> 
> Index: linux-2.6/arch/x86/include/asm/bootparam_utils.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/bootparam_utils.h
> +++ linux-2.6/arch/x86/include/asm/bootparam_utils.h
> @@ -20,8 +20,11 @@ static void sanitize_boot_params(struct
>  	if (boot_params->sentinel) {
>  		/*fields in boot_params are not valid, clear them */
>  		memset(&boot_params->olpc_ofw_header, 0,
> -		       (char *)&boot_params->alt_mem_k -
> +		       (char *)&boot_params->efi_info -
>  			(char *)&boot_params->olpc_ofw_header);
>  		memset(&boot_params->kbd_status, 0,
>  		       (char *)&boot_params->hdr -
>  		       (char *)&boot_params->kbd_status);
> 
> I can try that in a bit.
> 

Right.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

