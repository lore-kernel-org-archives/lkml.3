Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbaHKU0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 16:26:12 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56884 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbaHKU0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 16:26:10 -0400
Date: Mon, 11 Aug 2014 13:26:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: Runtime trouble with commit dbd952127d (seccomp: introduce
 writer locking)
Message-ID: <20140811202605.GA2986@roeck-us.net>
References: <53E6CF2B.6090709@roeck-us.net>
 <CAGXu5jLsbCpqG2cAxZWG+ZC=wdvhQ_9GPqXUb6p9pSvsqrXpOA@mail.gmail.com>
 <20140810193308.GA31867@redhat.com>
 <53E7DB59.6020300@roeck-us.net>
 <CA+55aFz3vW_qnrwa6kWMsN1pGbjnyGXGBNhH=DO0berKgyOtgQ@mail.gmail.com>
 <53E7FDB5.4070607@roeck-us.net>
 <CA+55aFyus4Le7EeCEaJpcVVshtwK93Et1C0AkPaC=5QnXJYjGw@mail.gmail.com>
 <20140811114822.GA2122@redhat.com>
 <53E8CF26.9050707@roeck-us.net>
 <CAGXu5jJ7AKTG+d50Mo8WfvZQ2dYkE8syq=517TkHMYouvJCZXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ7AKTG+d50Mo8WfvZQ2dYkE8syq=517TkHMYouvJCZXw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 12:51:22PM -0700, Kees Cook wrote:
> On Mon, Aug 11, 2014 at 7:11 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> > On 08/11/2014 04:48 AM, Oleg Nesterov wrote:
> >>
> >> On 08/10, Linus Torvalds wrote:
> >>>
> >>>
> >>> So that should just be converted to assert_spin_is_locked().
> >>
> >>
> >> I still think that lockdep_assert_held() is better. Unlike
> >> assert_spin_locked() it checks that this lock is held by us, and this
> >> is what we want in this case.
> >>
> >
> > assert_spin_locked maps to "BUG_ON(!raw_spin_is_locked(x))"
> > which it seems is exactly what the current code is doing.
> > I submitted a patch to make that change to use assert_spin_locked.
> > Presumably the author had a reason for using BUG_ON and not
> > lockdep_assert_held(), ie to perform the checks all the time
> > and not just while debugging. For me this was the safe change
> > to make. Anything else should, in my opinion, come from the
> > original author who introduced the code.
> 
> Thanks for the patch! Yeah, that's a weird case; I think we need some
> documentation in the header file about the UP vs SMP logic when using
> spin_is_locked(). I note that all other stuff gets hidden behind the
> _up and _smp headers.
> 
Guess one has to know what to look for.

Documentation/scsi/ChangeLog.megaraid gives a hint, as do the comments
next to WARN_ON_SMP.

Not that I knew before last night :-).

> I don't prefer lockdep_assert_held(), though, since I want lock
> failures to hit BUG. I'll apply the patch and ask James to pull it.
> 
Thanks a lot!

Guenter
