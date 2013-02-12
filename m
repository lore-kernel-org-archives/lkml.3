Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761130Ab3BLEwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 23:52:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46008 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757798Ab3BLEv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 23:51:59 -0500
Message-ID: <5119CA54.6050204@zytor.com>
Date: Mon, 11 Feb 2013 20:51:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org, "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user()
 warnings
References: <20130209110031.GA17833@n2100.arm.linux.org.uk> <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org> <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com> <5119C34B.70207@zytor.com> <CA+55aFx7KA-inJJog0v_cAsU0S2FeAN61pyvoUO8pbaxEAWFag@mail.gmail.com> <CA+55aFzmWfOQzVMPJUah3oEsn-aaeN5qtO=7P3MQUfLZmEFJZA@mail.gmail.com>
In-Reply-To: <CA+55aFzmWfOQzVMPJUah3oEsn-aaeN5qtO=7P3MQUfLZmEFJZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 08:47 PM, Linus Torvalds wrote:
> On Mon, Feb 11, 2013 at 8:42 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> But I don't see anything fundamentally wrong with it. Certainly it
>> looks much better than the disgusting and warning-prone
>>
>>      unsigned long long __val_gu8
>>
>> thing.
>
> Oh. I just realized. That was your _baseline_ in the comparisons, wasn't it?
>
> Can you please make the baseline be the current mainline git version
> of <asm/uaccess.h>, not the first "unsigned long long __val_gu8"
> version of the 64-bit get_user()?
>
> Because we should compare against the straightforward code, not the
> one that could have messed things up already..
>

No, the baseline was x86/mm before *any* of the 64-bit get_user() stuff 
were applied.

Very small differences can often be slight differences in strings (which 
end up in .rodata and thus count as text as far as size is concerned ... 
things like pathnames and dates.)  I am unclear about why the i386-pae 
build case stood out like that.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

