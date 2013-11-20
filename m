Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3KTUNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:13:18 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:47014 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab3KTUNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:13:16 -0500
MIME-Version: 1.0
In-Reply-To: <528D0D61.1030902@linux.intel.com>
References: <1384634221-6006-1-git-send-email-fenghua.yu@intel.com>
	<tip-f4cb1cc18f364d761d5614eb6293cccc6647f259@git.kernel.org>
	<CA+55aFyFz_6oy8-1jb5Jzk+4VC5MLA5d0KbqhZxki0=+DmggBg@mail.gmail.com>
	<528D0D61.1030902@linux.intel.com>
Date: Wed, 20 Nov 2013 12:13:15 -0800
X-Google-Sender-Auth: LNyyuppCW_N2pU7ggBswhM26v-g
Message-ID: <CA+55aFz9-bh=L8vf9qd3kx7wMtYqTtqx8YzULABX5reGtPBExw@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86-64, copy_user: Remove zero byte check before
 copy user buffer.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 11:28 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>
>>       .section .fixup,"ax"
>> 11:   lea (%rdx,%rcx,8),%rcx
>> 12:   movl %ecx,%edx          /* ecx is zerorest also */
>
> -> Even if %rdx+%rcx*8 > 2^32 we end up truncating at 12: -- not that it
> matters, since both arguments are prototyped as "unsigned" and therefore
> the C compiler is supposed to guarantee the upper 32 bits are ignored.

Ahh. That was the one I thought was broken, but yes, while the upper
bits of %rcx are calculated and not zeroed, they end up not actually
getting used. So yeah, I'll believe it's correct.

               Linus
