Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaFFSlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:41:13 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:2501 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaFFSlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:41:12 -0400
Message-ID: <1402080068.14433.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC PATCH 1/1] cleanup: use bool as return type for
 rwsem_is_locked
From: Davidlohr Bueso <davidlohr@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Pranith Kumar <pranith@gatech.edu>, linux-kernel@vger.kernel.org,
        tim.c.chen@linux.intel.com, mingo@redhat.com
Date: Fri, 06 Jun 2014 11:41:08 -0700
In-Reply-To: <20140606175655.GX13930@laptop.programming.kicks-ass.net>
References: <5390D7E1.7060606@gatech.edu> <5391FFFD.1060901@gatech.edu>
	 <20140606175655.GX13930@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 19:56 +0200, Peter Zijlstra wrote:
> On Fri, Jun 06, 2014 at 01:53:01PM -0400, Pranith Kumar wrote:
> > On Fri, Jun 6, 2014 at 3:35 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > Now in general, I don't particularly like such superfluous changes, so
> > > unless you can show that GCC actually generates better code, I'd prefer
> > > to keep things as they are.
> > 
> > Fixed and checked the assembly. It saves us 2 bytes of code, not much. I am not sure if that is worth it :(
> 
> still 2 bytes, so sure.
> 
> Which gcc did you use and what arch did you build? That might be useful
> info for the changelog.

Yeah, please attach the output of 'size kernel/locking/rwsem.o' for both
before and after. I think there's similar opportunity in other locking
code as well.

