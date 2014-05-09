Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbaEICps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 22:45:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:46522 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752123AbaEICpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 22:45:47 -0400
Message-ID: <1399603544.2272.6.camel@pippen.local.home>
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
From: Steven Rostedt <rostedt@goodmis.org>
To: David Lang <david@lang.hm>
Cc: Ingo Molnar <mingo@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Date: Thu, 08 May 2014 22:45:44 -0400
In-Reply-To: <alpine.DEB.2.02.1405081840580.17457@nftneq.ynat.uz>
References: <cover.1398958771.git.jpoimboe@redhat.com>
	 <alpine.LRH.2.00.1405021504320.22053@twin.jikos.cz>
	 <alpine.DEB.2.02.1405051633080.14881@nftneq.ynat.uz>
	 <alpine.LNX.2.00.1405060147190.3969@pobox.suse.cz>
	 <20140506073228.GA26271@gmail.com>
	 <20140506122302.GC4125@treble.redhat.com>
	 <20140507121924.GA12234@gmail.com>
	 <alpine.DEB.2.02.1405081840580.17457@nftneq.ynat.uz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-08 at 18:46 -0700, David Lang wrote:
> On Wed, 7 May 2014, Ingo Molnar wrote:

> It's possible to have two versions of code that each work independently, but 
> that you can't switch between easily on the fly.
> 
> If the new code assumes a lock is held that the old code didn't take, then when 
> you switch, you are eventually going to hit a case where the new code trys to 
> release a lock it doesn't hold.

But we are replacing full functions here. Never half way through. Thus,
there should never be "old code didn't take", because we replace the
entire function. If the new code expects a lock to be held where the old
code did not, there's nothing changing anything that leads up to this
new code. The lock still won't be taken.

A patch that expects that wont work on a reboot either.

> 
> detecting all possible cases progromatically seems close to impossible.
> 
> but this means that there are two categories of patches
> 
> 1. patches that are safe to put in a kernel that you are going to boot from
> 
> 2. patches that are able to be applied on the fly
> 
> and the tool isn't going to be able to tell you which category the patch is in. 
> It can identify some of the items that make it unlikely or impossible for the 
> patch to belong to #2, but don't rely on the tool catching all of them

I agree that live patching is going to be a bit trickier than patches
that are applied for reboot. And I also agree that no tool could
determine if the patch can be applied live even if it could be applied
safely for reboot. To do so would probably be on the difficulty scale of
the halting problem.

-- Steve


