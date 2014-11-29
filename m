Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaK2Q6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 11:58:52 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbaK2Q6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:58:50 -0500
Message-ID: <5479FB42.4080207@nod.at>
Date: Sat, 29 Nov 2014 17:58:42 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
References: <87fvhav3ic.fsf@x220.int.ebiederm.org>	<CAFLxGvwi-iJRyfwv8v9fcRkiSu2d-az8W55xMPbp_d8wQKmwjg@mail.gmail.com>	<87vbpm4f4y.fsf@x220.int.ebiederm.org>	<20140821131257.GA4264@infradead.org>	<53F5F2AD.5010607@nod.at>	<87k362vsr5.fsf@x220.int.ebiederm.org> <CAFLxGvzyhHC+QF-bFfp-yNBpCkS3JJ+RAr+5iCj0k_su9wJbGw@mail.gmail.com>
In-Reply-To: <CAFLxGvzyhHC+QF-bFfp-yNBpCkS3JJ+RAr+5iCj0k_su9wJbGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.11.2014 um 00:15 schrieb Richard Weinberger:
> Eric,
> 
> On Thu, Aug 21, 2014 at 4:09 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Richard Weinberger <richard@nod.at> writes:
>>
>>> Am 21.08.2014 15:12, schrieb Christoph Hellwig:
>>>> On Wed, Aug 20, 2014 at 09:53:49PM -0700, Eric W. Biederman wrote:
>>>>> Richard Weinberger <richard.weinberger@gmail.com> writes:
>>>>>
>>>>>> On Wed, Aug 6, 2014 at 2:57 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>>>>
>>>>>> This commit breaks libvirt-lxc.
>>>>>> libvirt does in lxcContainerMountBasicFS():
>>>>>
>>>>> The bugs fixed are security issues, so if we have to break a small
>>>>> number of userspace applications we will.  Anything that we can
>>>>> reasonably do to avoid regressions will be done.
>>>>
>>>> Can you explain the security issues in detail?  Breaking common
>>>> userspace like libvirt-lxc with just a little bit of handwaiving is
>>>> entirely unacceptable.
>>>
>>> It looks like commit 87b47932f40a11280584bce260cbdb3b5f9e8b7d in
>>> git.kernel.org/cgit/linux/kernel/git/ebiederm/user-namespace.git for-next
>>> unbreaks libvirt-lxc.
>>> I hope it hits Linus tree and -stable before the offending commit hits users.
>>
>> I plan to send the pull request to Linus as soon as I have caught my
>> breath (from all of the conferences this week) that I can be certain I
>> am thinking clearly and not rushing things.
> 
> Today I've upgraded my LXC testbed to the most recent kernel and found
> libvirt-lxc broken again (sic!).
> Remounting /proc/sys/ is failing.
> Investigating into the issue showed that commit "mnt: Implicitly add
> MNT_NODEV on remount as we do on mount"
> is not mainline.
> Why did you left out this patch? In my previous mails I explicitly
> stated that exactly this commit unbreaks libvirt-lxc.
> 
> Now the userspace breaking changes are mainline and hit users hard. :-(

*kind ping*
...to make sure that this issue doesn't get lost.

Thanks,
//richard
