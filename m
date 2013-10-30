Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab3J3DOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 23:14:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42288 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751379Ab3J3DOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 23:14:16 -0400
Message-ID: <52707986.1000200@free-electrons.com>
Date: Wed, 30 Oct 2013 04:14:14 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: mmarek@suse.cz, akpm@linux-foundation.org, joe@perches.com,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] scripts/checkkconfig.py: find unused Kconfig parameters
References: <1382592209-10246-1-git-send-email-michael.opdenacker@free-electrons.com> <20131029180619.GC3411@free.fr>
In-Reply-To: <20131029180619.GC3411@free.fr>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yann,

Thank you for your review!

On 10/29/2013 07:06 PM, Yann E. MORIN wrote:

> I guess all these grep spawning are what makes it slow.
>
> I wonder if it would not be possible to invert the loop (in pseudo
> Python code):
>
>     for f in all_interesting_files:
>         read f in memory
>         for s in all_symbols:
>             if symbol is in f:
>                 remove f from all_symbols
>                 break the inner-most loop
You probably meant "remove s from all_symbols", but I got it.
>
> This way:
>   - you scan the tree only once
>   - as soon as a symbol is matched, it is removed, thus decreasing
>     the amount of checks done in further loops.
This sounds like a very good idea, thanks! I hope to have time to
implement a mix of it and Michal's proposal later this week, or at least
next week.

Thanks again,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

