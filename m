Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaCELK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:10:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47842 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbaCELKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:10:24 -0500
Date: Wed, 5 Mar 2014 12:10:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Khalid Aziz <khalid.aziz@oracle.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk, oleg@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
Message-ID: <20140305111006.GT9987@twins.programming.kicks-ass.net>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
 <531641A8.40306@zytor.com>
 <53164824.3000704@oracle.com>
 <20140304222356.41c55bbc@alan.etchedpixels.co.uk>
 <5316574F.6040105@oracle.com>
 <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de>
 <8738ix5uyk.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738ix5uyk.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 04:51:15PM -0800, Andi Kleen wrote:
> Anything else?

Proxy execution; its a form of PI that works for arbitrary scheduling
policies (thus also very much including fair).

With that what you effectively end up with is the lock holder running
'boosted' by the runtime of its blocked chain until the entire chain
runs out of time, at which point preemption doesn't matter anyhow.
