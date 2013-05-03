Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab3ECERY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 00:17:24 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:39672 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab3ECERW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 00:17:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130503040934.GA16968@mtj.dyndns.org>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
	<1367458508-9133-4-git-send-email-ccross@android.com>
	<20130502235505.GW19814@mtj.dyndns.org>
	<20130503000358.GX19814@mtj.dyndns.org>
	<CAMbhsRSFjUvkXq66pYs_nYN5At7yB4sFM+cpxLgUF_Yns54J5A@mail.gmail.com>
	<CAMbhsRTSCW3WOxTgw8btk2yWAucqNmyY-Sc+CHsHmZzf6ZsTNA@mail.gmail.com>
	<20130503040934.GA16968@mtj.dyndns.org>
Date: Thu, 2 May 2013 21:17:21 -0700
X-Google-Sender-Auth: KnMoyHNqvhmI4hSeFuijh2vP1h8
Message-ID: <CAMbhsRQ=zyop6ubouHAsb9CYV9Pdqo5x0fsga7wuuedj1mio4g@mail.gmail.com>
Subject: Re: [PATCH v2 03/10] freezer: add new freezable helpers using freezer_do_not_count()
From: Colin Cross <ccross@android.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Oleg Nesterov <oleg@redhat.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jeff Layton <jlayton@redhat.com>,
        Mandeep Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 9:09 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Thu, May 02, 2013 at 07:41:39PM -0700, Colin Cross wrote:
>> On Thu, May 2, 2013 at 7:16 PM, Colin Cross <ccross@android.com> wrote:
>> > This sounds the same as what ended up getting reverted in
>> > https://lkml.org/lkml/2013/3/4/221
>> > I can add the WARN_ON_ONCE to all my new calls, and leave them out of
>> > existing calls, but that seems a little odd, and will be redundant if
>> > the lockdep call in try_to_freeze goes back in in 3.11.  Do you still
>> > want it in the new apis?
> ...
>> I could also put the lockdep check that was reveted back into
>> try_to_freeze(), and add a freezable_schedule_unsafe() that skips it
>> for use in the known-unsafe users in nfs, with a big comment not to
>> add new users of it.
>
> Oh yeah, that sounds like a good idea, and as for the non-ugly
> variants, at least in the mid/long term, I think it'd be best to add
> the lockdep annotation to try_to_freeze() with
> __try_to_freeze_unsafe_youre_gonna_burn_in_hell_if_you_use_this() for
> the existing users which should be gradually converted, but if that's
> too burdensome, adding warnings to the wrappers should do for now, I
> guess.
>
> And I *hope* the lockdep annotation is stricter than what was added
> before.  I think it better be "no lock ever should be held at this
> point" rather than "consider this a big lock".

The previous patch (6aa9707099c4b25700940eb3d016f16c4434360d in Linus'
tree) already required that no locks be held, it wasn't using a lock
annotation.
