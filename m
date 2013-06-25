Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3FYSmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:42:10 -0400
Received: from relay3.sgi.com ([192.48.152.1]:52639 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753475Ab3FYSmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:42:07 -0400
Message-ID: <51C9E47B.3020302@sgi.com>
Date: Tue, 25 Jun 2013 11:42:03 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Nathan Zimmer <nzimmer@sgi.com>, Robin Holt <holt@sgi.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <20130621165142.GA32125@kroah.com> <51C48745.9030304@zytor.com> <CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com> <20130621185056.GA23473@kroah.com> <51C4C5F3.3050800@sgi.com> <CAE9FiQXaUNbK9+g-7j6gfvLrSvUJFWWKapDv658LPe4VfbH=tQ@mail.gmail.com> <51C9D4ED.5070805@sgi.com> <CAE9FiQV+3gEZKPC0sthniGKceSfxV942m+DbyGHa-93Uj6wd1w@mail.gmail.com>
In-Reply-To: <CAE9FiQV+3gEZKPC0sthniGKceSfxV942m+DbyGHa-93Uj6wd1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 6/25/2013 11:38 AM, Yinghai Lu wrote:
> On Tue, Jun 25, 2013 at 10:35 AM, Mike Travis <travis@sgi.com> wrote:
>>
>>
>> On 6/21/2013 5:23 PM, Yinghai Lu wrote:
>>> On Fri, Jun 21, 2013 at 2:30 PM, Mike Travis <travis@sgi.com> wrote:
>>>> Exactly.  That's why I left both low and high memory on each node.
>>>
>>> looks like you assume every node have same ram, and before booting you
>>> you need to know memory layout to append the boot command line.
>>>
>>> We have patchset that moving srat table parse early.
>>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>>> for-x86-mm
>>> https://git.kernel.org/cgit/linux/kernel/git/yinghai/linux-yinghai.git/log/?h=for-x86-mm
>>>
>>> on top that, we could make your patch pass more simple command like
>>> 1/2^n of every node, and only need to pass n instead.
>>
>> The two params that I couldn't figure out how to provide except via kernel
>> param option was the memory block size (128M or 2G) and the physical
>> address space per node.  The other 3 params can be automatically
>> setup by a script when the total system size is known.  As soon as we
>> verify on the 32TB system and surmise what will be needed for 64TB,
>> then those 3 params can probably disappear.
> 
> our "numa parsing early" patchset could provide "physical address
> space per node",
> also can calculate memory block size via alignment detection from numa info.

Thanks!  I'll try it out.
> 
> with that, user only can pass "delay_init_mem" only.
> 
> Thanks
> 
> Yinghai
> 
