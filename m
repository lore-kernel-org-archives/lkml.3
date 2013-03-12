Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab3CLFYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:24:33 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:62094 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab3CLFYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:24:32 -0400
Date: Mon, 11 Mar 2013 22:24:26 -0700
From: Tejun Heo <tj@kernel.org>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        leiwen@marvell.com, wwang27@marvell.com
Subject: Re: workqueue panic in 3.4 kernel
Message-ID: <20130312052426.GV14556@mtj.dyndns.org>
References: <20130305163228.GA12795@htj.dyndns.org>
 <CALZhoSRyjRYVcKpq9cECHWgKkci6V+O_zn2CkiwqnFo57tZDfQ@mail.gmail.com>
 <20130306191408.GN1227@htj.dyndns.org>
 <CALZhoSTPBNjhUP4R=vX0Ot7eAA8POTAy8K5Cd3KRe_y8PzjfFA@mail.gmail.com>
 <CALZhoSRJ+HV93tDJo-57M-SdXi8Z6qW_bRV9FzSfGWuz8j-t8Q@mail.gmail.com>
 <20130307154907.GB29601@htj.dyndns.org>
 <alpine.LFD.2.02.1303071705310.22263@ionos>
 <CALZhoSQBH3RxSoaVDCYoCyRVRndht-Rk0rh_w5Dbp6+5T_auSw@mail.gmail.com>
 <20130312051215.GU14556@mtj.dyndns.org>
 <CALZhoSTnCC4si12xQXy2Cid5S2vAwOneOnZ_o2XNjidoqA9bsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZhoSTnCC4si12xQXy2Cid5S2vAwOneOnZ_o2XNjidoqA9bsg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 01:18:01PM +0800, Lei Wen wrote:
> > You're initializing random piece of memory which may contain any
> > garbage and triggering BUG if some bit is set on it. No, you can't do
> > that. debugobj is the right tool for debugging object lifetime issues
> > and is already supported.
> 
> The debugobj is not helping on this issue, I have enabled both
> CONFIG_DEBUG_OBJECTS_WORK and CONFIG_DEBUG_OBJECTS.
> But find they didn't report any issue at all.

It should. No idea why it didn't. Would be interesting to find out
why.

> And I am not init random memory, original issue is call init multi-times
> for one structure and that piece of memory already been allocated.
> And __INIT_WORK shouldn't call over random memory, right?

Memory areas aren't always zero on allocation.

-- 
tejun
