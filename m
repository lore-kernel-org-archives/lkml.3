Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbaIKPPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:15:03 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:56372 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbaIKPPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:15:00 -0400
MIME-Version: 1.0
In-Reply-To: <5411B5D6.9010201@gmail.com>
References: <53F5310A.5080503@gmail.com> <CALCETrX2qwvzmeoVcLFLxEK=1Fv+f0Ri0TouzzvbN_rgDjka4A@mail.gmail.com>
 <540F0810.7030408@gmail.com> <87ppf4n5ib.fsf@x220.int.ebiederm.org> <5411B5D6.9010201@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 11 Sep 2014 08:14:36 -0700
Message-ID: <CALCETrV1EtrzfEhS55ToPD5VTbY9VjmmOA6bv2H9PGGQ-G=WGA@mail.gmail.com>
Subject: Re: For review: user_namespace(7) man page
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 7:46 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> Hi Eric,
>
> On 09/09/2014 09:05 AM, Eric W. Biederman wrote:
>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>
>>> Hi Andy, and Eric,
>>>>>        1. The  writing  process  must  have  the CAP_SETUID (CAP_SETGID)
>>>>>           capability in the user namespace of the process pid.
>>>>
>>>> This checked for the opening process (and I don't actually remember
>>>> whether it's checked for the writing process).
>>>
>>> Eric, can you comment?
>>
>> We have to check for the opening processes and that changes was made
>> after I implemented my interface. Pieces of the code appear to also
>> examine the writing process and verify everything applies to it as well.
>>
>> I goofed when I designed the interface originall and had not realized
>> what a classic design error it can be to not restrict by the opening
>> process.
>
> So, I still need some help here. Should the sentence above just read:
>
>         1. The  *opening*  process  must  have  the CAP_SETUID (CAP_SETGID)
>            capability in the user namespace of the process pid.

I think this is sufficient.

>
> or must something also be said about the writing process? (If so, i'd
> appreciate a completely formed sentence or two that I can just drop into
> the man page..)

There might be a restriction there, too, but I think it could be
removed, and I also think that it's unlikely that anyone will
encounter it.

--Andy
