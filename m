Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbaE2PHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:07:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48882 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbaE2PHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:07:11 -0400
Date: Thu, 29 May 2014 17:07:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>
Subject: Re: perf: use after free in perf_remove_from_context
Message-ID: <20140529150705.GJ19143@laptop.programming.kicks-ass.net>
References: <5370EBE9.6@oracle.com>
 <20140514162943.GR30445@twins.programming.kicks-ass.net>
 <53739A9A.5010703@oracle.com>
 <20140514163535.GS30445@twins.programming.kicks-ass.net>
 <538676A7.6090306@oracle.com>
 <20140529075723.GA30445@twins.programming.kicks-ass.net>
 <5387486D.20108@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5387486D.20108@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 10:47:09AM -0400, Sasha Levin wrote:
> It doesn't work out well because we later lock a mutex in sync_child_event().
> 

Urgh, right you are. I'll go stare at it more. It shouldn't have
mattered, because the mutex we take just before should ensure existence,
but.. you know.. :-)
