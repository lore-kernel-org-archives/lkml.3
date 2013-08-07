Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab3HGXyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 19:54:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256Ab3HGXyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 19:54:24 -0400
Date: Wed, 7 Aug 2013 16:54:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Use gcc alias instead of assembler aliases for syscalls
Message-Id: <20130807165421.0b60ee9acbd1571426188448@linux-foundation.org>
In-Reply-To: <1375740575-7640-1-git-send-email-andi@firstfloor.org>
References: <1375740575-7640-1-git-send-email-andi@firstfloor.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Aug 2013 15:09:35 -0700 Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Use standard gcc __attribute__((alias(foo))) to define
> the syscall aliases instead of custom assembler macros.
> 
> This is far cleaner, and also fixes my LTO kernel build.
> 

This makes my x86_64 allmodconfig build emit screenfuls of

...
WARNING: "alloc_pages_current" [drivers/block/brd.ko] has no CRC!
WARNING: "alloc_pages_current" [drivers/base/firmware_class.ko] has no CRC!
WARNING: "schedule_timeout" [drivers/atm/solos-pci.ko] has no CRC!
WARNING: "schedule_timeout" [drivers/atm/iphase.ko] has no CRC!
WARNING: "schedule_timeout" [drivers/atm/he.ko] has no CRC!
WARNING: "schedule_timeout" [drivers/acpi/sbshc.ko] has no CRC!
WARNING: "schedule_timeout" [drivers/acpi/acpi_ipmi.ko] has no CRC!
WARNING: "alloc_pages_current" [crypto/async_tx/raid6test.ko] has no CRC!
WARNING: "alloc_pages_current" [crypto/async_tx/async_pq.ko] has no CRC!
WARNING: "alloc_pages_current" [crypto/algif_skcipher.ko] has no CRC!
WARNING: "schedule_timeout" [crypto/algif_skcipher.ko] has no CRC!
WARNING: "sock_register" [crypto/af_alg.ko] has no CRC!
WARNING: "task_nice" [block/cfq-iosched.ko] has no CRC!
WARNING: "perf_event_create_kernel_counter" [arch/x86/oprofile/oprofile.ko] has no CRC!
WARNING: "alloc_pages_current" [arch/x86/kvm/kvm.ko] has no CRC!
WARNING: "perf_event_create_kernel_counter" [arch/x86/kvm/kvm.ko] has no CRC!
WARNING: "alloc_pages_current" [arch/x86/kvm/kvm-amd.ko] has no CRC!
WARNING: "schedule_timeout" [arch/x86/kernel/cpu/mcheck/mce-inject.ko] has no CRC!
WARNING: "schedule_timeout" [arch/x86/kernel/apm.ko] has no CRC!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


Unexpected, but I checked it a couple of times.
