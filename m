Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaILT0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:26:08 -0400
Received: from qmta11.westchester.pa.mail.comcast.net ([76.96.59.211]:46932
	"EHLO QMTA11.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845AbaILT0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:26:06 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2014 15:26:06 EDT
Date: Fri, 12 Sep 2014 14:19:57 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Fengguang Wu <fengguang.wu@intel.com>, Shan Wei <davidshan@tencent.com>,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, bobby.prani@gmail.com,
        Tejun Heo <htejun@gmail.com>
Subject: Re: [rcu] BUG: unable to handle kernel NULL pointer dereference at
 000000da
In-Reply-To: <20140912190238.GJ4775@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1409121413540.21514@gentwo.org>
References: <20140901084403.GA18808@localhost> <20140912190238.GJ4775@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Paul E. McKenney wrote:

> So, I am not seeing this failure in my testing, but my best guess is
> that the problem is due to the fact that force_quiescent_state() is
> sometimes invoked with preemption enabled, which breaks __this_cpu_read()
> though perhaps with very low probability.  The common-case call (from
> __call_rcu_core()) -does- have preemption disabled, in fact, it has
> interrupts disabled.

How could __this_cpu_read() break in a way that would make a difference to
the code? There was no disabling/enabling of preemption before the patch
and there is nothing like that after the patch. If there was a race then
it still exists. The modification certainly cannot create a race.


