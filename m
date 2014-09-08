Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaIHT6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:58:13 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:61718 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbaIHT6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:58:12 -0400
Date: Mon, 8 Sep 2014 20:58:09 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Mark Salter <msalter@redhat.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, matt.fleming@intel.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] efi/arm64: fix fdt-related memory reservation
Message-ID: <20140908195809.GB18582@console-pimps.org>
References: <1410183102-6969-1-git-send-email-msalter@redhat.com>
 <1410195668-9975-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410195668-9975-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep, at 01:01:08PM, Mark Salter wrote:
> Commit 86c8b27a01cf:
>  "arm64: ignore DT memreserve entries when booting in UEFI mode
> 
> prevents early_init_fdt_scan_reserved_mem() from being called for
> arm64 kernels booting via UEFI. This was done because the kernel
> will use the UEFI memory map to determine reserved memory regions.
> That approach has problems in that early_init_fdt_scan_reserved_mem()
> also reserves the FDT itself and any node-specific reserved memory.
> By chance of some kernel configs, the FDT may be overwritten before
> it can be unflattened and the kernel will fail to boot. More subtle
> problems will result if the FDT has node specific reserved memory
> which is not really reserved.
> 
> This patch has the UEFI stub remove the memory reserve map entries
> from the FDT as it does with the memory nodes. This allows
> early_init_fdt_scan_reserved_mem() to be called unconditionally
> so that the other needed reservations are made.
> 
> Change from v1:
>   * Acks added
>   * Fixed loop logic to remove reserved regions
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> ---
>  arch/arm64/mm/init.c               |  3 +--
>  drivers/firmware/efi/libstub/fdt.c | 10 +++++++++-
>  2 files changed, 10 insertions(+), 3 deletions(-)

Thanks Mark, queued up in 'urgent'.

-- 
Matt Fleming, Intel Open Source Technology Center
