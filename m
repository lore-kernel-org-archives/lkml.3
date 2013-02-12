Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933939Ab3BLS6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:58:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52655 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933865Ab3BLS6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:58:51 -0500
Message-ID: <511A90D0.5010708@zytor.com>
Date: Tue, 12 Feb 2013 10:58:24 -0800
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
References: <20130209110031.GA17833@n2100.arm.linux.org.uk> <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org> <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com> <5119C34B.70207@zytor.com> <CAMe9rOrTLGJvO+Z8kCG3gmOuW-Yq2Ex9WMfJZ5wmZcbz+zm94Q@mail.gmail.com> <CA+55aFwMr8pDfj+wuv=-tUFqZQOhnqkwC7tVq-S=4MGGWiqz1A@mail.gmail.com> <511A7892.4020407@zytor.com> <CAMe9rOrqDjBQjLyDRWJqRKdzQf1zMXHwXxFk2DekC+EeCHa8UA@mail.gmail.com> <511A8922.6050908@zytor.com> <CA+55aFympY-ie_SiMCnsE9emu_AS2zYCNJV=yp95Vu4tbPDoXA@mail.gmail.com>
In-Reply-To: <CA+55aFympY-ie_SiMCnsE9emu_AS2zYCNJV=yp95Vu4tbPDoXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 10:46 AM, Linus Torvalds wrote:
> On Tue, Feb 12, 2013 at 10:25 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> I just thought up this variant, I'm about to test it, but H.J., do you
>> see any problems with it?
>
> Looks good to me. And we already use __builtin_choose_expr(), so it's
> "portable". And it should avoid all the potential issues with
> bitfields (rmk already pointed out how bitfields don't work well with
> the ARM model, who knows what other pitfalls bitfield code generation
> could have)
>
> I wonder if we could/should eventually do some of the sizeof() in
> generic code - not have these magic things duplicated in all the
> architectures, just have the architectures specify the raw typed
> details (__copy_to_user_4() etc). So cross-platform portability could
> be a good thing. That's a separate discussion, though, and possibly
> not worth it.
>

I'm getting rid of the switch statement in the variant that I'm 
currently testing, so that would probably be undesirable.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

