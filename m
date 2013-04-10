Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936357Ab3DJR0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:26:40 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:52068 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934793Ab3DJR0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:26:39 -0400
MIME-Version: 1.0
In-Reply-To: <1365614413.4235.29.camel@jlt4.sipsolutions.net>
References: <1365593728-5720-1-git-send-email-mcgrof@do-not-panic.com>
 <1365593728-5720-7-git-send-email-mcgrof@do-not-panic.com>
 <1365600139.4235.4.camel@jlt4.sipsolutions.net> <CAB=NE6UpP-X1NCTNRnoSdv_bk3ioZdg5bO1zz0U0dqeWVxZdLw@mail.gmail.com>
 <1365614413.4235.29.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 10 Apr 2013 10:26:17 -0700
X-Google-Sender-Auth: _IrKCNfLfgeLvKUHEd7R9rPd-5U
Message-ID: <CAB=NE6VAfAvjRs0uZ=jpMjfP5Dz-zEHu3N7t8AUAofZAggrEEQ@mail.gmail.com>
Subject: Re: [PATCH 06/18] compat: backport ASYNC_DOMAIN_EXCLUSIVE()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        Dan Williams <dcbw@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 10:20 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2013-04-10 at 10:13 -0700, Luis R. Rodriguez wrote:
>> On Wed, Apr 10, 2013 at 6:22 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Wed, 2013-04-10 at 04:35 -0700, Luis R. Rodriguez wrote:
>> >> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>> >>
>> >> For older kernels this is simply a matter of using
>> >> LIST_HEAD.
>> >
>> > Hmm, how is that useful if it will not have any effect?
>>
>> The core of the handling is done in the internal asynch code and
>> that's kept hidden from the users of this -- so far.
>
> I guess I'd have to review the async API,

Yeap, reviewing the commit noted would help too.

> but now this wouldn't do
> anything?

Nope.

> What's the use of just this when you don't have things like
> async_schedule_domain() and async_synchronize_full_domain(), regulator
> stuff wouldn't compile I think?

You mean is not having the full asynch that deals with all registered
domains likely to have an issue on the useres of
async_synchronize_full_domain() ? Lets better ask Dan.

> I guess I'm a bit confused what kind of effect this has.

Nothing, really. If we had a user of it in other ways we'd fail
compiling anyway but right now its a simple direct replacement.

  Luis
