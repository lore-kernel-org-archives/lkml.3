Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab3GCVah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 17:30:37 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:33954 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab3GCVab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 17:30:31 -0400
Date: Wed, 3 Jul 2013 23:30:25 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: Andy Lutomirski <luto@amacapital.net>, Jonathan Masters <jcm@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
Subject: Re: [RFC PATCH] Allow optional module parameters
Message-ID: <20130703213025.GF3268@free.fr>
References: <87sj3tsawh.fsf@rustcorp.com.au>
 <CALCETrUK54KViGex=V2pG8kAttsxOiDkeJUL48pk1NAhH-SdAA@mail.gmail.com>
 <87hak8qfu5.fsf@rustcorp.com.au>
 <CAMOw1v5AOmy38KNVfxj6OO-U0UCXST50vD0g0W5fEpNfKCpGvg@mail.gmail.com>
 <87sj3qpwdz.fsf@rustcorp.com.au>
 <87a9m6sri3.fsf@rustcorp.com.au>
 <9F26321B-7088-4D16-80D5-72EB388F8E49@redhat.com>
 <51D491AD.7050008@suse.cz>
 <CALCETrWOUE=2fX1k+igfNizUfxRaZCc9NDgMzy7SM6fAjZMZuA@mail.gmail.com>
 <51D49655.8030206@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51D49655.8030206@suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On 2013-07-03 23:23 +0200, Michal Marek spake thusly:
> Dne 3.7.2013 23:17, Andy Lutomirski napsal(a):
> > On Wed, Jul 3, 2013 at 2:03 PM, Michal Marek <mmarek@suse.cz> wrote:
> >> Dne 1.7.2013 18:33, Jonathan Masters napsal(a):
> >>> One caveat. Sometimes we have manufactured parameters intentionally
> >>> to cause a module to fail. We should standardize that piece.
> >>
> >> You have:
> >>
> >>   blacklist foo
> >>
> >> to prevent udev from loading a module and
> >>
> >>   install foo /bin/true
> >>
> >> to prevent modprobe from loading the module at all. What is the
> >> motivation for inventing a third way, through adding invalid parameters?
> >>
> > 
> > FWIW, I've occasionally booted with modulename.garbage=1 to prevent
> > modulename from loading at boot.  It may be worth adding a more
> > intentional way to do that.
> 
> Hm, right, there seems to be no clean way to achieve this via a
> commandline argument. Maybe define a magic module option to tell the
> module loader not to load a module?

I was going to suggest that, or a new kernel option:
    noloadmodules=module1[,module2...]

The option may well be cumulative, too, so we could do:
    noloadmodules=module1,module2 noloadmodules=module3

and none of module{1,2,3} would be loaded. This could allow bootloaders
to build up the command line more easily.

(Ab)using the module parameter to avoid loading is hackish at best, IMHO.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
