Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbaB0Qnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:43:55 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59023 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaB0Qnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:43:53 -0500
X-Originating-IP: 50.43.14.201
Date: Thu, 27 Feb 2014 08:43:36 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>, Tony Lu <zlu@tilera.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Alex Elder <alex.elder@linaro.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <dborkman@redhat.com>,
        Andre Naujoks <nautsch2@gmail.com>, Jason Baron <jbaron@akamai.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Randy Dunlap <rdunlap@infradead.org>, Robin Holt <holt@sgi.com>,
        Tony Luck <tony.luck@intel.com>, Alex Thorlton <athorlton@sgi.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH 02/46] kernel: Add prototype definition to
 include/linux/kernel.h
Message-ID: <20140227164335.GB28589@thin>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
 <644cc80558c61ce1f498393a77df366ad0d7b960.1393493276.git.rashika.kheria@gmail.com>
 <20140227113230.3e726bc7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140227113230.3e726bc7@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 11:32:30AM -0500, Steven Rostedt wrote:
> On Thu, 27 Feb 2014 16:38:50 +0530
> Rashika Kheria <rashika.kheria@gmail.com> wrote:
> > Add prototype declaration to header file include/linux/kernel.h because
> > it is used by more than one file.
> > 
> > This also eliminates the following warning in kernel/panic.c:
> > kernel/panic.c:55:13: warning: no previous prototype for ‘panic_smp_self_stop’ [-Wmissing-prototypes]
> > 
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > ---
> >  arch/tile/kernel/smp.c |    1 +
> >  include/linux/kernel.h |    2 ++
> >  kernel/panic.c         |    1 +
> >  3 files changed, 4 insertions(+)
> > 
> > diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
> > index 01e8ab2..8b645fd 100644
> > --- a/arch/tile/kernel/smp.c
> > +++ b/arch/tile/kernel/smp.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/io.h>
> >  #include <linux/irq.h>
> >  #include <linux/module.h>
> > +#include <linux/kernel.h>
> >  #include <asm/cacheflush.h>
> >  #include <asm/homecache.h>
> >  
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index 196d1ea..c7cee7d 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -154,6 +154,8 @@ struct completion;
> >  struct pt_regs;
> >  struct user;
> >  
> > +void __weak panic_smp_self_stop(void);
> 
> Is __weak required in a prototype? What about the override that is not
> weak.

That's a good question.  It's definitely not required, and should be
dropped.  What I don't know is if it's broken to include it: does it
make the non-weak definition weak?

- Josh Triplett
