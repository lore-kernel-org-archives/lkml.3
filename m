Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab3LLRCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:02:39 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40200 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674Ab3LLRCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:02:38 -0500
Date: Thu, 12 Dec 2013 17:02:34 +0000
From: Will Deacon <will.deacon@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/2] word-at-a-time: provide generic big-endian
 zero_bytemask implementation
Message-ID: <20131212170234.GJ12617@mudshark.cambridge.arm.com>
References: <1386702658-21430-1-git-send-email-will.deacon@arm.com>
 <1386702658-21430-2-git-send-email-will.deacon@arm.com>
 <CA+55aFzVrAQnmt7a_SKqOVyHrY55_uRP1yL4NGAXspeee6ZkRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzVrAQnmt7a_SKqOVyHrY55_uRP1yL4NGAXspeee6ZkRQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Dec 10, 2013 at 08:08:20PM +0000, Linus Torvalds wrote:
> Hmm. Did you try to time this?

I took it for a spin on a big-endian ARMv7 platform (32-bit) and the hashing is
around 40% faster.

> Also, I really have #ifdef's in code, and I think we'd be better off
> just exposing a function that does this
> 
> +#ifdef __BIG_ENDIAN
> +       mask = ~(~0ul >> tcount*8);
> +#else
>         mask = ~(~0ul << tcount*8);
> +#endif
> 
> thing. I think it would logically go together with zero_bytemask(),
> call it something like "bytemask_from_count()" or something. Hmm? It's
> basically just the reverse of "count_masked_bytes()", which we also
> have an abstraction for.

Yup, that's a good idea, I can probably just add something to dcache.h.
I'll spin a v2.

Cheers,

Will
