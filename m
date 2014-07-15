Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097AbaGOTIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:08:14 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62347 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760AbaGOTIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:08:11 -0400
Date: Tue, 15 Jul 2014 12:08:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20140715190807.GA26057@roeck-us.net>
References: <20140715132946.771def89@canb.auug.org.au>
 <53C4BF8E.4010509@roeck-us.net>
 <20140715155547.25959587@canb.auug.org.au>
 <20140715150801.7f8099b1@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715150801.7f8099b1@recife.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 03:08:01PM -0300, Mauro Carvalho Chehab wrote:
> Hi Guenter,
> 
> Em Tue, 15 Jul 2014 15:55:47 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> escreveu:
> 
> > Hi Guenter,
> > 
> > On Mon, 14 Jul 2014 22:43:42 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
> > >
> > > On 07/14/2014 08:29 PM, Stephen Rothwell wrote:
> > > >
> > > > After merging the v4l-dvb tree, today's linux-next build (powerpc ppc64_defconfig)
> > > > failed like this:
> > > >
> > > > arch/powerpc/kernel/smp.c:764:2: error: initialization from incompatible pointer type [-Werror]
> > > >    { cpu_smt_mask, powerpc_smt_flags, SD_INIT_NAME(SMT) },
> > > >    ^
> > > > arch/powerpc/kernel/smp.c:764:2: error: (near initialization for 'powerpc_topology[0].sd_flags') [-Werror]
> > > >
> > > > Caused by commit 6a0b50087a89 ("Merge branch 'patchwork' into
> > > > to_next").  The change to include/linux/sched.h in this merge commit
> > > > does not seem to appear in either of the parents of the merge.
> > > >
> > > > Its also a change that (when suggested) was shown to cause more
> > > > problems than it was worth and dropped.  I can't imagine how it ended
> > > > up in the merge commit.
> > > >
> 
> Sorry, it was merged there by mistake. I had to apply that quick hack
> to be able check if everything was ok on my tree before pushing it
> upstream (as I do my tests with W=1). Without that hack, it is almost
> impossible to see anything at the compilation logs, as it generates
> hundreds of warnings like:
> 
> In file included from include/linux/i2c.h:31:0,
>                  from drivers/staging/media/go7007/go7007-fw.c:31:
> include/linux/sched.h:875:25: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
>  static inline const int cpu_smt_flags(void)
>                          ^
> include/linux/sched.h:882:25: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
>  static inline const int cpu_core_flags(void)
>                          ^
> include/linux/sched.h:1002:21: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
>  typedef const int (*sched_domain_flags_f)(void);
>                      ^
> 
> even when compiling just drivers/media and drivers/staging/media.
> 
Yes, I know, I had the same problem with my hwmon and watchdog builds.
I ended up adding code to my test scripts to specifically ignore
those warnings. Of course, that may accidentially remove real warnings,
but it is still better than drowning _all_ warnings in the noise.

> > > 
> > > Do you mean b6220ad66 (sched: Fix compiler warnings) ? I thought that was accepted
> > > a week or so ago.
> > 
> > That is in the tip tree and includes the fixups to powerpc and arm.  I
> > don't merge the tip tree till well after the v4l-dvb tree.  The merge
> > in the v4l-dvb tree included only the change to include/linus/sched.h
> > and neither parent fo that merge was based on the tip tree ...
> > 
> Stephen, 
> 
> Do you know if/when this patch will be merged upstream? It doesn't
> seem to be at 2.6.16-rc5. Otherwise, I'll likely cherry-pick it on
	s/2.16/3.16/
> my trees, as the lack of this fixup is making hard for me to check
> if a media tree patch isn't introducing new warnings.
> 

Only queued for 3.17 as far as I can see, and not scheduled for 3.16.

Guenter
