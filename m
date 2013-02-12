Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab3BLRfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:35:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51970 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404Ab3BLRfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:35:53 -0500
Message-ID: <511A7D50.9090804@zytor.com>
Date: Tue, 12 Feb 2013 09:35:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user()
 warnings
References: <20130209110031.GA17833@n2100.arm.linux.org.uk> <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org> <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com> <5119C34B.70207@zytor.com> <CAMe9rOrTLGJvO+Z8kCG3gmOuW-Yq2Ex9WMfJZ5wmZcbz+zm94Q@mail.gmail.com> <CA+55aFwMr8pDfj+wuv=-tUFqZQOhnqkwC7tVq-S=4MGGWiqz1A@mail.gmail.com> <511A7892.4020407@zytor.com> <CA+55aFz=OnntmRvi6geuL7ccC6ncwQ7NvURDcwu87BkpS3H0TQ@mail.gmail.com>
In-Reply-To: <CA+55aFz=OnntmRvi6geuL7ccC6ncwQ7NvURDcwu87BkpS3H0TQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 09:32 AM, Linus Torvalds wrote:
> On Tue, Feb 12, 2013 at 9:14 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> No, I think what he is talking about it this bit:
>
> Ok, I agree that the bitfield code actually looks cleaner.
>
> That said, maybe gcc has an easier time using a few odd builtins and
> magic typeof's. But at least the bitfield trick looks half-way
> portable..
>

On the other hand, it still uses two gcc extensions: long long bitfields 
and typeof.

I'll see what kind of code we get with the macro.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

