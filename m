Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab3BDFqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 00:46:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55753 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab3BDFqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 00:46:21 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20130204052725.GA13909@pd.tnic>
References: <1359908079-10469-1-git-send-email-bp@alien8.de> <1359908079-10469-5-git-send-email-bp@alien8.de> <510EF65D.4020602@zytor.com> <20130204052725.GA13909@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 4/4] x86, 32-bit: Drop new_cpu_data
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 03 Feb 2013 21:44:02 -0800
To: Borislav Petkov <bp@alien8.de>
CC: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Message-ID: <562c8dd4-6665-4365-8eb4-33e77e6f6798@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

boot_cpu_data is ok for things that are indeed universally valid across.  That does not include CPUID level, for one.

Borislav Petkov <bp@alien8.de> wrote:

>On Sun, Feb 03, 2013 at 03:44:29PM -0800, H. Peter Anvin wrote:
>> On 02/03/2013 08:14 AM, Borislav Petkov wrote:
>> >From: Borislav Petkov <bp@suse.de>
>> >
>> >We copy it to boot_cpu_data anyway so use boot_cpu_data from the
>get-go.
>> >
>> 
>> Hmm... this is the only part of this patchset I feel skeptical
>> towards.  Overall, a lot of the early SMP code went way out of its
>> way to have zero impact on the !CONFIG_SMP case, but that was a long
>> time ago. Nowadays what we really should have is cpu_data being a
>> percpu variable separate from boot_cpu_data (which is really
>> "all_cpu_data") even on UP.
>
>Hmmkay.
>
>My thought vector here was to use boot_cpu_data to cache stuff
>here which is universally valid on the current system, i.e. like
>all_cpu_data. IOW, cache here family (model and stepping could differ,
>as we've come to realize over the years :)) vendor (btw, X86_VENDOR is
>unused) CPUID_EAX(0) level, capability, etc and use them later instead
>of querying them again.
>
>So, so early and in this case, we're saving CPU data which is valid for
>all CPUs on the system and thus it belongs into boot_cpu_data, right?
>
>And then, btw, that data could've been used in verify_cpu.S only if the
>damn thing wasn't being used in arch/x86/boot/...
>
>> Another cleanup desperately needed in this area is a bitvector for
>> bugs in addition to features.
>
>Yeah, c->x86_unfeatures! :-)
>
>> In fact, I kind of suspect we should make it the *same* bitvector
>> (different words) so we cpu_has(X) works on both without confusion
>> (just put the BUGS at the end; it means that if we add feature words
>> the bug numbers will shift but that is okay.)
>>
>> I actually mean to do this when I did the CPU feature vector stuff
>> over 10 years ago, but never got around to it... and it still has
>> never gotten done.
>>
>> The difference between bugs and features, of course, is that the
>> former should be combined across CPUs with an OR whereas the latter
>> get combined with an AND.
>
>Yeah, that should be pretty easy to do with the current machinery
>already in place. I'll take a look.
>
>Thanks.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
