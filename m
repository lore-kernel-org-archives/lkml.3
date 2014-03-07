Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbaCGMO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:14:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:61460 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbaCGMO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:14:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,607,1389772800"; 
   d="scan'208";a="494131390"
Date: Fri, 7 Mar 2014 14:14:23 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org
Subject: Re: preempt_check_resched() gone?
Message-ID: <20140307121423.GI3852@intel.com>
References: <20140306202705.GD3852@intel.com>
 <alpine.DEB.2.02.1403062146060.18573@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.02.1403062146060.18573@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 09:52:42PM +0100, Thomas Gleixner wrote:
> On Thu, 6 Mar 2014, Ville Syrjälä wrote:
> > Hi,
> > 
> > It appears preempt_check_resched() is no longer available for modules
> > since [1]. So now I'm left wondering what is one supposed to use after
> > local_irq_enable(). Documentation/preempt-locking.txt still says one
> > should do a check, but the tool to do that was taken away.
> 
> The documentation is slightly misleading. The point is:
> 
> If you have an irq disabled section and you do a wakeup inside this
> section which causes the need resched bit to be set, then
> local_irq_enable/restore wont do an preemption check.
> 
> If you merily poke at a few device registers then nothing will set
> need resched and you're good.

OK. There are a few extra things that get called while irqs are
disabled: prepare_to_wait(), finish_wait(), mod_timer(),
spin_{lock,unlock}(). Based on a quick glance none of those should
do anything I need to worry about, so I'll just drop
preempt_check_resched() from my code.

Thanks.

-- 
Ville Syrjälä
Intel OTC
