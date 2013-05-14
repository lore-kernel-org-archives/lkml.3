Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183Ab3ENPnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:43:04 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:43484 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067Ab3ENPjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:39:15 -0400
Date: Tue, 14 May 2013 08:39:08 -0700
From: Tejun Heo <tj@kernel.org>
To: Dirk Gouders <dirk@gouders.net>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH wq/for-3.10-fixes] workqueue: workqueue_congested()
 shouldn't translate WORK_CPU_UNBOUND into node number
Message-ID: <20130514153908.GE6795@mtj.dyndns.org>
References: <20130510182110.GB15502@mtj.dyndns.org>
 <gi38tp7vqb.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gi38tp7vqb.fsf@karga.hank.lab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 11:32:12AM +0200, Dirk Gouders wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
> > From d3251859168b0b12841e1b90d6d768ab478dc23d Mon Sep 17 00:00:00 2001
> > From: Tejun Heo <tj@kernel.org>
> > Date: Fri, 10 May 2013 11:10:17 -0700
> >
> > df2d5ae499 ("workqueue: map an unbound workqueues to multiple per-node
> > pool_workqueues") made unbound workqueues to map to multiple per-node
> > pool_workqueues and accordingly updated workqueue_contested() so that,
> > for unbound workqueues, it maps the specified @cpu to the NUMA node
> > number to obtain the matching pool_workqueue to query the congested
> > state.
> >
> > Before this change, workqueue_congested() ignored @cpu for unbound
> > workqueues as there was only one pool_workqueue and some users
> > (fscache) called it with WORK_CPU_UNBOUND.  After the commit, this
> > causes the following oops as WORK_CPU_UNBOUND gets translated to
> > garbage by cpu_to_node().
> 
> I probably also noticed this problem with 3.10.0-rc1-00087-g674825d when
> I invoked init 0 (see attached oops).  I applied your patch and after
> that the problem has gone.

Thanks, sending the patch to Linus right now.

-- 
tejun
