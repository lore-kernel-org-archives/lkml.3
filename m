Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab3CEUcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:32:39 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37567 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab3CEUch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:32:37 -0500
Message-ID: <1362514928.6267.16.camel@lambeau>
Subject: Re: [PATCH 0/4] Alter steal-time reporting in the guest
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Reply-To: mjw@linux.vnet.ibm.com
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, glommer@parallels.com, mingo@redhat.com,
        anthony@codemonkey.ws
Date: Tue, 05 Mar 2013 14:22:08 -0600
In-Reply-To: <20130219011104.GA5785@amt.cnet>
References: <20130205214818.4615.12937.stgit@lambeau>
	 <CAFTL4hyYO7s2u-dRLExA1=TxD00O1XyPe9qFwnODrWi_p92Jqg@mail.gmail.com>
	 <20130219011104.GA5785@amt.cnet>
Organization: IBM-LTC
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030520-7182-0000-0000-000005A76BC6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay in the response.  I did not see the email
right away.

On Mon, 2013-02-18 at 22:11 -0300, Marcelo Tosatti wrote:
> On Mon, Feb 18, 2013 at 05:43:47PM +0100, Frederic Weisbecker wrote:
> > 2013/2/5 Michael Wolf <mjw@linux.vnet.ibm.com>:
> > > In the case of where you have a system that is running in a
> > > capped or overcommitted environment the user may see steal time
> > > being reported in accounting tools such as top or vmstat.  This can
> > > cause confusion for the end user.
> > 
> > Sorry, I'm no expert in this area. But I don't really understand what
> > is confusing for the end user here.
> 
> I suppose that what is wanted is to subtract stolen time due to 'known
> reasons' from steal time reporting. 'Known reasons' being, for example,
> hard caps. So a vcpu executing instructions with no halt, but limited to
> 80% of available bandwidth, would not have 20% of stolen time reported.

Yes exactly and the end user many times did not set up the guest and is
not aware of the capping.  The end user is only aware of the performance
level that they were told they would get with the guest.  

> 
> But yes, a description of the scenario that is being dealt with, with
> details, is important.

I will add more detail to the description next time I submit the
patches.  How about something like,"In a cloud environment the user of a
kvm guest is not aware of the underlying hardware or how many other
guests are running on it.  The end user is only aware of a level of
performance that they should see."   or does that just muddy the picture
more??
> 
> > > To ease the confusion this patch set
> > > adds the idea of consigned (expected steal) time.  The host will separate
> > > the consigned time from the steal time.  Tthe steal time will only be altered
> > > if hard limits (cfs bandwidth control) is used.  The period and the quota used
> > > to separate the consigned time (expected steal) from the steal time are taken
> > > from the cfs bandwidth control settings. Any other steal time accruing during
> > > that period will show as the traditional steal time.
> > 
> > I'm also a bit confused here. steal time will then only account the
> > cpu time lost due to quotas from cfs bandwidth control? Also what do
> > you exactly mean by "expected steal time"? Is it steal time due to
> > overcommitting minus scheduler quotas?
> > 
> > Thanks.
> 

Thanks
Mike Wolf

