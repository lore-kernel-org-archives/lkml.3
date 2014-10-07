Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaJGB16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 21:27:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbaJGB14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 21:27:56 -0400
Date: Mon, 6 Oct 2014 21:27:44 -0400
From: Dave Jones <davej@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RCU stalls -> lockup.
Message-ID: <20141007012744.GA25036@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20141002175515.GA28665@redhat.com>
 <20141002193655.GS5015@linux.vnet.ibm.com>
 <20141005021556.GC8549@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141005021556.GC8549@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2014 at 10:15:56PM -0400, Tejun Heo wrote:
 > On Thu, Oct 02, 2014 at 12:36:55PM -0700, Paul E. McKenney wrote:
 > > On Thu, Oct 02, 2014 at 01:55:15PM -0400, Dave Jones wrote:
 > > > I just hit this on my box running 3.17rc7
 > > > It was followed by a userspace lockup. (Could still ping, and sysrq
 > > > from the console, but even getty wasn't responding on the console).
 > > > 
 > > > I was trying to reproduce another bug faster, and had ramped up the
 > > > number of processes trinity to uses to 512. This didn't take long
 > > > to fall out..
 > > 
 > > This might be related to an exchange I had with Tejun (CCed), where
 > > the work queues were running all out, preventing any quiescent states
 > > from happening.  One fix under consideration is to add a quiescent state,
 > > similar to the one in softirq handling.
 > 
 > Dave, can you please test whether the following patch makes a
 > difference if the problem is reproducible?
 > 
 >   http://lkml.kernel.org/r/20141003153701.7c7da030@jlaw-desktop.mno.stratus.com

initial tests look good, haven't seen any reoccurance of the problem so far.

	Dave

