Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaHWBQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 21:16:03 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:44318 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaHWBQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 21:16:01 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1406757779.git.luto@amacapital.net>
References: <cover.1406757779.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 22 Aug 2014 18:15:39 -0700
Message-ID: <CALCETrW9uC25yCMHSGYag=52DH363T=ThRCdKPETfYou2boGRA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] x86: PER_CPU segment improvements
To: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 3:07 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> x86 sets up a per-cpu GDT entry so that vgetcpu can use LSL on it
> to determine the CPU number and node.

hpa, if/when you apply this, can you put it onto a fresh branch based
on something at least as new as 3.17-rc1?  It should apply cleanly
regardless, but the nine followup patches that I want to send also
depend on cleanup that isn't in tip/x86/vdso.

Thanks,
Andy

>
> This series, in little baby steps, cleans up that code and sets
> the accessed and 32-bit flags on the segment.
>
> The accessed bit prevents user code from setting the accessed bit
> on its own, and making the segment 32-bit prevents concerns about
> shenanigans involving CPU oddities with 16-bit data segments.
>
> The latter isn't a real problem -- if it were a 16-bit read/write
> segment, it could be used to bypass espfix64, but fortunately
> RO segments can't be loaded into SS.
>
> Changes from v1:
>  - Fix patch 2's changelog.
>  - Learn to spell "Not a system segment".
>
> Andy Lutomirski (3):
>   x86,vdso: Change the PER_CPU segment to use struct desc_struct
>   x86,vdso: Make the PER_CPU segment start out accessed
>   x86,vdso: Make the PER_CPU segment 32 bits
>
>  arch/x86/kernel/vsyscall_64.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>
> --
> 1.9.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
