Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbaBUXSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:18:41 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:40110 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbaBUXSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:18:37 -0500
X-Greylist: delayed 22862 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Feb 2014 18:18:37 EST
Date: Fri, 21 Feb 2014 18:18:33 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Message-ID: <20140221231833.GC12830@htj.dyndns.org>
References: <20140221015935.GF6897@htj.dyndns.org>
 <5306B4DF.4000901@hurleysoftware.com>
 <20140221021341.GG6897@htj.dyndns.org>
 <5306E06C.5020805@hurleysoftware.com>
 <20140221100301.GA14653@mtj.dyndns.org>
 <53074BE4.1020307@hurleysoftware.com>
 <20140221130614.GH6897@htj.dyndns.org>
 <5307849A.9050209@hurleysoftware.com>
 <20140221165730.GA10929@htj.dyndns.org>
 <5307DAC9.2020103@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5307DAC9.2020103@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 06:01:29PM -0500, Peter Hurley wrote:
> smp_mb__after_unlock_lock() is only for ordering memory operations
> between two spin-locked sections on either the same lock or by
> the same task/cpu. Like:
> 
>    i = 1
>    spin_unlock(lock1)
>    spin_lock(lock2)
>    smp_mb__after_unlock_lock()
>    j = 1
> 
> This guarantees that the store to j happens after the store to i.
> Without it, a cpu can
> 
>    spin_lock(lock2)
>    j = 1
>    i = 1
>    spin_unlock(lock1)

Hmmm?  I'm pretty sure that's a full barrier.  Local processor is
always in order (w.r.t. the compiler).

Thanks.

-- 
tejun
