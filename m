Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3KTUgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:36:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40768 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab3KTUgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:36:39 -0500
Message-ID: <528D1D44.3000600@zytor.com>
Date: Wed, 20 Nov 2013 12:36:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [tip:x86/asm] x86-64, copy_user: Remove zero byte check before
 copy user buffer.
References: <1384634221-6006-1-git-send-email-fenghua.yu@intel.com>	<tip-f4cb1cc18f364d761d5614eb6293cccc6647f259@git.kernel.org>	<CA+55aFyFz_6oy8-1jb5Jzk+4VC5MLA5d0KbqhZxki0=+DmggBg@mail.gmail.com>	<528D0D61.1030902@linux.intel.com> <CA+55aFz9-bh=L8vf9qd3kx7wMtYqTtqx8YzULABX5reGtPBExw@mail.gmail.com>
In-Reply-To: <CA+55aFz9-bh=L8vf9qd3kx7wMtYqTtqx8YzULABX5reGtPBExw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 12:13 PM, Linus Torvalds wrote:
> On Wed, Nov 20, 2013 at 11:28 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>>
>>>       .section .fixup,"ax"
>>> 11:   lea (%rdx,%rcx,8),%rcx
>>> 12:   movl %ecx,%edx          /* ecx is zerorest also */
>>
>> -> Even if %rdx+%rcx*8 > 2^32 we end up truncating at 12: -- not that it
>> matters, since both arguments are prototyped as "unsigned" and therefore
>> the C compiler is supposed to guarantee the upper 32 bits are ignored.
> 
> Ahh. That was the one I thought was broken, but yes, while the upper
> bits of %rcx are calculated and not zeroed, they end up not actually
> getting used. So yeah, I'll believe it's correct.
> 

That being said, "lea (%rdx,%rcx,8),%ecx" (leal, as opposed to leaq) is
a perfectly legitimate instruction and actually one byte shorter.  The
big question is if some broken version of gas will choke on it.

	-hpa




