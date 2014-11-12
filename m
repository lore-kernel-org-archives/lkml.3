Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaKLJZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:25:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:13896 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbaKLJZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:25:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,367,1413270000"; 
   d="scan'208";a="630664778"
Message-ID: <1415784298.14686.323.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: BUG() at boot in __phys_addr with DEBUG_VIRTUAL
From: Matt Fleming <matt.fleming@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Borislav Petkov <bp@suse.de>, the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 12 Nov 2014 09:24:58 +0000
In-Reply-To: <5462999A.7090706@intel.com>
References: <5462999A.7090706@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.33.239.180]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 15:19 -0800, Dave Hansen wrote:
> I'm seeing a BUG() at boot in __phys_addr when it has DEBUG_VIRTUAL enabled:
> 
> >> [    1.193264] ------------[ cut here ]------------
> >> [    1.198502] kernel BUG at /home/davehans/linux.git/arch/x86/mm/physaddr.c:36!
> > ...
> >> [    1.368810] Call Trace:
> >> [    1.371590]  [<ffffffff8105824c>] __change_page_attr_set_clr+0x42c/0xff0
> >> [    1.379197]  [<ffffffff81059e42>] kernel_map_pages_in_pgd+0x72/0x110
> >> [    1.386410]  [<ffffffff81fe2be2>] __map_region+0x45/0x63
> >> [    1.392437]  [<ffffffff81fe2e13>] efi_map_region+0x32/0xce
> >> [    1.398663]  [<ffffffff81fe2936>] efi_enter_virtual_mode+0x18c/0x3a4
> >> [    1.405876]  [<ffffffff81fcb0b6>] start_kernel+0x421/0x4a1
> >> [    1.412101]  [<ffffffff81fcaa85>] ? set_init_arg+0x55/0x55
> >> [    1.418327]  [<ffffffff81fca120>] ? early_idt_handlers+0x120/0x120
> >> [    1.425342]  [<ffffffff81fca5f2>] x86_64_start_reservations+0x2a/0x2c
> >> [    1.432652]  [<ffffffff81fca746>] x86_64_start_kernel+0x152/0x161
> >> [    1.439565] Code: 0f 94 c2 31 c0 e8 a6 47 83 00 48 c7 c7 41 49 cc 81 31 c0 e8 98 47 83 00 31 d2 be 01 00 00 00 48 c7 c7 a0 49 f2 81 e8 ab 4a 0e 00 <0f> 0b 0f 0b 4c 89 e2 48 c7 c6 b3 e5 a0 81 48 c7 c7 5c 7a ca 81 
> >> [    1.461866] RIP  [<ffffffff8105c055>] __phys_addr+0x185/0x260
> >> [    1.468400]  RSP <ffffffff81e03cf8>
> >> [    1.472396] ---[ end trace b59b0f17341a4bc4 ]---

I'm having trouble linking that BUG_ON() with a line in Linus' tree.
What's the failing expression?

