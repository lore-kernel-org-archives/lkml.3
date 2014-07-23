Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbaGWJZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:25:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:36162 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669AbaGWJZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:25:38 -0400
Date: Wed, 23 Jul 2014 11:25:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140723092536.GO12054@laptop.lan>
References: <53C77BB8.6030804@daenzer.net>
 <20140717075820.GE19379@twins.programming.kicks-ass.net>
 <53C8E90F.1010306@daenzer.net>
 <53CE00EF.70108@daenzer.net>
 <53CF31AE.30403@daenzer.net>
 <CA+55aFwyURgG717kmuAXzKcHddN_63GirtwHZB4ePKH+8qVtJw@mail.gmail.com>
 <20140723064948.GK3935@laptop>
 <53CF6CC4.6090207@daenzer.net>
 <20140723082819.GR3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723082819.GR3935@laptop>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:28:19AM +0200, Peter Zijlstra wrote:

> Of course, the other thing that patch did is clear sgp->power (now
> sgc->capacity). 

Hmm, re-reading the thread there isn't a clear confirmation its this
patch at all. Could you perhaps bisect this to either verify it is
indeed that patch we're talking about:

caffcdd8d27b ("sched: Do not zero sg->cpumask and sg->sgp->power in build_sched_groups()")

or find which patch is causing this.

