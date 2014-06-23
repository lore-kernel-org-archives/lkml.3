Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbaFWQWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:22:37 -0400
Received: from one.firstfloor.org ([193.170.194.197]:52335 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbaFWQWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:22:36 -0400
Date: Mon, 23 Jun 2014 18:22:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, Jason Low <jason.low2@hp.com>,
        Davidlohr Bueson <davidlohr@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sched: Fast idling of CPU when system is partially
 loaded
Message-ID: <20140623162234.GP5714@two.firstfloor.org>
References: <1402948127.2970.578.camel@schen9-DESK>
 <20140623125233.GZ19860@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623125233.GZ19860@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I don't get why we can't do the below; I think Jason tried to ask the
> same...

The important part for performance is to minimize the cache line transfers. Your
unconditional variant would cause more dirty cache lines than Tim's,
right?

-Andi
