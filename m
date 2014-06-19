Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaFSHbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 03:31:20 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:36612 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbaFSHbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 03:31:19 -0400
MIME-Version: 1.0
In-Reply-To: <1403154257-14591-1-git-send-email-lauraa@codeaurora.org>
References: <1403154257-14591-1-git-send-email-lauraa@codeaurora.org>
Date: Thu, 19 Jun 2014 09:31:17 +0200
X-Google-Sender-Auth: Ipv7drs43eHFsbzOhc5sRmMBdXw
Message-ID: <CAMuHMdW854ThGRUSVohvowJksTbVAzZ2cWmjBrsD804LqmBH8w@mail.gmail.com>
Subject: Re: [PATCH] of: Check for phys_addr_t overflows in early_init_dt_add_memory_arch
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Simon Horman <horms@verge.net.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laura,

On Thu, Jun 19, 2014 at 7:04 AM, Laura Abbott <lauraa@codeaurora.org> wrote:
> The common early_init_dt_add_memory_arch takes the base and size
> of a memory region as u64 types. The function never checks if
> the base and size can actually fit in a phys_addr_t which may
> be smaller than 64-bits. This may result in incorrect memory
> being passed to memblock_add if the memory falls outside the
> range of phys_addr_t. Add range checks for the base and size if
> phys_addr_t is smaller than u64.
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
> Geert, can you drop my other patch and give this a test to see if it fixes
> your bootup problem?

Thanks, works fine!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
