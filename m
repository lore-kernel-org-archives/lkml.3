Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaCNCrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 22:47:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbaCNCrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 22:47:35 -0400
Date: Fri, 14 Mar 2014 10:47:26 +0800
From: Dave Young <dyoung@redhat.com>
To: Linn Crosetto <linn@hp.com>
Cc: WANG Chao <chaowang@redhat.com>, kexec@lists.infradead.org,
        horms@verge.net.au, ebiederm@xmission.com, hpa@zytor.com,
        trenn@suse.de, vgoyal@redhat.com, matt@console-pimps.org, bp@alien8.de,
        toshi.kani@hp.com, dyoung@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] x86: Pass memory range via E820 for kdump
Message-ID: <20140314024726.GA2245@dhcp-16-126.nay.redhat.com>
References: <1394464149-30384-1-git-send-email-chaowang@redhat.com>
 <1394464149-30384-5-git-send-email-chaowang@redhat.com>
 <20140313222428.GW7672@oranje.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313222428.GW7672@oranje.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [..]
> 
> I tested on a prototype system with 231 entries in the map with good results.
> Everything succeeds when using kexec to initiate a fast reboot. For crash, it
> works with and without --pass-memmap-cmdline when using noefi. I hit the
> following panic when initiating a crash leaving EFI enabled in the crash kernel:
> 
>  ? __unmap_pmd_range+0x77/0x190
>  unmap_pmd_range+0xcf/0x1c0
>  populate_pgd+0x16d/0x250
>  __cpa_process_fault+0x15/0xb0
>  __change_page_attr+0x15e/0x2a0
>  __change_page_attr_set_clr+0x59/0xc0
>  kernel_map_pages_in_pgd+0x7a/0xb0
>  __map_region+0x46/0x64
>  ? early_idt_handlers+0x117/0x120
>  efi_map_region_fixed+0xd/0xf
>  efi_enter_virtual_mode+0x4c/0x476
>  ? early_idt_handlers+0x117/0x120
>  ? early_idt_handlers+0x117/0x120
>  start_kernel+0x2e5/0x376
>  ? repair_env_string+0x5b/0x5b
>  ? memblock_reserve+0x49/0x4e
>  x86_64_start_reservations+0x2a/0x2c
>  x86_64_start_kernel+0x19f/0x1ae
> 
> However, I was able to reproduce this panic using an earlier version of
> kexec-tools, so I believe it is unrelated to this patch.

Can you test with matt's tree to see if it works?
If it still happens please post the full log.

Thanks
Dave
