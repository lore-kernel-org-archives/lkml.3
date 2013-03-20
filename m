Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3CTHnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 03:43:09 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64499 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab3CTHnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 03:43:07 -0400
X-AuditID: 9c93016f-b7cecae000004cf8-86-5149688978a5
Date: Wed, 20 Mar 2013 16:43:30 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] sched: prevent to re-select dst-cpu in load_balance()
Message-ID: <20130320074330.GE11672@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1360820921-2513-8-git-send-email-iamjoonsoo.kim@lge.com>
 <1363705546.22553.61.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363705546.22553.61.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 04:05:46PM +0100, Peter Zijlstra wrote:
> On Thu, 2013-02-14 at 14:48 +0900, Joonsoo Kim wrote:
> > Commit 88b8dac0 makes load_balance() consider other cpus in its group.
> > But, in that, there is no code for preventing to re-select dst-cpu.
> > So, same dst-cpu can be selected over and over.
> > 
> > This patch add functionality to load_balance() in order to exclude
> > cpu which is selected once.
> 
> Oh man.. seriously? Did you see this happen? Also, can't we simply
> remove it from lb->cpus?

I didn't see it, I do just logical thinking. :)
lb->cpus is for source cpus and dst-cpu is for dest cpus. So, it doesn't
works to remove it from lb->cpus.

Thanks.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
