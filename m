Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580AbaLBTcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:32:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932967AbaLBTcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:32:13 -0500
Date: Tue, 2 Dec 2014 14:31:59 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141202193159.GA17595@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
 <20141127225637.GA24019@redhat.com>
 <m5dart$co$1@ger.gmane.org>
 <CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
 <547b8a45.6e608c0a.20f9.1002@mx.google.com>
 <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
 <547bbe36.48548c0a.105c.779c@mx.google.com>
 <20141201191431.GA17385@linux.vnet.ibm.com>
 <547ccf74.a5198c0a.25de.26d9@mx.google.com>
 <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 12:36:34PM -0800, Linus Torvalds wrote:
 > On Mon, Dec 1, 2014 at 12:28 PM, Dâniel Fraga <fragabr@gmail.com> wrote:
 > >
 > >         Hi Paul. Please, I'd like the patch, because without
 > > preemption, I'm unable to trigger this bug.
 > 
 > Ok, that's already interesting information. And yes, it would probably
 > be interesting to see if CONFIG_PREEMPT=y but !CONFIG_TREE_PREEMPT_RCU
 > then solves it too, to narrow it down to one but not the other..
 > 
 > DaveJ - what about your situation? The standard Fedora kernels use
 > CONFIG_PREEMPT_VOLUNTARY, do you have CONFIG_PREEMPT and
 > CONFIG_TREE_PREEMPT_RCU enabled?

I periodically switch PREEMPT options, just to see if anything new falls
out, though I've been on CONFIG_PREEMPT for quite a while.
So right now I'm testing the TREE_PREEMPT_RCU case.

I'm in the process of bisecting 3.16 -> 3.17 (currently on -rc1)
Thanksgiving kind of screwed up my flow, but 3.16 got a real
pounding for over 3 days with no problems.
I can give a !PREEMPT_RCU build a try, in case that turns out to
point to something quicker than a bisect is going to.

 > I think you and Sasha both saw some RCU oddities too, no?

I don't recall a kernel where I didn't see RCU oddities of some
description, but in recent times, not so much, though a few releases
back I did change some of the RCU related CONFIG options while
Paul & co were chasing down some bugs.

These days I've been running with..

# RCU Subsystem
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_TASKS_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# RCU Debugging
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y

	Dave

