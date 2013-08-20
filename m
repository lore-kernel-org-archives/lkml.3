Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab3HTR7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:59:32 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61018 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab3HTR7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:59:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130819184355.GA25362@redhat.com>
References: <20130819172524.GA22268@redhat.com> <CALCETrW+dEwR38ERQhx25-aw1dhsCE6X+9BQZJhusO88aUxN1A@mail.gmail.com>
 <20130819183319.GA24846@redhat.com> <CALCETrWrpNszRGCRRMLgiOopcSdDShB3Mck6gRPco=dAZeX3pQ@mail.gmail.com>
 <20130819184355.GA25362@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 20 Aug 2013 10:59:10 -0700
Message-ID: <CALCETrU4gTfzcpeEo-X7o-yZefKiw9BVNKdcN4fThUeiuZtOOg@mail.gmail.com>
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

On Mon, Aug 19, 2013 at 11:43 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/19, Andy Lutomirski wrote:
>>
>> On Mon, Aug 19, 2013 at 11:33 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> > So do you think this change is fine or not (ignoring the fact it needs
>> > cleanups) ?
>>
>> I think that removing the CLONE_VM check is fine (although there are
>> some other ones that should probably be removed as well), but I'm not
>> sure if that check needs replacing with something else.
>
> OK, thanks... but I still can't understand.
>
> The patch I sent is equivalent to the new one below. I just tried to
> unify it with another check in do_fork().

I was confused.

Currently (with or without your patch), vfork() followed by
unshare(CLONE_NEWUSER) or unshare(CLONE_NEWPID) will unshare the VM.
This may be surprising, but at least it will work.

--Andy
