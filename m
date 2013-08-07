Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab3HGVMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:12:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56586 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933352Ab3HGVMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:12:45 -0400
Date: Wed, 7 Aug 2013 23:12:37 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: PREEMPT_RT vs bcache
Message-ID: <20130807211237.GM6104@pengutronix.de>
References: <1375907298.27403.35.camel@deadeye.wl.decadent.org.uk>
 <20130807205357.GD11612@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130807205357.GD11612@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 01:53:57PM -0700, Kent Overstreet wrote:
> On Wed, Aug 07, 2013 at 10:28:18PM +0200, Ben Hutchings wrote:
> > As Kent said back in 2011 (commit 84759c6d18c5), bcache needs
> > {down,up}_read_non_owner().  But these are not implemented by the -rt
> > patchset when PREEMPT_RT_FULL is enabled.  Can they be added, or is
> > there a fundamental conflict here?
> 
> You should be able to cherry pick
> 84759c6d18c5144432781ddca037d929ee9db8a5 (Revert "rw_semaphore: remove
> up/down_read_non_owner") - that went in when bcache was merged.
That doesn't help with PREEMPT_RT_FULL because include/linux/rwsem.h
looks like:

	[ ... some includes ... ]
	#ifdef CONFIG_PREEMPT_RT_FULL
	#include <linux/rwsem_rt.h>
	#else /* PREEMPT_RT_FULL */
	[ ... vanilla content including definitions of {down,up}_read_non_owner]
	#endif

So Ben's question was how (if at all) we should implement
{down,up}_read_non_owner for PREEMPT_RT_FULL.
Is it save to just use the vanilla implementation on RT?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
