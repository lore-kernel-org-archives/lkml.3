Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761293Ab3D3S2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:28:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:46630 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760859Ab3D3S2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:28:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,582,1363158000"; 
   d="scan'208";a="329081650"
Subject: Re: [PATCH 1/2] Make the batch size of the percpu_counter
 configurable
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <1367345403.11020.1.camel@edumazet-glaptop>
References: <c1f9c476a8bd1f5e7049b8ac79af48be61afd8f3.1367254913.git.tim.c.chen@linux.intel.com>
	 <0000013e5b24d2c5-9b899862-e2fd-4413-8094-4f1e5a0c0f62-000000@email.amazonses.com>
	 <1367339009.27102.174.camel@schen9-DESK>
	 <1367345403.11020.1.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Apr 2013 11:28:09 -0700
Message-ID: <1367346489.27102.185.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-30 at 11:10 -0700, Eric Dumazet wrote:
> On Tue, 2013-04-30 at 09:23 -0700, Tim Chen wrote:
> > On Tue, 2013-04-30 at 13:32 +0000, Christoph Lameter wrote:
> > > On Mon, 29 Apr 2013, Tim Chen wrote:
> > > 
> > > > diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
> > > > index d5dd465..5ca7df5 100644
> > > > --- a/include/linux/percpu_counter.h
> > > > +++ b/include/linux/percpu_counter.h
> > > > @@ -22,6 +22,7 @@ struct percpu_counter {
> > > >  	struct list_head list;	/* All percpu_counters are on a list */
> > > >  #endif
> > > >  	s32 __percpu *counters;
> > > > +	int *batch ____cacheline_aligned_in_smp;
> > > >  };
> > > 
> > > What is this for and why does it have that alignmend?
> > 
> > I was assuming that if batch is frequently referenced, it probably
> > should not share a cache line with the counters field.
> 
> But 'counters' field has the same requirement. Its supposed to be read
> only field. 
> 
> So please remove this '____cacheline_aligned_in_smp', as it makes the
> whole struct percpu_counter at least two cache lines wide, for no
> obvious reason.
> 

Will do.

Thanks.

Tim

