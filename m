Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965695Ab3CZQf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:35:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54715 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965531Ab3CZQfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:35:24 -0400
Date: Tue, 26 Mar 2013 16:35:18 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Build breakage in 3.8.4 [was: Linux 3.8.4]
Message-ID: <20130326163518.GC3542@hercules>
References: <20130320201554.GA18281@kroah.com>
 <kidd01$2o6$1@ger.gmane.org>
 <514F5480.6040501@suse.cz>
 <CAGXu5jJdbDabBjNoaZUeqCT6a6yHqHcQNnqXNM6T1S=bwig8Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJdbDabBjNoaZUeqCT6a6yHqHcQNnqXNM6T1S=bwig8Fw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 08:56:20AM -0700, Kees Cook wrote:
> On Sun, Mar 24, 2013 at 12:31 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> > On 03/20/2013 11:25 PM, Sebastian Gottschall wrote:
> >
> >> Am 20.03.2013 21:15, schrieb Greg KH:
> >>> I'm announcing the release of the 3.8.4 kernel.
> > ...
> >>>        signal: always clear sa_restorer on execve
> >> consider that this kernel is not compileable on mips targets due the
> >> patch in kernel/signal.c
> >>
> >> SA_RESTORER is defined in mips, but sa_restorer does not exist on that
> >> platform
> >
> > The same for ia64...
> >
> > kernel/signal.c: In function 'flush_signal_handlers':
> > kernel/signal.c:441: error: 'struct sigaction' has no member named
> > 'sa_restorer'
> >
> > Do we need this in 3.0, 3.4, 3.8 too?
> > commit 522cff142d7d2f9230839c9e1f21a4d8bcc22a4a
> > Author: Andrew Morton <akpm@linux-foundation.org>
> > Date:   Wed Mar 13 14:59:34 2013 -0700
> >
> >     kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER
> >
> >     __ARCH_HAS_SA_RESTORER is the preferred conditional for use in 3.9 and
> >     later kernels, per Kees.
> 
> Hrm, if so, we'll need to also backport the changes that aded
> __ARCH_HAS_SA_RESTORER...

Isn't the solution provided by Ben [1] enough to solve this?

[1] https://lkml.org/lkml/2013/3/26/12

Cheers,
--
Luis

> 
> -Kees
> 
> >
> > thanks,
> > --
> > js
> > suse labs
> 
> 
> 
> --
> Kees Cook
> Chrome OS Security
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
