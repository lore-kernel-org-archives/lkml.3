Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbaJ1BGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 21:06:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbaJ1BGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 21:06:17 -0400
Date: Tue, 28 Oct 2014 03:02:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, akpm@linux-foundation.org,
        hughd@google.com, riel@redhat.com, mgorman@suse.de,
        peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dbueso@suse.de, linux-mm@kvack.org
Subject: Re: [PATCH 05/10] uprobes: share the i_mmap_rwsem
Message-ID: <20141028020224.GA28581@redhat.com>
References: <1414188380-17376-1-git-send-email-dave@stgolabs.net> <1414188380-17376-6-git-send-email-dave@stgolabs.net> <20141027070329.GA10867@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027070329.GA10867@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27, Srikar Dronamraju wrote:
>
> Copying Oleg (since he should have been copied on this one)

Thanks ;)

> Please see one comment below.
>
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com> 
>
> > ---
> >  kernel/events/uprobes.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> > index 045b649..7a9e620 100644
> > --- a/kernel/events/uprobes.c
> > +++ b/kernel/events/uprobes.c
> > @@ -724,7 +724,7 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
> >  	int more = 0;
> >  
> >   again:
> > -	i_mmap_lock_write(mapping);
> > +	i_mmap_lock_read(mapping);

I too think the patch is fine.

I didn't see other changes, but I hope that i_mmap_lock_write/read names
provide enough info and ->i_mmap_mutex was turned into rw-lock,  in this
case read-lock should be enough.

Oleg.

