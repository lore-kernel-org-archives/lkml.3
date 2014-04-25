Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075AbaDYAwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:52:54 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:65269 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaDYAww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:52:52 -0400
MIME-Version: 1.0
In-Reply-To: <1396646870-29695-1-git-send-email-rabin@rab.in>
References: <1396646870-29695-1-git-send-email-rabin@rab.in>
Date: Thu, 24 Apr 2014 17:52:51 -0700
X-Google-Sender-Auth: BQDTl-XScYIkYD6hJ9XUL15-a-I
Message-ID: <CAD=FV=UuYpc-kFMymy7P_mL+iYziKqJii8=32P6kMELDFnC1pQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm: fixmap: implement __set_fixmap()
From: Doug Anderson <dianders@chromium.org>
To: Rabin Vincent <rabin@rab.in>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Laura Abbott <lauraa@codeaurora.org>, Jon Medhurst <tixy@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rabin,

On Fri, Apr 4, 2014 at 2:27 PM, Rabin Vincent <rabin@rab.in> wrote:
> This is used from set_fixmap() and clear_fixmap() via
> asm-generic/fixmap.h.
>
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
> Needs "arm: use generic fixmap.h", available in linux-next.
>
>  arch/arm/include/asm/fixmap.h | 2 ++
>  arch/arm/mm/mmu.c             | 7 +++++++
>  2 files changed, 9 insertions(+)
>
> diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
> index 68ea615..55ed076 100644
> --- a/arch/arm/include/asm/fixmap.h
> +++ b/arch/arm/include/asm/fixmap.h
> @@ -23,6 +23,8 @@ enum fixed_addresses {
>         __end_of_fixed_addresses
>  };
>
> +void __set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t prot);

nit: I think you should use phys_addr_t for the physical address, right?

void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot);


...I'm no expert at fixmap, but otherwise this looks pretty reasonable to me.

-Doug
