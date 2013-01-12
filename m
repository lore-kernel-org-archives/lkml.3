Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3ALQwP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 11:52:15 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33336 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752723Ab3ALQwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 11:52:13 -0500
Message-ID: <1358009534.2168.22.camel@joe-AO722>
Subject: Re: mmotm 2013-01-11-15-47 uploaded (x86 asm-offsets broken)
From: Joe Perches <joe@perches.com>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org
Date: Sat, 12 Jan 2013 08:52:14 -0800
In-Reply-To: <CA+icZUVMY76bRFgUumZy0G-FFM=80iwfSFSopHMwHRYfgKjLjA@mail.gmail.com>
References: <20130111234813.170A620004E@hpza10.eem.corp.google.com>
	 <50F0BFAA.10902@infradead.org>
	 <20130112131713.749566c8d374cd77b1f2885e@canb.auug.org.au>
	 <1357957789.2168.11.camel@joe-AO722>
	 <CA+icZUVMY76bRFgUumZy0G-FFM=80iwfSFSopHMwHRYfgKjLjA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-01-12 at 11:13 +0100, Sedat Dilek wrote:
> On Sat, Jan 12, 2013 at 3:29 AM, Joe Perches <joe@perches.com> wrote:
> > On Sat, 2013-01-12 at 13:17 +1100, Stephen Rothwell wrote:
> >> On Fri, 11 Jan 2013 17:43:06 -0800 Randy Dunlap <rdunlap@infradead.org> wrote:
> >> >
> >> > b0rked.
> >> >
> >> > Some (randconfig?) causes this set of errors:
> >
> > I guess that's when CONFIG_HZ is not an even divisor of 1000.
> > I suppose this needs to be worked on a bit more.
[]
> I remember this patch from Joe come up with a pending patch in
> net-next.git#master
[]
> As I see Randy has in his kernel-config:
> CONFIG_HZ=300
> So there is a problem for the value "300" (only)?

Basically, this problem exists whenever timeconst.h
is necessary.

kernel/Makefile has code to create it in kernel/
and kernel/time.c is the only file that uses it.

That code will need to be removed and newly written
somewhere so that timeconst.h could be created as
include/linux/timeconst.h before any other compilation
so that jiffies.h can #include it.

I believe it should be akin to how version.h or
elfconfig.h is created.

Someone with stronger Makefile foo could probably do
it quicker than I could.

