Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3KVWef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:34:35 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:15464 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab3KVWee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:34:34 -0500
Message-ID: <1385159385.1791.160.camel@misato.fc.hp.com>
Subject: Re: [patch 0/9 v3] kexec kernel efi runtime support
From: Toshi Kani <toshi.kani@hp.com>
To: dyoung@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, matt@console-pimps.org
Date: Fri, 22 Nov 2013 15:29:45 -0700
In-Reply-To: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-21 at 14:17 +0800, dyoung@redhat.com wrote:
> Hi,
> 
> Here is the V3 for supporting kexec kernel efi runtime.
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
> ├── 0
> │   ├── attribute
> │   ├── num_pages
> │   ├── phys_addr
> │   ├── type
> │   └── virt_addr
> ├── 1
> │   ├── attribute
> │   ├── num_pages
> │   ├── phys_addr
> │   ├── type
> │   └── virt_addr
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

Tested on an HP EFI-based 60-way server (prototype).  For the series:

Tested-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi


