Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934508Ab3BSWAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 17:00:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933545Ab3BSWAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 17:00:38 -0500
Date: Tue, 19 Feb 2013 14:00:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ebiederm@xmission.com, xemul@parallels.com,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch 1/2] kcmp: Make it to depend on CONFIG_KCMP
Message-Id: <20130219140035.373ce4d2.akpm@linux-foundation.org>
In-Reply-To: <20130219215432.GP20312@moon>
References: <20130219064800.719149796@openvz.org>
	<20130219065210.030802820@openvz.org>
	<5123444D.6000806@suse.cz>
	<20130219093154.GF20312@moon>
	<5123BC2B.6000304@zytor.com>
	<20130219182838.GL20312@moon>
	<20130219134256.f4cedf44.akpm@linux-foundation.org>
	<20130219215432.GP20312@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013 01:54:32 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> On Tue, Feb 19, 2013 at 01:42:56PM -0800, Andrew Morton wrote:
> > > Index: linux-2.6.git/kernel/Makefile
> > > ===================================================================
> > > --- linux-2.6.git.orig/kernel/Makefile
> > > +++ linux-2.6.git/kernel/Makefile
> > > @@ -25,9 +25,7 @@ endif
> > >  obj-y += sched/
> > >  obj-y += power/
> > >  
> > > -ifeq ($(CONFIG_CHECKPOINT_RESTORE),y)
> > > -obj-$(CONFIG_X86) += kcmp.o
> > > -endif
> > > +obj-$(CONFIG_KCMP) += kcmp.o
> > >  obj-$(CONFIG_FREEZER) += freezer.o
> > >  obj-$(CONFIG_PROFILING) += profile.o
> > >  obj-$(CONFIG_STACKTRACE) += stacktrace.o
> > 
> > This permits people to select kcmp with CONFIG_CHECKPOINT_RESTORE=n. 
> > Is there any point in doing that?
> > 
> > What would be wrong with just doing
> > 
> > 	obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
> 
> I think this syscall is usefull even without c/r stuff.
> That's why I made it with separate config option.

hm, OK.

But the patch also permits CONFIG_CHECKPOINT_RESTORE=y, CONFIG_KCMP=n
which surely isn't something which CRIU wants to support?
