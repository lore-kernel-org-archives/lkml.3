Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761020Ab3D3Rzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 13:55:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:38071 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760832Ab3D3Rzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 13:55:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,582,1363158000"; 
   d="scan'208";a="329068031"
Subject: Re: [PATCH 1/2] Make the batch size of the percpu_counter
 configurable
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <0000013e5c1377c5-49a8fca5-eb04-4e3a-a507-ce3a47fea685-000000@email.amazonses.com>
References: <c1f9c476a8bd1f5e7049b8ac79af48be61afd8f3.1367254913.git.tim.c.chen@linux.intel.com>
	 <0000013e5b24d2c5-9b899862-e2fd-4413-8094-4f1e5a0c0f62-000000@email.amazonses.com>
	 <1367339009.27102.174.camel@schen9-DESK>
	 <0000013e5bfd1548-a6ef7962-7b00-495b-8e83-d7a08413e165-000000@email.amazonses.com>
	 <1367344094.27102.182.camel@schen9-DESK>
	 <0000013e5c1377c5-49a8fca5-eb04-4e3a-a507-ce3a47fea685-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Apr 2013 10:55:22 -0700
Message-ID: <1367344522.27102.184.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-30 at 17:53 +0000, Christoph Lameter wrote:
> On Tue, 30 Apr 2013, Tim Chen wrote:
> 
> > > And why is it a pointer?
> >
> > A pointer because the default percpu_counter_batch value could change
> > later when cpus come online after we initialize per cpu counter and
> > percpu_counter_batch will get computed again in percpu_counter_startup.
> > Making it a pointer will make it unnecessary to come back and change the
> > batch sizes if we use static batch value and default batch size.
> 
> But you will have to dereference the pointer whenever you want the batch
> size from the hot path. Looks like it would be better to put the value
> there directly. You have a list of percpu counters that can be traversed
> to change the batch size.
> 

I have considered that.  But the list is not available unless we have
CONFIG_HOTPLUG_CPU compiled in.

Tim


