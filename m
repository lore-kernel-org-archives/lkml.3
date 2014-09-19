Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbaISLES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:04:18 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38480 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaISLEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:04:16 -0400
Date: Fri, 19 Sep 2014 12:04:12 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Glenn P. Williamson" <glenn.p.williamson@intel.com>
Subject: Re: [PATCH 2/6] x86/efi: use efi_memory_descriptor in convenience
 functions
Message-ID: <20140919110412.GF18635@console-pimps.org>
References: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
 <1410633376-8822-3-git-send-email-ricardo.neri-calderon@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410633376-8822-3-git-send-email-ricardo.neri-calderon@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Sep, at 11:36:12AM, Ricardo Neri wrote:
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 64ecbb5..29c85fe 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -206,29 +206,23 @@ subsys_initcall(efisubsys_init);
>   */
>  void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
>  {
> -	struct efi_memory_map *map;
> -	void *p;
> -	map = efi.memmap;
> -	if (!map)
> +	efi_memory_desc_t *md;
> +
> +	md = efi_memory_descriptor(phys_addr);

Whoops. This change is causing the following build errors on ia64,

/home/build/git/efi/arch/ia64/kernel/efi.c:722:1: error: static declaration of ‘efi_memory_descriptor’ follows non-static declaration
 efi_memory_descriptor (unsigned long phys_addr)
 ^
In file included from /home/build/git/efi/arch/ia64/kernel/efi.c:32:0:
/home/build/git/efi/include/linux/efi.h:870:27: note: previous declaration of ‘efi_memory_descriptor’ was here
 extern efi_memory_desc_t *efi_memory_descriptor(unsigned long phys_addr);
                           ^

and on arm64...

drivers/built-in.o: In function `efi_lookup_mapped_addr':
:(.text+0xb0e0): undefined reference to `efi_memory_descriptor'

-- 
Matt Fleming, Intel Open Source Technology Center
