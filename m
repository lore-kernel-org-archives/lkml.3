Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaBZBpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:45:21 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:40616 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaBZBpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:45:19 -0500
X-Originating-IP: 50.43.14.201
Date: Tue, 25 Feb 2014 17:45:03 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dwight Engen <dwight.engen@oracle.com>, Eric Paris <eparis@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Michal Hocko <mhocko@suse.cz>,
        Michal Marek <mmarek@suse.cz>, Mike Frysinger <vapier@gentoo.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rob Landley <rob@landley.net>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>, linux-doc@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: Make allnoconfig disable options behind
 EMBEDDED and EXPERT
Message-ID: <20140226014502.GA6641@thin>
References: <20140224022021.GA12665@thin>
 <20140225130925.813f29105079cbd3d5a9ba30@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140225130925.813f29105079cbd3d5a9ba30@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 01:09:25PM -0800, Andrew Morton wrote:
> On Sun, 23 Feb 2014 18:20:26 -0800 Josh Triplett <josh@joshtriplett.org> wrote:
> > "make allnoconfig" exists to ease testing of minimal configurations.
> > Documentation/SubmitChecklist includes a note to test with allnoconfig.
> > This helps catch missing dependencies on common-but-not-required
> > functionality, which might otherwise go unnoticed.
> > 
> > However, allnoconfig still leaves many symbols enabled, because they're
> > hidden behind CONFIG_EMBEDDED or CONFIG_EXPERT.  For instance,
> > allnoconfig still has CONFIG_PRINTK and CONFIG_BLOCK enabled, so drivers
> > don't typically get build-tested with those disabled.
> > 
> > To address this, introduce a new Kconfig option "allnoconfig_y", used on
> > symbols which only exist to hide other symbols.  Set it on
> > CONFIG_EMBEDDED (which then selects CONFIG_EXPERT).  allnoconfig will
> > then disable all the symbols hidden behind those.
> 
> Now look what you've done!
> 
> kernel/sched/core.c: In function 'pick_next_task':
> kernel/sched/core.c:2613: warning: control reaches end of non-void function

Hey, look, now allnoconfig turns off more of the more-rarely-disabled
options, and turns up bugs and warnings that most people don't see!
Yay! ;)

So, yes, we should go ahead and get BUG() fixed properly, at a minimum
by using __builtin_unreachable().  I'll send a patch for that, as a
followup to the thread where Arnd mentioned how to do so.

- Josh Triplett
