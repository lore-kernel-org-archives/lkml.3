Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760906Ab3JPQNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:13:47 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:53501 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760635Ab3JPQNp convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Wed, 16 Oct 2013 12:13:45 -0400
Message-Id: <525ED75402000078000FB95B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 16 Oct 2013 17:13:40 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "KVM list" <kvm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH, RFC] x86-64: properly handle FPU code/data
 selectors
References: <525E9BFF02000078000FB74E@nat28.tlf.novell.com>
 <CA+55aFwCe=t4dDbDhHTWhzA3zMEyyS2WSYBP2Sfe0eogGEBS1w@mail.gmail.com>
 <525ECEA102000078000FB906@nat28.tlf.novell.com>
 <CA+55aFybvU39HVUF4sON=Euieqy+Kqsby-DUU=8Gnpggm2fzjw@mail.gmail.com>
In-Reply-To: <CA+55aFybvU39HVUF4sON=Euieqy+Kqsby-DUU=8Gnpggm2fzjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.10.13 at 17:50, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, Oct 16, 2013 at 8:36 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>
>> In that case we use a 32-bit operand size [F]XRSTOR, and hence
>> the upper halves get treated as selectors, and the offsets get
>> zero-extended from the low halves, i.e. we preserve even more
>> state for such a 64-bit environment now too (albeit I doubt any
>> 64-bit code actually cares)
> 
> No, it does *not* preserve "more state".

So you're thinking of whenever the state gets copied out to some
(user) memory block, whereas the "more state" I wrote about
applies to what is stored in CPU registers. And I also said that
copying the state to use memory may require extra adjustments.
The question just is how to properly do that - without corrupting
state in the way you validly point out, but also without losing
state.

> It preserves *less* state, because the upper 32 bits of rip are now
> corrupted. Any 64-bit application that actually looks at the FP
> rip/rdp fields now get the WRONG VALUES.

But again - this isn't being done for ordinary 64-bit applications,
this is only happening for KVM guests. And there not being a
protocol for telling the caller whether a certain context hold
64-bit offsets or selector/offset pairs shouldn't be a reason to
think of a solution to the problem.

Jan

