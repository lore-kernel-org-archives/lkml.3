Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3HAU1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:27:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38388 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab3HAU1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:27:05 -0400
Message-ID: <51FAC481.2050905@zytor.com>
Date: Thu, 01 Aug 2013 13:26:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Leif Lindholm <leif.lindholm@linaro.org>
CC: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, matt.fleming@intel.com, tglx@linutronix.de,
        patches@linaro.org, "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH 0/4] Make commonly useful UEFI functions common
References: <1375202858-28470-1-git-send-email-leif.lindholm@linaro.org>
In-Reply-To: <1375202858-28470-1-git-send-email-leif.lindholm@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 09:47 AM, Leif Lindholm wrote:
> This set breaks out some common code from x86/ia64 EFI support
> code and puts it into drivers/firmware/efi.
> 
> First it takes the definition of the global "efi" data structure
> and moves it into global efi.c. Then it implements a common version
> of efi_config_init().
> 
> Secondly it breaks the efi_lookup_mapped_addr() function out of x86
> and places it in global efi.c, for shared use with future ARM
> patches.
> 
> IA64 code compile tested only.
> 
> Pardon the delay in getting this out - back to back conferences
> followed by a bad case of the man flu.
> 
> Leif Lindholm (4):
>   efi: provide a generic efi_config_init()
>   efi: x86: use common code for (U)EFI configuration scanning
>   efi: ia64: use common code for (U)EFI configuration scanning
>   efi: x86: make efi_lookup_mapped_addr() a common function
> 
>  arch/ia64/include/asm/io.h  |    1 +
>  arch/ia64/kernel/efi.c      |   54 ++++-------------
>  arch/x86/platform/efi/efi.c |  124 +++------------------------------------
>  drivers/firmware/efi/efi.c  |  136 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h         |    7 +++
>  5 files changed, 163 insertions(+), 159 deletions(-)
> 

Matt, I assume you're picking this up once the missing bits are plugged
in, right?

	-hpa

