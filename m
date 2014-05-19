Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaESWiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:38:22 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:26523 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaESWiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:38:20 -0400
Message-ID: <1400539098.6399.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: linux-next: build warning after merge of the akpm tree
From: Davidlohr Bueso <davidlohr@hp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>
Date: Mon, 19 May 2014 15:38:18 -0700
In-Reply-To: <20140520073634.40179424@canb.auug.org.au>
References: <20140519181314.1b92c548@canb.auug.org.au>
	 <1400512396.2560.9.camel@buesod1.americas.hpqcorp.net>
	 <20140520073634.40179424@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-20 at 07:36 +1000, Stephen Rothwell wrote:
> Hi,
> 
> On Mon, 19 May 2014 08:13:16 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
> >
> > On Mon, 2014-05-19 at 18:13 +1000, Stephen Rothwell wrote:
> > > Hi Andrew,
> > > 
> > > After merging the akpm tree, today's linux-next build (arm
> > > multi_v7_defconfig) produced these warnings:
> > > 
> > > 
> > > ipc/ipcns_notifier.c:22:8: warning: excess elements in struct initializer [enabled by default]
> > > ipc/ipcns_notifier.c:22:8: warning: (near initialization for 'ipcns_chain.rwsem') [enabled by default]
> > > ipc/ipcns_notifier.c:22:8: warning: excess elements in struct initializer [enabled by default]
> > > ipc/ipcns_notifier.c:22:8: warning: (near initialization for 'ipcns_chain.rwsem') [enabled by default]
> > > 
> > > and many more in other files ...
> > 
> > Hmm are all the warning the same? Is this just on arm? have you seen it
> > in other archs? (Could you please send me the .config)
> 
> The warnings were all the same, I saw it only on arm (since that was
> what I built) and I mentioned the config above.
> 
> > > Presumably a result of commit fe2038c57c03 ("rwsem: Support optimistic
> > > spinning").
> > 
> > If CONFIG_SMP, we add two new fields to the rwsem structure
> > (include/linux/rwsem.h) and likewise we update the
> > __RWSEM_INITIALIZER(name) macro. Afaict the only way to trigger
> > something like that is to be using the spinlock variant
> > (rwsem-spinlock.h).
> 
> Actually quite a few architectures do set
> CONFIG_RWSEM_GENERIC_SPINLOCK, and so wouldn't it make more sense to
> actually directly test that?

Both are equivalent, I have no preference. I've sent a formal fix to the
-tip folks, I guess I'll let them choose.

Thanks,
Davidlohr

