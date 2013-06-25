Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3FYRfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:35:46 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33255 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752047Ab3FYRfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:35:45 -0400
Message-ID: <51C9D4ED.5070805@sgi.com>
Date: Tue, 25 Jun 2013 10:35:41 -0700
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
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <20130621165142.GA32125@kroah.com> <51C48745.9030304@zytor.com> <CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com> <20130621185056.GA23473@kroah.com> <51C4C5F3.3050800@sgi.com> <CAE9FiQXaUNbK9+g-7j6gfvLrSvUJFWWKapDv658LPe4VfbH=tQ@mail.gmail.com>
In-Reply-To: <CAE9FiQXaUNbK9+g-7j6gfvLrSvUJFWWKapDv658LPe4VfbH=tQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 6/21/2013 5:23 PM, Yinghai Lu wrote:
> On Fri, Jun 21, 2013 at 2:30 PM, Mike Travis <travis@sgi.com> wrote:
>>
>>
>> On 6/21/2013 11:50 AM, Greg KH wrote:
>>> On Fri, Jun 21, 2013 at 11:44:22AM -0700, Yinghai Lu wrote:
>>>> On Fri, Jun 21, 2013 at 10:03 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>>> On 06/21/2013 09:51 AM, Greg KH wrote:
>>>>>
>>>>> I suspect the cutoff for this should be a lot lower than 8 TB even, more
>>>>> like 128 GB or so.  The only concern is to not set the cutoff so low
>>>>> that we can end up running out of memory or with suboptimal NUMA
>>>>> placement just because of this.
>>>>
>>>> I would suggest another way:
>>>> only boot the system with boot node (include cpu, ram and pci root buses).
>>>> then after boot, could add other nodes.
>>>
>>> What exactly do you mean by "after boot"?  Often, the boot process of
>>> userspace needs those additional cpus and ram in order to initialize
>>> everything (like the pci devices) properly.
>>
>> Exactly.  That's why I left both low and high memory on each node.
> 
> looks like you assume every node have same ram, and before booting you
> you need to know memory layout to append the boot command line.
> 
> We have patchset that moving srat table parse early.
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-x86-mm
> https://git.kernel.org/cgit/linux/kernel/git/yinghai/linux-yinghai.git/log/?h=for-x86-mm
> 
> on top that, we could make your patch pass more simple command like
> 1/2^n of every node, and only need to pass n instead.

The two params that I couldn't figure out how to provide except via kernel
param option was the memory block size (128M or 2G) and the physical
address space per node.  The other 3 params can be automatically
setup by a script when the total system size is known.  As soon as we
verify on the 32TB system and surmise what will be needed for 64TB,
then those 3 params can probably disappear.




> 
> Thanks
> 
> Yinghai
> 
