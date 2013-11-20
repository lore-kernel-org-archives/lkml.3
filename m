Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab3KTTNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 14:13:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39753 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718Ab3KTTNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 14:13:13 -0500
Message-ID: <528D09B4.9040805@zytor.com>
Date: Wed, 20 Nov 2013 11:12:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [tip:x86/asm] x86-64, copy_user: Remove zero byte check before
 copy user buffer.
References: <1384634221-6006-1-git-send-email-fenghua.yu@intel.com>	<tip-f4cb1cc18f364d761d5614eb6293cccc6647f259@git.kernel.org>	<CA+55aFyFz_6oy8-1jb5Jzk+4VC5MLA5d0KbqhZxki0=+DmggBg@mail.gmail.com>	<528AEB27.2070404@zytor.com> <CA+55aFywiJf1TiSaXSZNkUpGpgtJa1pmZa7E+BOJafvTQCuzdA@mail.gmail.com>
In-Reply-To: <CA+55aFywiJf1TiSaXSZNkUpGpgtJa1pmZa7E+BOJafvTQCuzdA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 11:38 AM, Linus Torvalds wrote:
> On Mon, Nov 18, 2013 at 8:37 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> Do you have a preference:
>>
>> 1. Considering the 32-bit truncation incidental (take it or leave it);
>> 2. Require the 32-bit truncation, or
>> 3. Get rid of it completely?
> 
> I don't have a huge preference, but I hate the current situation (with
> Fenghua's patch) where it's not consistent. One path uses just 32-bits
> of the count (thanks to the "mov %edx,%ecx") while another path uses
> 64 bits.
> 
> One or the other, but not a mixture of both.
> 
> And only tangentially related to this: I do think that we could be
> stricter about the count. Make it oops if the high bits are set,
> rather than overwrite a lot of memory. So I would not be adverse to
> limiting the count to 31 bits (or even less) explicitly, and thus
> making the while 32-vs-64 bit issue moot.
> 

I guess the question is if we want to spend the extra cycles on a test
and branch.  For now I suggest that we just put back the truncation in
the form of a movl instruction.

	-hpa


