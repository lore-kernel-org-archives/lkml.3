Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797Ab3BHKoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 05:44:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33413 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964774Ab3BHKoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 05:44:03 -0500
Date: Fri, 8 Feb 2013 10:43:18 +0000
From: Jamie Iles <jamie.iles@oracle.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Jamie Iles <jamie.iles@oracle.com>, mingo@kernel.org, peterz@infradead.org,
        penberg@kernel.org, acme@ghostprotocols.net, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] liblockdep: support using LD_PRELOAD
Message-ID: <20130208104318.GG3468@cedar>
References: <1360188694-25077-1-git-send-email-sasha.levin@oracle.com>
 <1360188694-25077-10-git-send-email-sasha.levin@oracle.com>
 <20130207102843.GG17781@cedar>
 <5113BABA.6010306@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5113BABA.6010306@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 09:31:22AM -0500, Sasha Levin wrote:
> On 02/07/2013 05:28 AM, Jamie Iles wrote:
> >> +int pthread_rwlock_init(pthread_rwlock_t *rwlock,
> >> > +			const pthread_rwlockattr_t *attr)
> >> > +{
> >> > +	if (ll_pthread_rwlock_init == NULL)
> >> > +		init_preload();
> > Why is this one special, doesn't init_preload being a constructor make 
> > this redundant?
> 
> I was testing it on different things, and stumbled on an interesting case:
> when pthread_mutex was taken from the constructor of a different module.
> 
> In that case, the other constructor would try to init the mutex and take
> a lock, but we would segfault because we haven't resolved the pthread
> symbols yet ourselves (since our constructor was yet to be called).

Okay, that makes sense, but shouldn't we do this for all of the lock 
operations?  pthread locks can be statically initialized and they are 
initializaed lazily on the first access so I think that this could 
happen on any of the lock operations.

Jamie
