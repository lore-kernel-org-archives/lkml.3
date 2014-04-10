Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030520AbaDJMYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:24:44 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:45385 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030282AbaDJMYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:24:41 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: "54b52d87268034859191d671505bb1cfce6bd74d - x86/efi: Build our own EFI services pointer table" breaks boot on thinkpad t440s
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <20140410121146.GA17021@console-pimps.org>
Date: Thu, 10 Apr 2014 14:24:38 +0200
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Kees Cook <keescook@chromium.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <88A266AC-FAC5-445D-B9BE-CFD289B23E6C@dominion.thruhere.net>
References: <AF4406ED-6B0B-4E15-A329-04162E0ADC8A@dominion.thruhere.net> <20140410121146.GA17021@console-pimps.org>
To: Matt Fleming <matt@console-pimps.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 10 apr. 2014, om 14:11 heeft Matt Fleming <matt@console-pimps.org> het volgende geschreven:

> On Thu, 10 Apr, at 12:43:43PM, Koen Kooi wrote:
>> Hi,
>> 
>> After updating from 3.14-rc7 to a recent git the kernel fails to boot on my thinkpad t440s and displays:
>> 
>> 	Failed to get file info size
>> 	Failed to alloc highmem for files
>> 
>> After a morning of running git bisect and rebooting, the bad commit seems to be:
>> 
>> 	54b52d87268034859191d671505bb1cfce6bd74d - x86/efi: Build our own EFI services pointer table
> 
> Thanks for the report. Can you try this patch against Linus' tree?

That indeed fixes it, so:

Tested-by: Koen Kooi <koen@dominion.thruhere.net>

regards,

Koen

> 
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index 1e6146137f8e..280165524ee4 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -112,7 +112,7 @@ __file_size64(void *__fh, efi_char16_t *filename_16,
> 	efi_file_info_t *info;
> 	efi_status_t status;
> 	efi_guid_t info_guid = EFI_FILE_INFO_ID;
> -	u32 info_sz;
> +	u64 info_sz;
> 
> 	status = efi_early->call((unsigned long)fh->open, fh, &h, filename_16,
> 				 EFI_FILE_MODE_READ, (u64)0);
> -- 
> Matt Fleming, Intel Open Source Technology Center
> 

