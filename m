Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3KEIjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 03:39:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab3KEIjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 03:39:17 -0500
Message-Id: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
User-Agent: quilt/0.60-1
Date: Tue, 05 Nov 2013 16:20:07 +0800
From: dyoung@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de
Subject: [patch 0/7 v2] kexec kernel efi runtime support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the V2 for supporting kexec kernel efi runtime.
Per pervious discussion I pass the 1st kernel efi runtime mapping
via setup_data to 2nd kernel. Besides of the runtime mapping
info I also pass the fw_vendor, runtime, config table, smbios
physical address in setup_data. EFI spec mentioned fw_vendor,
runtime, config table addresses will be converted to virt address
after entering virtual mode, but we will use it as physical address
in efi_init. For smbios EFI spec did not mention about the address
updating, but during my test on a HP workstation, the bios will
convert it to Virt addr, thus pass it in setup_data as well.

For fw_vendor, runtime, config table, I export them in /sys/firmware/
efi/systab, smbios is already in that file.

For efi runtime mapping I add a new directory /sys/firmware/efi/
efi-runtime-map/ like below
[dave@darkstar ~]$ tree /sys/firmware/efi/efi-runtime-map/
/sys/firmware/efi/efi-runtime-map/
├── 0
│   ├── attribute
│   ├── num_pages
│   ├── phys_addr
│   ├── type
│   └── virt_addr
├── 1
│   ├── attribute
│   ├── num_pages
│   ├── phys_addr
│   ├── type
│   └── virt_addr
[snip]
 
kexec-tools will assemble them as setup_data and pass to 2nd kernel.
I will send userspace patches as well.

Limitation is I only write support for x86_64, test on below machines:
Lenovo thinkpad t420
Dell inspiron 14 - 3421
HP Z420 workstation
Qemu + OVMF

Please help to review the patches.

The patches are based on matt's efi master tree

Changes from v1:
add one flag in xloadflags, so kexec-tools can safely load old kernel
without efi support.
coding style fixes
function name for map phys_addr to fixed virt_addr
Add ABI documentation for sysfs files
--
Thanks
Dave
