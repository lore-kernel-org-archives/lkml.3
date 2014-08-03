Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbaHCAry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 20:47:54 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:64007 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaHCArx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 20:47:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140730130238.GE13965@amd.pavel.ucw.cz>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	<20140730130238.GE13965@amd.pavel.ucw.cz>
Date: Sat, 2 Aug 2014 17:47:52 -0700
Message-ID: <CA+80gGbOx9istV4UG7PF+qam81u+HzJyjznE5sjVV82jjWa=MQ@mail.gmail.com>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Sergey Oboguev <oboguev.public@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 6:02 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> One of the intended purposes of this facility (but its not sole purpose) is to
>> render a lightweight mechanism for priority protection of lock-holding critical
>> sections that would be an adequate match for lightweight locking primitives
>> such as futex, with both featuring a fast path completing within the
>> userspace.

> Do we get a manpage describing the interface...?

At this point it is just an RFC, and the only available write-up is an article
(URL is in the original message).

There has been no word from the maintainers yet whether the proposal appears
to be a "go" or "no-go" in general.

Assuming the response was favorable, final polishing on the patch can be done
(such as perhaps replacing or augmenting authlist by a capability), and man page
can be added at this point as well.

> Would it make sense to make set_priority a "vsyscall" so it is fast enough,
and delayed_set_priority does not need to be exposed to userspace?

Regular "set priority" cannot be wrapped around "deferred set priority".

"Deferred set priority" acts only on current thread.

Even more importantly, its use also relies on a thread caching the application's
current knowledge of the thread priority in the userspace, and if the thread
priority had been changed from the outside of the application (or even by
another thread within the same application), this knowledge becomes invalid,
and then the application is responsible for performing whatever recovery action
is appropriate.

Thus DPRIO is not a replacement for fully-functional "set priority",
but rather a
specialized tool for certain use cases.

- Sergey
