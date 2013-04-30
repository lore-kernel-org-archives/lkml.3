Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592Ab3D3TBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 15:01:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:35039 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933573Ab3D3TA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 15:00:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,582,1363158000"; 
   d="scan'208";a="329098267"
Subject: Re: [PATCH 1/2] Make the batch size of the percpu_counter
 configurable
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <0000013e5c32f7fd-b4bf1b22-7924-42b5-b835-eb2b5926bbf6-000000@email.amazonses.com>
References: <c1f9c476a8bd1f5e7049b8ac79af48be61afd8f3.1367254913.git.tim.c.chen@linux.intel.com>
	 <0000013e5b24d2c5-9b899862-e2fd-4413-8094-4f1e5a0c0f62-000000@email.amazonses.com>
	 <1367339009.27102.174.camel@schen9-DESK>
	 <0000013e5bfd1548-a6ef7962-7b00-495b-8e83-d7a08413e165-000000@email.amazonses.com>
	 <1367344094.27102.182.camel@schen9-DESK>
	 <0000013e5c1377c5-49a8fca5-eb04-4e3a-a507-ce3a47fea685-000000@email.amazonses.com>
	 <1367344522.27102.184.camel@schen9-DESK>
	 <0000013e5c32f7fd-b4bf1b22-7924-42b5-b835-eb2b5926bbf6-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Apr 2013 12:00:57 -0700
Message-ID: <1367348457.27102.197.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-30 at 18:27 +0000, Christoph Lameter wrote:
> On Tue, 30 Apr 2013, Tim Chen wrote:
> 
> > > But you will have to dereference the pointer whenever you want the batch
> > > size from the hot path. Looks like it would be better to put the value
> > > there directly. You have a list of percpu counters that can be traversed
> > > to change the batch size.
> > >
> >
> > I have considered that.  But the list is not available unless we have
> > CONFIG_HOTPLUG_CPU compiled in.
> 
> percpu counters are performance sensitive and with the pointer you
> will need to reference another one increasing the cache footprint. You are
> touching an additional cacheline somewhere in memory frequently. Not good.
> 

Seems like there's objection to make batch a pointer and I'll have to
store its value in per cpu pointer.

Will it be acceptable if I make the per cpu counter list under
CONFIG_CPU_HOTPLUG default? I will need the list to go through all
counters to update the batch value sizes.  The alternative will be to
make the configurable batch option only available under
CONFIG_HOTPLUG_CPU.

Which is the preferable approach or there are other clever alternatives?

Tim

