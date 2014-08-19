Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaHSMfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:35:19 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:59783 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094AbaHSMfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:35:18 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sam Asadi <asadi.samuel@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andreas Mohr <andi@lisas.de>
Subject: Re: i8k: Don't revert affinity in i8k_smm
Date: Tue, 19 Aug 2014 22:34:01 +1000
Message-ID: <2237747.k7D4k1cquT@hex>
User-Agent: KMail/4.13.3 (Linux/3.16.0-ck1; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140819023215.GA32051@roeck-us.net>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com> <1454445.ErZ3u1p0yH@hex> <20140819023215.GA32051@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2014 07:32:15 PM Guenter Roeck wrote:
> On Tue, Aug 19, 2014 at 09:19:55AM +1000, Con Kolivas wrote:
> > As a followup to this discussion:
> > 
> > On Tue, 15 Jul 2014 08:01:13 PM Sam Asadi wrote:
> > > Commit f36fdb9f0266 (i8k: Force SMM to run on CPU 0) adds support
> > > for multi-core CPUs to the driver. Unfortunately, that causes it
> > > to fail loading if compiled without SMP support, at least on
> > > 32 bit kernels. Kernel log shows "i8k: unable to get SMM Dell
> > > signature", and function i8k_smm is found to return -EINVAL.
> > > 
> > > Testing revealed that the culprit is the missing return value check
> > > of set_cpus_allowed_ptr.
> > 
> > It appears that the original commit f36fdb9f0266 changes the affinity for
> > the duration of i8k_smm function and then unconditionally reverts the
> > affinity to the old cpu mask regardless of whether the function succeeds
> > or fails. As this must run on CPU 0 at all times it does not make sense
> > to revert the affinity at the end of the function. Proposed patch
> > attached.
> 
> Sorry, I must have missed the rest of the discussion. What problem is this
> patch supposed to fix ? Or, in other words, is there a problem with the
> current code ? I also don't really understand the argument above. Why does
> it not make sense to revert to the original affinity ? After all, only the
> SMM call must run on CPU 0. Why does it not make sense to let the rest of
> the code run on another CPU ?

My mistake. If only the i8k_smm function needs to run on CPU 0 then it is 
appropriate to return affinity to the previous CPU mask. Please disregard and 
apologies for the noise.

Thanks,
Con
-- 
-ck

