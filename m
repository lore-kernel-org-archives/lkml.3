Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab3KHObz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 09:31:55 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:56975 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254Ab3KHOby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 09:31:54 -0500
Date: Fri, 8 Nov 2013 14:31:18 +0000
From: Matt Fleming <matt@console-pimps.org>
To: dyoung@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de
Subject: Re: [patch 0/7 v2] kexec kernel efi runtime support
Message-ID: <20131108143118.GA22636@console-pimps.org>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Nov, at 04:20:07PM, dyoung@redhat.com wrote:
> Hi,
> 
> Here is the V2 for supporting kexec kernel efi runtime.
> Per pervious discussion I pass the 1st kernel efi runtime mapping
> via setup_data to 2nd kernel. Besides of the runtime mapping
> info I also pass the fw_vendor, runtime, config table, smbios
> physical address in setup_data. EFI spec mentioned fw_vendor,
> runtime, config table addresses will be converted to virt address
> after entering virtual mode, but we will use it as physical address
> in efi_init. For smbios EFI spec did not mention about the address
> updating, but during my test on a HP workstation, the bios will
> convert it to Virt addr, thus pass it in setup_data as well.

I see this in the dmesg,

[    0.000000] efi: skipping setup_data on EFI 32BIT!

despite the fact that this is on an x86-64 box. Turns out it's because
CONFIG_DEBUG_BOOT_PARAMS isn't set in my config. You may want to turn
that on automatically. After doing that things work on my ASUS box (good
work!) but the SATA controller craps out on my Tunnelmountain machine,
but that's probably unrelated and I'll debug that separately.

I see a bunch of section mismatch warnings,

WARNING: arch/x86/platform/efi/built-in.o(.text+0xd1e): Section mismatch in reference from the function efi_map_regions_fixed() to the function .init.text:efi_map_region_fixed()
The function efi_map_regions_fixed() references
the function __init efi_map_region_fixed().
This is often because efi_map_regions_fixed lacks a __init 
annotation or the annotation of efi_map_region_fixed is wrong.

WARNING: arch/x86/platform/efi/built-in.o(.text+0xd2a): Section mismatch in reference from the function efi_map_regions_fixed() to the variable .init.data:efi_phys
The function efi_map_regions_fixed() references
the variable __initdata efi_phys.
This is often because efi_map_regions_fixed lacks a __initdata 
annotation or the annotation of efi_phys is wrong.

WARNING: arch/x86/platform/built-in.o(.text+0xd1e): Section mismatch in reference from the function efi_map_regions_fixed() to the function .init.text:efi_map_region_fixed()
The function efi_map_regions_fixed() references
the function __init efi_map_region_fixed().
This is often because efi_map_regions_fixed lacks a __init 
annotation or the annotation of efi_map_region_fixed is wrong.

WARNING: arch/x86/platform/built-in.o(.text+0xd2a): Section mismatch in reference from the function efi_map_regions_fixed() to the variable .init.data:efi_phys
The function efi_map_regions_fixed() references
the variable __initdata efi_phys.
This is often because efi_map_regions_fixed lacks a __initdata 
annotation or the annotation of efi_phys is wrong.

WARNING: arch/x86/built-in.o(.text+0x7c357): Section mismatch in reference from the function parse_efi_setup() to the function .init.text:early_memremap()
The function parse_efi_setup() references
the function __init early_memremap().
This is often because parse_efi_setup lacks a __init 
annotation or the annotation of early_memremap is wrong.

WARNING: arch/x86/built-in.o(.text+0x7c390): Section mismatch in reference from the function parse_efi_setup() to the function .init.text:early_iounmap()
The function parse_efi_setup() references
the function __init early_iounmap().
This is often because parse_efi_setup lacks a __init 
annotation or the annotation of early_iounmap is wrong.

WARNING: arch/x86/built-in.o(.text+0x7c5ce): Section mismatch in reference from the function efi_map_regions_fixed() to the function .init.text:efi_map_region_fixed()
The function efi_map_regions_fixed() references
the function __init efi_map_region_fixed().
This is often because efi_map_regions_fixed lacks a __init 
annotation or the annotation of efi_map_region_fixed is wrong.

WARNING: arch/x86/built-in.o(.text+0x7c5da): Section mismatch in reference from the function efi_map_regions_fixed() to the variable .init.data:vdso32_sysenter_end
The function efi_map_regions_fixed() references
the variable __initdata vdso32_sysenter_end.
This is often because efi_map_regions_fixed lacks a __initdata 
annotation or the annotation of vdso32_sysenter_end is wrong.

Also, many of your patch descriptions are missing subsystem tags. Please
fix this in your next submission.

-- 
Matt Fleming, Intel Open Source Technology Center
