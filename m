Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaIMAin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 20:38:43 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44174 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaIMAim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 20:38:42 -0400
Date: Fri, 12 Sep 2014 17:38:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Christoph Lameter <cl@linux.com>, Shan Wei <davidshan@tencent.com>,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, bobby.prani@gmail.com,
        Tejun Heo <htejun@gmail.com>
Subject: Re: [rcu] BUG: unable to handle kernel NULL pointer dereference at
 000000da
Message-ID: <20140913003837.GO4775@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140901084403.GA18808@localhost>
 <20140912190238.GJ4775@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409121413540.21514@gentwo.org>
 <20140912192659.GM4775@linux.vnet.ibm.com>
 <20140913002005.GA9550@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140913002005.GA9550@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091300-6688-0000-0000-000004B9C018
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 08:20:05AM +0800, Fengguang Wu wrote:
> On Fri, Sep 12, 2014 at 12:26:59PM -0700, Paul E. McKenney wrote:
> > On Fri, Sep 12, 2014 at 02:19:57PM -0500, Christoph Lameter wrote:
> > > On Fri, 12 Sep 2014, Paul E. McKenney wrote:
> > > 
> > > > So, I am not seeing this failure in my testing, but my best guess is
> > > > that the problem is due to the fact that force_quiescent_state() is
> > > > sometimes invoked with preemption enabled, which breaks __this_cpu_read()
> > > > though perhaps with very low probability.  The common-case call (from
> > > > __call_rcu_core()) -does- have preemption disabled, in fact, it has
> > > > interrupts disabled.
> > > 
> > > How could __this_cpu_read() break in a way that would make a difference to
> > > the code? There was no disabling/enabling of preemption before the patch
> > > and there is nothing like that after the patch. If there was a race then
> > > it still exists. The modification certainly cannot create a race.
> > 
> > Excellent question.  Yet Fengguang's tests show breakage.
> > 
> > Fengguang, any possibility of a false positive here?
> 
> Yes, it is possible. I find the first bad commit and its parent
> commit's kernels are built in 2 different machines which might
> cause subtle changes. I'll redo the bisect.

Thank you, Fengguang, and please let me know how it goes!

							Thanx, Paul

