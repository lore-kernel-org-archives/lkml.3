Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab3KZTaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:30:25 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:45244 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754288Ab3KZTaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:30:22 -0500
Date: Tue, 26 Nov 2013 19:30:16 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v4 06/12] efi: export efi runtime memory mapping to sysfs
Message-ID: <20131126193016.GA18170@console-pimps.org>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-7-git-send-email-dyoung@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385445477-9665-7-git-send-email-dyoung@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov, at 01:57:51PM, Dave Young wrote:
> kexec kernel will need exactly same mapping for
> efi runtime memory ranges. Thus here export the
> runtime ranges mapping to sysfs, kexec-tools
> will assemble them and pass to 2nd kernel via
> setup_data.
> 
> Introducing a new directly /sys/firmware/efi/runtime-map

I'm not sure why the word "directly" is used here?

> Just like /sys/firmware/memmap. Containing below attribute
> in each file of that directory:
> attribute  num_pages  phys_addr  type  virt_addr
> 
> It will not work for efi 32bit. Only x86_64 currently.
 
Actually, exporting the tables does work for 32-bit, right? It's just
that kexec doesn't work for 32-bit EFI?

> Matt: s/efi-runtime-map.c/runtime-map.c
>       change dir name to runtime-map
> update to use desc_size in efi_runtime_map
> cleaup the code, add function efi_save_runtime_map
> improve err handling
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  .../ABI/testing/sysfs-firmware-efi-runtime-map     |  45 +++++
>  arch/x86/platform/efi/efi.c                        |  26 +++
>  drivers/firmware/efi/Kconfig                       |  10 ++
>  drivers/firmware/efi/Makefile                      |   1 +
>  drivers/firmware/efi/efi.c                         |   3 +-
>  drivers/firmware/efi/runtime-map.c                 | 199 +++++++++++++++++++++
>  include/linux/efi.h                                |   6 +
>  7 files changed, 289 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
>  create mode 100644 drivers/firmware/efi/runtime-map.c
> 
> diff --git a/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map b/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
> new file mode 100644
> index 0000000..dab8d41
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
> @@ -0,0 +1,45 @@
> +What:		/sys/firmware/efi/runtime-map/
> +Date:		Oct 2013
> +Contact:	Dave Young <dyoung@redhat.com>
> +Description:
> +		Switching efi runtime services to virtual mode requires
> +		that all efi memory ranges which has the runtime attribute
> +		bit set to be mapped to virtual addresses.
> +
> +		In kexec kernel kernel can not entering virtual mode again
> +		because there's a limitation that SetVirtualAddressMap can
> +		only be called once for entering virtual mode. But kexec
> +		kernel still need maintain same physical address to virtual
> +		address mapping as the 1st kernel. The mappings are exported
> +		to sysfs so userspace tools can reassemble them and pass them
> +		into kexec kernel.

How about,

		"The efi runtime services can only be switched to virtual
		 mode once without rebooting. The kexec kernel must maintain
		 the same physical to virtual address mappings as the first
		 kernel. The mappings are exported to sysfs so userspace tools
		 can reassemble them and pass them into the kexec kernel."

?

> +		/sys/firmware/efi/runtim-map/ is what kernel export for

				^^ runtime-map/

-- 
Matt Fleming, Intel Open Source Technology Center
