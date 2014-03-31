Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaCaXNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:13:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaCaXNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:13:10 -0400
Date: Mon, 31 Mar 2014 16:13:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
Message-Id: <20140331161308.6510381345cb9a1b419d5ec0@linux-foundation.org>
In-Reply-To: <1396306773.18499.22.camel@buesod1.americas.hpqcorp.net>
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>
	<20140331143217.c6ff958e1fd9944d78507418@linux-foundation.org>
	<1396306773.18499.22.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014 15:59:33 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:

> > 
> > - Shouldn't there be a way to alter this namespace's shm_ctlmax?
> 
> Unfortunately this would also add the complexity I previously mentioned.

But if the current namespace's shm_ctlmax is too small, you're screwed.
Have to shut down the namespace all the way back to init_ns and start
again.

> > - What happens if we just nuke the limit altogether and fall back to
> >   the next check, which presumably is the rlimit bounds?
> 
> afaik we only have rlimit for msgqueues. But in any case, while I like
> that simplicity, it's too late. Too many workloads (specially DBs) rely
> heavily on shmmax. Removing it and relying on something else would thus
> cause a lot of things to break.

It would permit larger shm segments - how could that break things?  It
would make most or all of these issues go away?



First principles: why does this thing exist?  What problem was SHMMAX
created to solve?  It doesn't appear to be part of posix:

http://pubs.opengroup.org/onlinepubs/000095399/functions/shmget.html

[ENOMEM]
    A shared memory identifier and associated shared memory segment
    shall be created, but the amount of available physical memory is
    not sufficient to fill the request.

