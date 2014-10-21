Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbaJUKFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:05:24 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:49906 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbaJUKFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:05:23 -0400
X-Originating-IP: 50.43.41.112
Date: Tue, 21 Oct 2014 03:05:11 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Landley <rob@landley.net>, Frank Rowand <frowand.list@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] init: Remove CONFIG_INIT_FALLBACK
Message-ID: <20141021100510.GA28414@thin>
References: <20141020144448.59e2e067d632c70353296e56@linux-foundation.org>
 <a6b3d86db6f5d19f7130b8dba2703dda68cb14d5.1413842560.git.luto@amacapital.net>
 <CAMuHMdWrXaJnfuyxOP-4zQyYJwrho6XvbTcjtwNK4pgoSH9PFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWrXaJnfuyxOP-4zQyYJwrho6XvbTcjtwNK4pgoSH9PFw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 11:53:04AM +0200, Geert Uytterhoeven wrote:
> On Tue, Oct 21, 2014 at 12:04 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> > CONFIG_INIT_FALLBACK adds config bloat without an obvious use case
> > that makes it worth keeping around.  Delete it.
> >
> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> > ---
> >
> > Bring on the blame :)
> >
> >  init/Kconfig | 16 ----------------
> >  init/main.c  |  5 -----
> >  2 files changed, 21 deletions(-)
> >
> > diff --git a/init/Kconfig b/init/Kconfig
> > index ebbd5846478e..e84c6423a2e5 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1299,22 +1299,6 @@ source "usr/Kconfig"
> >
> >  endif
> >
> > -config INIT_FALLBACK
> > -       bool "Fall back to defaults if init= parameter is bad"
> > -       default y
> > -       help
> 
> The above is not in mainline, nor in -next?
> Seems it only exists in a patch series you sent yourself?
> 
> Confused...

See the previous thread.  The previous patch adds this config option to
make the current default behavior optional.  The removal patch then
removes the old default behavior.  Andrew plans to push them in
successive kernels, to give more review time.

- Josh Triplett
