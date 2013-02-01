Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3BACPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 21:15:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:45070 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab3BACPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 21:15:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,579,1355126400"; 
   d="scan'208";a="255858643"
Date: Fri, 1 Feb 2013 10:16:28 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] rwsem-spinlock: let rwsem write lock stealable
Message-ID: <20130201021628.GC12678@yliu-dev.sh.intel.com>
References: <1359537244-20588-1-git-send-email-yuanhan.liu@linux.intel.com>
 <CANN689GwGh2sHwoP66JjoXs2ZMQAXbVpA0MHQahWq5M+baNfSQ@mail.gmail.com>
 <20130131124004.GA12678@yliu-dev.sh.intel.com>
 <20130131131228.GB6627@gmail.com>
 <20130131143626.GB12678@yliu-dev.sh.intel.com>
 <20130131211818.GA13195@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131211818.GA13195@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 10:18:18PM +0100, Ingo Molnar wrote:
> 
> * Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> 
> > On Thu, Jan 31, 2013 at 02:12:28PM +0100, Ingo Molnar wrote:
> > > 
> > > * Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> > > 
> > > > BTW, mind to tell a nice test case for mmap_sem?
> > > 
> > > this one was write-hitting on mmap_sem pretty hard, last I 
> > > checked:
> > > 
> > >   http://people.redhat.com/mingo/threaded-mmap-stresstest/
> > 
> > Thanks!
> > 
> > Is there any pass condition? I tested a while, at least I 
> > found no oops or any noisy from dmesg output. Is that OK?
> 
> Yeah, not crashing and not hanging is the expected behavior.

Good to know.

> 
> > Well, sometimes, it will quit peacefully. Sometimes it will 
> > not. ps -eo 'pid, state,wchan,comm' shows that it is sleeping 
> > at futex_wait_queue_me().
> > 
> > NOTE: this happens both with or w/o this patch. Thus it may 
> > not an issue introduced by this patch?
> 
> hm, that's unexpected - it's expected to loop infinitely.

Reall sorry about that. My bad. I modify the code a bit: removed the two
//, so that thread will exit after count > 1000000.

Sorry again :(

	--yliu

> I have 
> a newer version (attached) - is that exiting too?
> 
> Maybe this triggers spuriously:
> 
>         if (!info->si_addr)
>                 raise(SIGABRT); /* Allow GDB backtrace */
> 
> although then you should see the SIGABRT as an irregular exit 
> IIRC.
> 
> Thanks,
> 
> 	Ingo


