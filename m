Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaLROnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:43:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:59065 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaLROnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:43:20 -0500
Date: Thu, 18 Dec 2014 15:43:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eduardo Valentin <edubezval@gmail.com>
cc: Preeti Murthy <preeti.lkml@gmail.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        Peter Zijlstra <peterz@infradead.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] tick/powerclamp: Remove tick_nohz_idle abuse
In-Reply-To: <20141218140106.GA6323@developer>
Message-ID: <alpine.DEB.2.11.1412181507000.17382@nanos>
References: <alpine.DEB.2.11.1412181110110.17382@nanos> <20141218140106.GA6323@developer>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2014, Eduardo Valentin wrote:
> > The real solution is to fix the powerclamp driver by rewriting it with
> > a sane concept, but that's beyond the scope of this.
> > 
> 
> Do you have suggestions on what exactly is the expected rewriting or the
> correct sane concepts?

There was quite some discussion about this in this very thread.
 
> > So the only solution for now is to remove the calls into the core NOHZ
> > code from the powerclamp trainwreck along with the exports.
> > 
> > Fixes: d6d71ee4a14a "PM: Introduce Intel PowerClamp Driver"
> 
> If I got it right, the driver is currently broken due to changes in NOHZ
> core. So, does this patch fix power clamp behavior ?

The driver has been broken forever. It just worked by chance.

Now a very well justified and correct change in the core code exposed
that wreckage. So we have 2 choices:

  1) Get rid of the abuse and let powerclamp deal with the problem.
 
  2) Revert a correct patch for the sake of a 'works by chance' driver
     or put hacky workarounds in the core. Either of that will just
     paper over the real root cause until the next thing breaks in
     subtle ways.

#1 is the only sane decision. We cannot deal with misdesigned driver
   code in the NOHZ core.

> If I got your proposal right, in the end power clamp will be still
> broken, but at least won't be abusing NOHZ. Is that what you are
> proposing?

Yes, the design of powerclamp stays broken, but the NOHZ abuse is
gone. powerclamp will work, but it can't benefit from the possible
longer idle times anymore.

Thanks,

	tglx
