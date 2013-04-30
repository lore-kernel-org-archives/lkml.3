Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297Ab3D3SKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:10:09 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:50696 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3D3SKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:10:06 -0400
Message-ID: <1367345403.11020.1.camel@edumazet-glaptop>
Subject: Re: [PATCH 1/2] Make the batch size of the percpu_counter
 configurable
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Date: Tue, 30 Apr 2013 11:10:03 -0700
In-Reply-To: <1367339009.27102.174.camel@schen9-DESK>
References: <c1f9c476a8bd1f5e7049b8ac79af48be61afd8f3.1367254913.git.tim.c.chen@linux.intel.com>
	 <0000013e5b24d2c5-9b899862-e2fd-4413-8094-4f1e5a0c0f62-000000@email.amazonses.com>
	 <1367339009.27102.174.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-30 at 09:23 -0700, Tim Chen wrote:
> On Tue, 2013-04-30 at 13:32 +0000, Christoph Lameter wrote:
> > On Mon, 29 Apr 2013, Tim Chen wrote:
> > 
> > > diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
> > > index d5dd465..5ca7df5 100644
> > > --- a/include/linux/percpu_counter.h
> > > +++ b/include/linux/percpu_counter.h
> > > @@ -22,6 +22,7 @@ struct percpu_counter {
> > >  	struct list_head list;	/* All percpu_counters are on a list */
> > >  #endif
> > >  	s32 __percpu *counters;
> > > +	int *batch ____cacheline_aligned_in_smp;
> > >  };
> > 
> > What is this for and why does it have that alignmend?
> 
> I was assuming that if batch is frequently referenced, it probably
> should not share a cache line with the counters field.

But 'counters' field has the same requirement. Its supposed to be read
only field. 

So please remove this '____cacheline_aligned_in_smp', as it makes the
whole struct percpu_counter at least two cache lines wide, for no
obvious reason.




