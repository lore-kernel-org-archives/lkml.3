Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab3CTMia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:38:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36937 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960Ab3CTMi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:38:29 -0400
Message-ID: <1363783096.3724.5.camel@laptop>
Subject: Re: [PATCH 7/8] sched: prevent to re-select dst-cpu in
 load_balance()
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 13:38:16 +0100
In-Reply-To: <20130320074330.GE11672@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1360820921-2513-8-git-send-email-iamjoonsoo.kim@lge.com>
	 <1363705546.22553.61.camel@laptop> <20130320074330.GE11672@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 16:43 +0900, Joonsoo Kim wrote:
> On Tue, Mar 19, 2013 at 04:05:46PM +0100, Peter Zijlstra wrote:
> > On Thu, 2013-02-14 at 14:48 +0900, Joonsoo Kim wrote:
> > > Commit 88b8dac0 makes load_balance() consider other cpus in its group.
> > > But, in that, there is no code for preventing to re-select dst-cpu.
> > > So, same dst-cpu can be selected over and over.
> > > 
> > > This patch add functionality to load_balance() in order to exclude
> > > cpu which is selected once.
> > 
> > Oh man.. seriously? Did you see this happen? Also, can't we simply
> > remove it from lb->cpus?
> 
> I didn't see it, I do just logical thinking. :)
> lb->cpus is for source cpus and dst-cpu is for dest cpus. So, it doesn't
> works to remove it from lb->cpus.

How about we interpret ->cpus as the total mask to balance; so both
source and destination. That way clearing a cpu means we won't take nor
put tasks on it.

