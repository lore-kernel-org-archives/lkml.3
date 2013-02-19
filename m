Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab3BSBUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 20:20:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab3BSBUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 20:20:22 -0500
Date: Mon, 18 Feb 2013 22:11:04 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michael Wolf <mjw@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, glommer@parallels.com, mingo@redhat.com,
        anthony@codemonkey.ws
Subject: Re: [PATCH 0/4] Alter steal-time reporting in the guest
Message-ID: <20130219011104.GA5785@amt.cnet>
References: <20130205214818.4615.12937.stgit@lambeau>
 <CAFTL4hyYO7s2u-dRLExA1=TxD00O1XyPe9qFwnODrWi_p92Jqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hyYO7s2u-dRLExA1=TxD00O1XyPe9qFwnODrWi_p92Jqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 05:43:47PM +0100, Frederic Weisbecker wrote:
> 2013/2/5 Michael Wolf <mjw@linux.vnet.ibm.com>:
> > In the case of where you have a system that is running in a
> > capped or overcommitted environment the user may see steal time
> > being reported in accounting tools such as top or vmstat.  This can
> > cause confusion for the end user.
> 
> Sorry, I'm no expert in this area. But I don't really understand what
> is confusing for the end user here.

I suppose that what is wanted is to subtract stolen time due to 'known
reasons' from steal time reporting. 'Known reasons' being, for example,
hard caps. So a vcpu executing instructions with no halt, but limited to
80% of available bandwidth, would not have 20% of stolen time reported.

But yes, a description of the scenario that is being dealt with, with
details, is important.

> > To ease the confusion this patch set
> > adds the idea of consigned (expected steal) time.  The host will separate
> > the consigned time from the steal time.  Tthe steal time will only be altered
> > if hard limits (cfs bandwidth control) is used.  The period and the quota used
> > to separate the consigned time (expected steal) from the steal time are taken
> > from the cfs bandwidth control settings. Any other steal time accruing during
> > that period will show as the traditional steal time.
> 
> I'm also a bit confused here. steal time will then only account the
> cpu time lost due to quotas from cfs bandwidth control? Also what do
> you exactly mean by "expected steal time"? Is it steal time due to
> overcommitting minus scheduler quotas?
> 
> Thanks.
