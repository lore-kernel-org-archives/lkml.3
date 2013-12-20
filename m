Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3LTSG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:06:26 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:45067 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3LTSGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:06:25 -0500
Message-ID: <1387562470.21140.57.camel@misato.fc.hp.com>
Subject: Re: [PATCH v7 00/12] kexec kernel efi runtime support
From: Toshi Kani <toshi.kani@hp.com>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, matt@console-pimps.org,
        akpm@linux-foundation.org, mingo@kernel.org, msalter@redhat.com,
        leif.lindholm@linaro.org
Date: Fri, 20 Dec 2013 11:01:10 -0700
In-Reply-To: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-20 at 18:02 +0800, Dave Young wrote:
> Here is the V7 patchset for supporting kexec kernel efi runtime.
> Per pervious discussion I pass the 1st kernel efi runtime mapping
> via setup_data to 2nd kernel. Besides of the runtime mapping
> info I also pass the fw_vendor, runtime, config table, smbios
> physical address in setup_data. EFI spec mentioned fw_vendor,
> runtime, config table addresses will be converted to virt address
> after entering virtual mode, but we will use it as physical address
> in efi_init. For smbios EFI spec did not mention about the address
> updating, but during my test on a HP workstation, the bios will
> convert it to Virt addr, thus pass it in setup_data as well.
> 
> For fw_vendor, runtime, config table, I export them in /sys/firmware/
> efi/, smbios is already in /sys/firmware/efi/systab.
> 
> For efi runtime mapping I add a new directory /sys/firmware/efi/
> runtime-map/ like below
> [dave@darkstar ~]$ tree /sys/firmware/efi/runtime-map/
> /sys/firmware/efi/runtime-map/
> |__ 0
> |   |__ attribute
> |   |__ num_pages
> |   |__ phys_addr
> |   |__ type
> |   |__ virt_addr
> |__ 1
> [snip]
> 
> kexec-tools will assemble them as setup_data and pass to 2nd kernel.
> I will send userspace patches as well.
> 
> Limitation is I only write support for x86_64, test on below machines:
> Lenovo thinkpad t420
> Dell inspiron 14 - 3421
> HP Z420 workstation
> Qemu + OVMF

Tested on an HP 60-way UEFI platform (proto).  For the series:

Tested-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi


