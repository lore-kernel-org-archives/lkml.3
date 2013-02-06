Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab3BFT0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:26:53 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:60841 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab3BFT0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:26:49 -0500
Date: Wed, 6 Feb 2013 11:26:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jan Kara <jack@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] printk: Avoid softlockups in console_unlock()
In-Reply-To: <20130206185205.GA11254@quack.suse.cz>
Message-ID: <alpine.DEB.2.02.1302061125230.29136@chino.kir.corp.google.com>
References: <1360016230-26696-1-git-send-email-jack@suse.cz> <20130205123838.146a5371.akpm@linux-foundation.org> <20130206142346.GF6330@quack.suse.cz> <alpine.DEB.2.02.1302060958150.26828@chino.kir.corp.google.com> <20130206185205.GA11254@quack.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2013, Jan Kara wrote:

> On Wed 06-02-13 09:58:48, David Rientjes wrote:
> > On Wed, 6 Feb 2013, Jan Kara wrote:
> > 
> > >   Yes, I noticed that thread just yesterday and also though that using
> > > similar trick might be viable. I'll experiment if we could use the same
> > > method for handling lockup problems I hit. Steven seems to have already
> > > tweaked PRINTK_PENDING stuff to be usable more easily...
> > > 
> > 
> > Are these new build failures in linux-next coming from this patch?
> > 
> > kernel/printk.c: In function 'console_unlock':
> > kernel/printk.c:2156:18: error: 'printk_work' undeclared (first use in this function)
> > kernel/printk.c:2156:18: note: each undeclared identifier is reported only once for each function it appears in
> > kernel/printk.c: At top level:
> > kernel/printk.c:2167:13: warning: 'printk_worker' defined but not used [-Wunused-function]
>   Yes, I already sent a patch to fix these (attached if you need it).
> Thanks for notice.
> 

I don't see your attached 
printk-Fixup-compilation-with-CONFIG_PRINTK.patch in -mm nor do I see it 
on any mailing list.  Regardless,

Acked-by: David Rientjes <rientjes@google.com>

for wherever Andrew has this stashed away.  Thanks.
