Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934622Ab3DJTUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:20:05 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:59472 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074Ab3DJTUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:20:03 -0400
MIME-Version: 1.0
In-Reply-To: <1365618018.4235.35.camel@jlt4.sipsolutions.net>
References: <1365593728-5720-1-git-send-email-mcgrof@do-not-panic.com>
 <1365593728-5720-7-git-send-email-mcgrof@do-not-panic.com>
 <1365600139.4235.4.camel@jlt4.sipsolutions.net> <CAB=NE6UpP-X1NCTNRnoSdv_bk3ioZdg5bO1zz0U0dqeWVxZdLw@mail.gmail.com>
 <1365614413.4235.29.camel@jlt4.sipsolutions.net> <CAB=NE6VAfAvjRs0uZ=jpMjfP5Dz-zEHu3N7t8AUAofZAggrEEQ@mail.gmail.com>
 <1365618018.4235.35.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 10 Apr 2013 12:19:40 -0700
X-Google-Sender-Auth: H6e-lR6w7xNUrK-Izfjv3rFCI7Y
Message-ID: <CAB=NE6VKT11k95Szi4NmigKCgMJ1XJoU3+rACbJpnWwUpCC1EA@mail.gmail.com>
Subject: Re: [PATCH 06/18] compat: backport ASYNC_DOMAIN_EXCLUSIVE()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        Dan Williams <dcbw@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 11:20 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2013-04-10 at 10:26 -0700, Luis R. Rodriguez wrote:
>
>> > I guess I'd have to review the async API,
>>
>> Yeap, reviewing the commit noted would help too.
>
> Yeah ... :)
>
>> > What's the use of just this when you don't have things like
>> > async_schedule_domain() and async_synchronize_full_domain(), regulator
>> > stuff wouldn't compile I think?
>>
>> You mean is not having the full asynch that deals with all registered
>> domains likely to have an issue on the useres of
>> async_synchronize_full_domain() ? Lets better ask Dan.
>
> I don't know. However it seems that in order to have an ASYNC_DOMAIN()
> or ASYNC_DOMAIN_EXCLUSIVE() you always need to *do* something with it,
> so for that you'd also need the functions async_schedule_domain() and
> async_synchronize_full_domain() or similar, at least, no?
>
> The point here seems to be making boot faster by starting a bunch of
> async probing inside a domain, and then you wait for the entire domain,
> so everything that's in that domain can be done in parallel.
>
> Say for example you have 20 SCSI drives. If you look at them serially
> then you'd waste much time waiting for the drives. The point here
> appears to be that you create a domain (using this macro), then add all
> the drives to the domain and then wait for the domain to finish.
>
> However, it seems entirely pointless to backport just a small part of
> the API?

Oh I agree don't get me wrong, however porting kernel/async.c seems
like a rather separate effort worth considering. As-is though I have
not seen any negative impact though to keep older subsystems from
compiling, ie its a no-op for older kernels as I see it.

 Luis
