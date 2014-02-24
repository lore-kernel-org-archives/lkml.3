Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaBXHKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:10:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56012 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaBXHKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:10:34 -0500
Date: Mon, 24 Feb 2014 08:10:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
Message-ID: <20140224071028.GW9987@twins.programming.kicks-ass.net>
References: <5304F32A.4040907@oracle.com>
 <5305856F.3000109@linux.vnet.ibm.com>
 <53078241.3060201@oracle.com>
 <53080122.609@linux.vnet.ibm.com>
 <530ABB44.5000601@oracle.com>
 <530AD653.3000808@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530AD653.3000808@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 01:19:15PM +0800, Michael wang wrote:
> Peter, do we accidentally missed this commit?
> 
> http://git.kernel.org/tip/477af336ba06ef4c32e97892bb0d2027ce30f466

Ingo dropped it on Saturday because it makes locking_selftest() unhappy.

That is because we call locking_selftest() way before we're ready to
call schedule() and guess what it does :-/

I'm not entirely sure what to do.. ideally I'd shoot locking_selftest in
the head, but clearly that's not entirely desired either.
