Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3DVDPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 23:15:13 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59325 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab3DVDPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 23:15:11 -0400
Date: Mon, 22 Apr 2013 11:15:04 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: jkosina@suse.cz, rientjes@google.com, mhocko@suse.cz
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
Message-ID: <20130422031504.GF2672@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org, jkosina@suse.cz,
	rientjes@google.com, mhocko@suse.cz
References: <20130416110009.GA2664@localhost.localdomain>
 <alpine.DEB.2.02.1304161315290.30779@chino.kir.corp.google.com>
 <20130417084615.GA2672@localhost.localdomain>
 <alpine.LRH.2.00.1304210247270.15075@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1304210247270.15075@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042203-3620-0000-0000-00000220A367
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 02:49:31AM +0200, Jiri Kosina wrote:
> On Wed, 17 Apr 2013, Han Pingtian wrote:
> 
> > > > On a power7 system, we have installed 3.9-rc7 and crash 6.1.6. If I run
> > > > something like "make -j 64" to compile linux kernel from source, sooner
> > > > or latter, oom-killer will be triggered. Before that, when I trying to
> > > > analyse the live system with crash, some processes' %MEM and RSS looks
> > > > too big:
> > > > 
> > > 
> > > Do you have the oom killer log from /var/log/messages with 
> > > /proc/sys/vm/oom_dump_tasks enabled?  Have you tried to reproduce this 
> > > issue with CONFIG_DEBUG_VM and CONFIG_DEBUG_PAGEALLOC enabled (you may 
> > > even want to consider CONFIG_KMEMLEAK)?
> > 
> > I have enabled CONFIG_KMEMLEAK and recompiled kernel. This is the
> > /sys/kernel/debug/kmemleak after the reboot. Please have a look. Thanks.
> 
> Either kmemleak is very wrong about some false positive in selinux, or 
> selinux is leaking memory quite heavily.
> 
> Could you try disabling selinux completely, to see if the leak goes away?
> 
Thanks your reply. We had disable selinux from the very beginning.

