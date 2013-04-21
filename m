Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944Ab3DUAuM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 20:50:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab3DUAuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 20:50:10 -0400
Date: Sun, 21 Apr 2013 02:49:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Han Pingtian <hanpt@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
In-Reply-To: <20130417084615.GA2672@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1304210247270.15075@twin.jikos.cz>
References: <20130416110009.GA2664@localhost.localdomain> <alpine.DEB.2.02.1304161315290.30779@chino.kir.corp.google.com> <20130417084615.GA2672@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Apr 2013, Han Pingtian wrote:

> > > On a power7 system, we have installed 3.9-rc7 and crash 6.1.6. If I run
> > > something like "make -j 64" to compile linux kernel from source, sooner
> > > or latter, oom-killer will be triggered. Before that, when I trying to
> > > analyse the live system with crash, some processes' %MEM and RSS looks
> > > too big:
> > > 
> > 
> > Do you have the oom killer log from /var/log/messages with 
> > /proc/sys/vm/oom_dump_tasks enabled?  Have you tried to reproduce this 
> > issue with CONFIG_DEBUG_VM and CONFIG_DEBUG_PAGEALLOC enabled (you may 
> > even want to consider CONFIG_KMEMLEAK)?
> 
> I have enabled CONFIG_KMEMLEAK and recompiled kernel. This is the
> /sys/kernel/debug/kmemleak after the reboot. Please have a look. Thanks.

Either kmemleak is very wrong about some false positive in selinux, or 
selinux is leaking memory quite heavily.

Could you try disabling selinux completely, to see if the leak goes away?

-- 
Jiri Kosina
SUSE Labs

