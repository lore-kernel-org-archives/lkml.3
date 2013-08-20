Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab3HTTOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:14:15 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:40063 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3HTTOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:14:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130820190529.GA24512@redhat.com>
References: <20130819172524.GA22268@redhat.com> <CALCETrW+dEwR38ERQhx25-aw1dhsCE6X+9BQZJhusO88aUxN1A@mail.gmail.com>
 <20130819183319.GA24846@redhat.com> <CALCETrWrpNszRGCRRMLgiOopcSdDShB3Mck6gRPco=dAZeX3pQ@mail.gmail.com>
 <20130819184355.GA25362@redhat.com> <CALCETrU4gTfzcpeEo-X7o-yZefKiw9BVNKdcN4fThUeiuZtOOg@mail.gmail.com>
 <20130820185043.GA24040@redhat.com> <CALCETrUjohT2D=jtVQ9mnbeUr2oJ9VoN812PtQhaB2ZZ89isNA@mail.gmail.com>
 <20130820190529.GA24512@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 20 Aug 2013 12:13:50 -0700
Message-ID: <CALCETrVC15BjcRMk2tc-SRT3tUr24057Zxt5ARQ-2Eq7RhjO2w@mail.gmail.com>
Subject: Re: PATCH? fix unshare(NEWPID) && vfork()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Brad Spengler <spender@grsecurity.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Walters <walters@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 12:05 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/20, Andy Lutomirski wrote:
>>
>> On Tue, Aug 20, 2013 at 11:50 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> >> Currently (with or without your patch), vfork() followed by
>> >> unshare(CLONE_NEWUSER) or unshare(CLONE_NEWPID) will unshare the VM.
>> >
>> > Could you spell please?
>> >
>> > We never unshare the VM. CLONE_VM in sys_unshare() paths just means
>> > "fail unless ->mm is not shared".
>> >
>>
>> Argh.  In that case this is probably buggy,
>
> I don't think so. Just we can't really unshare ->mm or implement
> unshare(CLONE_THREAD). We simply pretend it works if there is nothing
> to unshare.
>
>> sys_unshare will see CLONE_NEWPID or CLONE_NEWUSER and set
>> CLONE_THREAD.  Then it will see CLONE_THREAD and set CLONE_VM.
>
> This matches copy_process() to some degree... but looks confusing,
> I agree.

Huh?  Doesn't this mean that unshare(CLONE_NEWPID); vfork() will work
with your patches, but vfork(); unshare(CLONE_NEWPID) will fail?  (I
admit I haven't tested it.)

--Andy
