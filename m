Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab3KTIyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:54:16 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750969Ab3KTIyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:54:14 -0500
From: Richard Weinberger <richard@nod.at>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matt@console-pimps.org, matt.fleming@intel.com,
        matthew.garrett@nebula.com, jlee@suse.com, cxie@redhat.com
Subject: Re: [PATCH] x86, efi: add no_bricked_efi whitelist
Date: Wed, 20 Nov 2013 09:54:03 +0100
Message-ID: <2242165.pl7XBGF5ii@sandpuppy>
User-Agent: KMail/4.11.2 (Linux/3.12.0-34.ge8fa6b4-desktop; KDE/4.11.2; x86_64; ; )
In-Reply-To: <528C740A.6010407@jp.fujitsu.com>
References: <528C740A.6010407@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 20. November 2013, 17:34:18 schrieb Yasuaki Ishimatsu:
> By following works, my system very often fails set_variable() to set new
> variable to efi variable storage and shows "efivars: set_variable() failed:
> status=-28" message.
> 
> - commit 68d929862e29a8b52a7f2f2f86a0600423b093cd
>     efi: be more paranoid about available space when creating variables
> - commit 31ff2f20d9003e74991d135f56e503fe776c127c
>     efi: Distinguish between "remaining space" and actually used space
> - commit 8c58bf3eec3b8fc8162fe557e9361891c20758f2
>     x86,efi: Implement efi_no_storage_paranoia parameter
> - commit f8b8404337de4e2466e2e1139ea68b1f8295974f
>     Modify UEFI anti-bricking code
> 
> When booting my system, remaining space of efi variable storage is about
> 5KB. So there is no room that sets a new variable to the storage. On my
> system, trigger of gc is when EFI_OUT_OF_RESOURCES occurs on pre OS
> environment with UEFI. So if EFI_OUT_OF_RESOURCES occurs by the 5Kbyte
> threshold, nvram storage cannot be used until EFI_OUT_OF_RESOURCES occurs
> on pre OS environment with UEFI.
> 
> This patch adds whitelist. If a server is in the whitelist,
> efi_no_storage_paranoia is set to true. And the system can use all efi
> variable storage.
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> CC: Matthew Garrett <matthew.garrett@nebula.com>
> CC: Richard Weinberger <richard@nod.at>
> CC: Lee, Chun-Y <jlee@suse.com>
> CC: Madper Xie <cxie@redhat.com>
> CC: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/x86/platform/efi/efi.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index c7e22ab..9fadf5d 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -116,6 +116,15 @@ static int __init setup_storage_paranoia(char *arg)
>  }
>  early_param("efi_no_storage_paranoia", setup_storage_paranoia);
> 
> +struct no_bricked_efi {
> +	char vendor[100];
> +	u32 revision;
> +};
> +
> +static struct no_bricked_efi efi_whitelist[] __initdata = {
> +	{"FUJITSU LIMITED", 0},

So, no UEFI from Fujitsu on planet earth suffers from such issues?
How can you guarantee that?

Thanks,
//richard
