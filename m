Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaCFUwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:52:36 -0500
Received: from www.linutronix.de ([62.245.132.108]:56872 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaCFUwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:52:34 -0500
Date: Thu, 6 Mar 2014 21:52:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org
Subject: Re: preempt_check_resched() gone?
In-Reply-To: <20140306202705.GD3852@intel.com>
Message-ID: <alpine.DEB.2.02.1403062146060.18573@ionos.tec.linutronix.de>
References: <20140306202705.GD3852@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1340362852-1394139163=:18573"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1340362852-1394139163=:18573
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 6 Mar 2014, Ville Syrjälä wrote:
> Hi,
> 
> It appears preempt_check_resched() is no longer available for modules
> since [1]. So now I'm left wondering what is one supposed to use after
> local_irq_enable(). Documentation/preempt-locking.txt still says one
> should do a check, but the tool to do that was taken away.

The documentation is slightly misleading. The point is:

If you have an irq disabled section and you do a wakeup inside this
section which causes the need resched bit to be set, then
local_irq_enable/restore wont do an preemption check.

If you merily poke at a few device registers then nothing will set
need resched and you're good.

Thanks,

	tglx

 
--8323329-1340362852-1394139163=:18573--
