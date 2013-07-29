Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3G2UYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 16:24:55 -0400
Received: from mail-gh0-f181.google.com ([209.85.160.181]:46951 "EHLO
	mail-gh0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab3G2UYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 16:24:54 -0400
Date: Mon, 29 Jul 2013 17:24:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tool: Fix symbol offset computation for some dsos
Message-ID: <20130729202447.GB1983@ghostprotocols.net>
References: <1375026512-45826-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375026512-45826-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Jul 28, 2013 at 09:48:32AM -0600, David Ahern escreveu:
> For some dsos (e.g., libc, libpthread, kernel modules) the symbol offset
> is huge. e.g.,
> 
> qemu-kvm 17238/17242 [007] 762235.640311:
>     ffffffff816288a1 __schedule+0x451 ([kernel.kallsyms])
>     ffffffff81629609 schedule+0x29 ([kernel.kallsyms])
>     ffffffffa00a6ded kvm_vcpu_block+0xffffffffa00a106d (/lib/modules/3.11.0-rc1+/kernel/arch/x86/kvm/kvm.ko)
>     ffffffffa00bae6b kvm_arch_vcpu_ioctl_run+0xffffffffa00a118b (/lib/modules/3.11.0-rc1+/kernel/arch/x86/kvm/kvm.ko)
>     ffffffffa00a4d7a kvm_vcpu_ioctl+0xffffffffa00a141a (/lib/modules/3.11.0-rc1+/kernel/arch/x86/kvm/kvm.ko)
>     ffffffff811a7bdb do_vfs_ioctl+0x8b ([kernel.kallsyms])
>     ffffffff811a80c1 sys_ioctl+0x91 ([kernel.kallsyms])
>     ffffffff81633182 system_call+0x72 ([kernel.kallsyms])
>         7f882a97af27 __GI___ioctl+0x7f882a891007 (/lib64/libc-2.14.90.so)
>            100000002 [unknown] ([unknown])
> 
> It seems to be maps with a non-0 start. Taking that into account the
> offsets are correct:

Humm, first reaction is that this should be solved by using one of the
->map/->unmap methods, no?

- Arnaldo
