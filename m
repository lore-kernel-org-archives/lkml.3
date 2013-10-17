Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3JQKh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:37:56 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:50023 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3JQKhy convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:2>);
	Thu, 17 Oct 2013 06:37:54 -0400
Message-Id: <525FDA1C02000078000FBCC0@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 17 Oct 2013 11:37:48 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Gleb Natapov" <gleb@redhat.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "KVM list" <kvm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH, RFC] x86-64: properly handle FPU code/data
 selectors
References: <525E9BFF02000078000FB74E@nat28.tlf.novell.com>
 <CA+55aFwCe=t4dDbDhHTWhzA3zMEyyS2WSYBP2Sfe0eogGEBS1w@mail.gmail.com>
 <525ECEA102000078000FB906@nat28.tlf.novell.com>
 <CA+55aFybvU39HVUF4sON=Euieqy+Kqsby-DUU=8Gnpggm2fzjw@mail.gmail.com>
 <525ED75402000078000FB95B@nat28.tlf.novell.com>
 <20131017092727.GN15657@redhat.com>
 <525FCB0D02000078000FBBCF@nat28.tlf.novell.com>
 <20131017094146.GP15657@redhat.com>
 <525FCF5802000078000FBC04@nat28.tlf.novell.com>
 <20131017102354.GR15657@redhat.com>
In-Reply-To: <20131017102354.GR15657@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.10.13 at 12:23, Gleb Natapov <gleb@redhat.com> wrote:
> On Thu, Oct 17, 2013 at 10:51:52AM +0100, Jan Beulich wrote:
>> >>> On 17.10.13 at 11:41, Gleb Natapov <gleb@redhat.com> wrote:
>> > KVM obviously knows the complete state of virtual CPU. It can figure the
>> > situation above by looking at CS descriptor, not need to check
>> > is_long_mode() at all. Here is how emulator does it:
>> 
>> And again - no: The last floating point operation may have
>> happened in 32-bit user mode context, while the state saving
>> may happen when the guest is already back in 64-bit kernel
>> mode.
>> 
> Hmm, OK so the scenarios you are talking about is:
>  1. Guest's 32bit process uses FPU
>  2. Guest switch to 64bit kernel.
>  3. Before guest's kernel saves 32bit process's FPU state VMEXIT happens
>  4. KVM need to save FPU but it does not know what mode it is in
> Correct? 

Yes.

> KVM gives FPU to a guest lazily, meaning that on a first FPU use #NM
> (intercepted by KVM) happens at which point FPU is granted to a guest.
> KVM can check what mode CPU was in at this point and use this info
> while saving FPU. But there is additional optimization that will prevent
> this from working for all cases: when FPU is granted to a guest KVM
> disabled CR0.TS/#NM intercepts, so guest is free to switch FPU from
> 32bit to 64bit mode without KVM knowing. Disabling this optimization
> will make FP intensive workload slow in a guest.

Not sure what you're trying to tell me with this explanation.

Jan

