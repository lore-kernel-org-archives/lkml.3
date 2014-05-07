Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbaEGOGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:06:05 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62422 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243AbaEGOGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:06:03 -0400
Date: Wed, 7 May 2014 16:05:58 +0200
From: Vincent Donnefort <vdonnefort@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.15-rc3] BUG: null ptr dereference in
 ichx_gpio_request_regions()
Message-ID: <20140507140558.GA26294@ks3318809.kimsufi.com>
References: <536A339D.9030606@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536A339D.9030606@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

On Wed, May 07, 2014 at 09:22:37AM -0400, Peter Hurley wrote:
> Booting 3.15-rc3, I get this BUG when loading gpio_ich:
> 
>  BUG: unable to handle kernel NULL pointer dereference at           (null)
>  IP: [<ffffffffa042339c>] ichx_gpio_probe+0x28c/0x3d0 [gpio_ich]
>  usbcore: registered new interface driver btusb
>  PGD 2b04aa067 PUD 2af912067 PMD 0
>  Oops: 0000 [#1] PREEMPT SMP
>  Modules linked in: gpio_ich(+) btusb bluetooth psmouse snd i5400_edac ....
>  CPU: 3 PID: 1217 Comm: modprobe Not tainted 3.15.0-rc3+wip-xeon #rc3+wip
>  Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A11 04/30/2012
>  task: ffff8802ae8448f0 ti: ffff8802b0d74000 task.ti: ffff8802b0d74000
>  RIP: 0010:[<ffffffffa042339c>]  [<ffffffffa042339c>] ichx_gpio_probe+0x28c/0x3d0 [gpio_ich]
>  RSP: 0018:ffff8802b0d75b78  EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>  RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff81c378a0
>  RBP: ffff8802b0d75bb8 R08: 0000000000000000 R09: ffff880036a0e2c8
>  R10: 0000000000005dc0 R11: 8000000000000000 R12: ffff880036a0e000
>  R13: ffff8800bad62bc0 R14: 0000000000000003 R15: 0000000000000000
>  FS:  00007fb9d38fa700(0000) GS:ffff8802bfcc0000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000000 CR3: 00000002af445000 CR4: 00000000000007e0
>  Stack:
>   ffff8802b0d75b98 ffff880036a0e010 ffff880036a0e020 ffff880036a0e010
>   ffffffffa0425028 ffffffffa0425028 0000000000000000 0000000000000001
>   ffff8802b0d75be8 ffffffff814793f2 ffff8802b0d75ca8 ffff880036a0e010
>  Call Trace:
>   [<ffffffff814793f2>] platform_drv_probe+0x32/0x80
>   [<ffffffff8147784b>] driver_probe_device+0x8b/0x3a0
>   [<ffffffff81477c0b>] __driver_attach+0xab/0xb0
>   [<ffffffff81477b60>] ? driver_probe_device+0x3a0/0x3a0
>   [<ffffffff8147586d>] bus_for_each_dev+0x5d/0xa0
>   [<ffffffff8147727e>] driver_attach+0x1e/0x20
>   [<ffffffff81476dd4>] bus_add_driver+0x124/0x250
>   [<ffffffffa029a000>] ? 0xffffffffa0299fff
>   [<ffffffff81478314>] driver_register+0x64/0xf0
>   [<ffffffffa029a000>] ? 0xffffffffa0299fff
>   [<ffffffff8147926a>] __platform_driver_register+0x4a/0x50
>   [<ffffffffa029a017>] ichx_gpio_driver_init+0x17/0x1000 [gpio_ich]
>   [<ffffffff8100032a>] do_one_initcall+0xda/0x180
>   [<ffffffff8103e733>] ? set_memory_nx+0x43/0x50
>   [<ffffffff816ffeec>] ? set_section_ro_nx+0x6d/0x75
>   [<ffffffff810cc9f9>] load_module+0x1d79/0x2770
>   [<ffffffff810c8690>] ? unset_module_init_ro_nx+0x80/0x80
>   [<ffffffff81172f80>] ? __vmalloc_node_range+0x170/0x250
>   [<ffffffff810cd479>] ? SyS_init_module+0x89/0x100
>   [<ffffffff810cd4a2>] SyS_init_module+0xb2/0x100
>   [<ffffffff81719ad2>] system_call_fastpath+0x16/0x1b
>  Code: c7 05 fd 1f 00 00 40 51 42 a0 e9 00 fe ff ff 48 8b 05 f1 1f 00 00 45 31 c0 48 c7 c7 a0 78 c3 81 48 8b 48 08 48 8b 50 10 48 63 c3 <0f> b6 34 01 4c 89 c9 0f b6 14 1a 49 03 75 00 4c 89 4d c8 e8 ec
>  RIP  [<ffffffffa042339c>] ichx_gpio_probe+0x28c/0x3d0 [gpio_ich]
>   RSP <ffff8802b0d75b78>
>  CR2: 0000000000000000
> 
> 
> This is almost certainly caused by the uninitialized regs ptr
> in the ich6_desc struct (i3100_desc struct has the same problem)
> introduced in this commit:
> 
> commit bb62a35bd5d96e506af0ea8dd145480b9172a2a6
> Author: Vincent Donnefort <vdonnefort@gmail.com>
> Date:   Fri Feb 14 15:01:56 2014 +0100
> 
>     gpio: ich: Add support for multiple register addresses
> 
>     This patch introduces regs and reglen pointers which allow a chipset to have
>     register addresses differing from ICH ones.
> 
>     Acked-by: Linus Walleij <linus.walleij@linaro.org>
>     Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>
>     Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 

Yes indeed, this must be linked to this thread https://lkml.org/lkml/2014/4/15/292 

Regards,
Vincent.

> 
> The relevant excerpts from the mixed listing are:
> 
> 0000000000000110 <ichx_gpio_probe>:
> 
> <...snip...>
> 
> 	for (i = 0; i < ARRAY_SIZE(ichx_priv.desc->regs[0]); i++) {
> 		if (!(use_gpio & (1 << i)))
> 			continue;
> 		if (!request_region(
>  380:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 387 <ichx_gpio_probe+0x277>
> 			383: R_X86_64_PC32	.bss+0xb4
>  387:	45 31 c0             	xor    %r8d,%r8d
>  38a:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
> 			38d: R_X86_64_32S	ioport_resource
>  391:	48 8b 48 08          	mov    0x8(%rax),%rcx
>  395:	48 8b 50 10          	mov    0x10(%rax),%rdx
>  399:	48 63 c3             	movslq %ebx,%rax
>  39c:	0f b6 34 01          	movzbl (%rcx,%rax,1),%esi       <===== FAULTING INSTN
>  3a0:	4c 89 c9             	mov    %r9,%rcx
>  3a3:	0f b6 14 1a          	movzbl (%rdx,%rbx,1),%edx
>  3a7:	49 03 75 00          	add    0x0(%r13),%rsi
>  3ab:	4c 89 4d c8          	mov    %r9,-0x38(%rbp)
>  3af:	e8 00 00 00 00       	callq  3b4 <ichx_gpio_probe+0x2a4>
> 			3b0: R_X86_64_PC32	__request_region-0x4
>  3b4:	4c 8b 4d c8          	mov    -0x38(%rbp),%r9
>  3b8:	48 85 c0             	test   %rax,%rax
>  3bb:	0f 85 17 fe ff ff    	jne    1d8 <ichx_gpio_probe+0xc8>
> 	}
> 	return 0;
> 
> request_err:
> 	/* Clean up: release already requested regions, if any */
> 	for (i--; i >= 0; i--) {
>  3c1:	41 83 ef 01          	sub    $0x1,%r15d
>  3c5:	41 83 ff ff          	cmp    $0xffffffff,%r15d
>  3c9:	0f 84 d1 00 00 00    	je     4a0 <ichx_gpio_probe+0x390>
> 		if (!(use_gpio & (1 << i)))
>  3cf:	45 0f a3 fe          	bt     %r15d,%r14d
>  3d3:	73 ec                	jae    3c1 <ichx_gpio_probe+0x2b1>
> 
> 
> Regards,
> Peter Hurley

