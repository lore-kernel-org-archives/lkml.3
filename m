Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab3HTTjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:39:17 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:49266 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab3HTTjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:39:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130820192340.GA25441@redhat.com>
References: <20130819172524.GA22268@redhat.com> <CALCETrW+dEwR38ERQhx25-aw1dhsCE6X+9BQZJhusO88aUxN1A@mail.gmail.com>
 <20130819183319.GA24846@redhat.com> <CALCETrWrpNszRGCRRMLgiOopcSdDShB3Mck6gRPco=dAZeX3pQ@mail.gmail.com>
 <20130819184355.GA25362@redhat.com> <CALCETrU4gTfzcpeEo-X7o-yZefKiw9BVNKdcN4fThUeiuZtOOg@mail.gmail.com>
 <20130820185043.GA24040@redhat.com> <CALCETrUjohT2D=jtVQ9mnbeUr2oJ9VoN812PtQhaB2ZZ89isNA@mail.gmail.com>
 <20130820190529.GA24512@redhat.com> <CALCETrVC15BjcRMk2tc-SRT3tUr24057Zxt5ARQ-2Eq7RhjO2w@mail.gmail.com>
 <20130820192340.GA25441@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 20 Aug 2013 12:38:53 -0700
Message-ID: <CALCETrXnf8V+CgHDwEEviBkn0bJ60_H6G6WPmZxkQF85bqj3TQ@mail.gmail.com>
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

On Tue, Aug 20, 2013 at 12:23 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/20, Andy Lutomirski wrote:
>>
>> On Tue, Aug 20, 2013 at 12:05 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> > On 08/20, Andy Lutomirski wrote:
>> Huh?  Doesn't this mean that unshare(CLONE_NEWPID); vfork() will work
>> with your patches,
>
> I hope,
>
>> but vfork(); unshare(CLONE_NEWPID) will fail?  (I
>> admit I haven't tested it.)
>
> Do you mean that the child does unshare(CLONE_NEWPID) before exec?
> It should fail with or without this patch.
>

Exactly. Shouldn't it succeed?

--Andy
