Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab3KLS7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:59:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37267 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab3KLS7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:59:13 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/3] Early use of boot service memory
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 12 Nov 2013 10:58:42 -0800
To: Jerry Hoemann <jerry.hoemann@hp.com>, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, matt.fleming@intel.com,
        yinghai@kernel.org, penberg@kernel.org, akpm@linux-foundation.org,
        linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
        vgoyal@redhat.com
CC: linux-kernel@vger.kernel.org
Message-ID: <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem with the crashkernel is that it by default has to sit very low in memory because the tools don't know if the crashkernel is me enough to sit anywhere.  That is the real fix.

Jerry Hoemann <jerry.hoemann@hp.com> wrote:
>Some platform have firmware that violates UEFI spec and access boot
>service
>code or data segments after the system has called Exit Boot Services.
>The call to efi_reserve_boot_services in setup_arch is a work around to
>avoid using boot service memory until after the kernel has done
>Set Virtual Map.
>
>However, this reservation fragments memory which can cause
>large allocations early in boot (e.g. crash kernel) to fail.
>
>This patch set extends the add_efi_memmap with an optional
>argument to specify that firmware "correctly" doesn't resuse
>boot services memory after Exit Boot Services.
>
>With this information, setup_arch avoids calling
>efi_reserve_boot_services and fragmenting memory.
>
>
>Jerry Hoemann (3):
>  efi: Early use of boot service memory
>  x86: avoid efi_reserve_boot_services
>  x86, efi: Early use of boot service memory
>
> Documentation/kernel-parameters.txt |  8 ++++++++
> arch/x86/kernel/setup.c             |  2 +-
> arch/x86/platform/efi/efi.c         | 13 +++++++++++--
> include/linux/efi.h                 |  1 +
> 4 files changed, 21 insertions(+), 3 deletions(-)

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
