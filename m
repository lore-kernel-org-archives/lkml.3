Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab3L0Xag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 18:30:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57425 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab3L0Xaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 18:30:35 -0500
Message-ID: <52BE0D89.3080405@zytor.com>
Date: Fri, 27 Dec 2013 15:30:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] speeding up the stat() family of system calls...
References: <CA+55aFxZ2u+M72u3HSD7TVY2+WRRi27pYC=_4Wawr5y1m8DfnQ@mail.gmail.com>	<20131224204625.GB20471@gmail.com> <CA+55aFzPBdbfKovMT8Edr4SmE2_=+OKJFac9XW2awegogTkVTA@mail.gmail.com> <52BD199A.8070607@zytor.com>
In-Reply-To: <52BD199A.8070607@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2013 10:09 PM, H. Peter Anvin wrote:
> On 12/26/2013 11:00 AM, Linus Torvalds wrote:
>>
>> Interestingly, looking at the cp_new_stat() profiles, the games we
>> play to get efficient range checking seem to actually hurt us. Maybe
>> it's the "sbb" that is just expensive, or maybe it's turning a (very
>> predictable) conditional branch into a data dependency chain instead.
>> Or maybe it's just random noise in my profiles that happened to make
>> those sbb's look bad.
>>
> 
> Much to my surprise, this patch adds almost 10K of text to an
> "allyesconfig" build.  I wouldn't have expected it.  I'll look at it
> some more tomorrow.
> 

Mystery solved... it is all code added by gcov &c because a new (inline)
function is added to the code base.  So it is fluff, not real.

	-hpa


