Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab3HGSjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:39:12 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:49993 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab3HGSjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:39:10 -0400
Date: Wed, 7 Aug 2013 11:33:45 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 04/10] idr: Percpu ida
Message-ID: <20130807183345.GA11612@kmo-pixel>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
 <1375896905-6074-5-git-send-email-kmo@daterainc.com>
 <0000014059ec4c34-1bb53d48-c9ee-4e71-81b8-253026431c5c-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014059ec4c34-1bb53d48-c9ee-4e71-81b8-253026431c5c-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 05:56:34PM +0000, Christoph Lameter wrote:
> On Wed, 7 Aug 2013, Kent Overstreet wrote:
> 
> > +{
> > +	DEFINE_WAIT(wait);
> > +	struct percpu_ida_cpu *tags;
> > +	unsigned long flags;
> > +	unsigned this_cpu;
> > +	int tag;
> > +
> > +	local_irq_save(flags);
> 
> > +	this_cpu = smp_processor_id();
> > +	tags = per_cpu_ptr(pool->tag_cpu, this_cpu);
> 
> tags = this_cpu_ptr(pool->tag_cpu);

I was breaking it apart because I was using this_cpu elsewhere too - for
the bitmap of which cpus have non empty freelists.

Or is this_cpu_ptr() doing something smarter than per_cpu_ptr(ptr,
smp_processer_id())? There's so many variants I'm not 100% sure they're
the same.
