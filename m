Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaKZEjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 23:39:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbaKZEjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 23:39:08 -0500
Message-ID: <5475596A.9010301@suse.com>
Date: Wed, 26 Nov 2014 05:39:06 +0100
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <20141114213124.GB3344@redhat.com>	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>	<20141115213405.GA31971@redhat.com>	<20141116014006.GA5016@redhat.com>	<CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>	<20141126002501.GA11752@redhat.com> <CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
In-Reply-To: <CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 02:48 AM, Linus Torvalds wrote:
> On Tue, Nov 25, 2014 at 4:25 PM, Dave Jones <davej@redhat.com> wrote:
>>
>> The reason I'm checking in at this point, is that I'm starting to see different
>> bugs at this point, so I don't know if I can call this good or bad, unless
>> someone has a fix for what I'm seeing now.
>
> Hmm. The three last "bad" biisects are all just 3.17-rc1 plus staging fixes.
>
>> Reminiscent of a bug a couple releases ago. Processes about to exit, but stuck
>> in the kernel continuously faulting..
>> http://codemonkey.org.uk/junk/weird-hang.txt
>> The one I'm thinking of got fixed way before 3.17 though.
>
> Well, the staging tree was based on that 3.17-rc1 tree, so it may well
> have the bug without the fix.
>
> You have also marked 3.18-rc1 bad *twice*, along with the network
> merge, and the tty merge. That's just odd. But it doesn't make the
> bisect wrong, it just means that you fat-fingered thing and marked the
> same thing bad a couple of times.
>
> Nothing to worry about, unless it's a sign of early Parkinsons...
>
>> Does that trace ring a bell of something else I could try on top of
>> each bisection point ?
>
> Hmm.
>
> Smells somewhat like the "pipe/page fault oddness" bug you reported.
>
> That one caused endless page faults on fault_in_pages_writeable()
> because of a page table entry that the VM thought was present, but the
> CPU thought was missing.
>
> That caused the whole "pte_protnone()" thing, and trying to get rid of
> the PTE_NUMA bit, but those patches have *not* been merged. And you
> were ever able to reproduce it., so we left it as pending.
>
> But if you actually really think that the bisect log you posted is
> real and true and actually is the bug you're chasing, I have bad news
> for you: do a "gitk --bisect", and you'll see that all the remaining
> commits are just to staging drivers.
>
> So that would either imply you have some staging driver (unlikely), or
> more likely that 3.17 really already has the problem, it's just that
> it needs some particular code alignment or phase of the moon or
> something to trigger.

I COULD trigger it with 3.17. Took much longer, but I've seen it once.
And from Xen hypervisor data it was clear it was the same bug (cpu
spinning in pmd_lock()).


Juergen

