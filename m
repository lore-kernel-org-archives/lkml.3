Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3I0VVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 17:21:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40257 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab3I0VVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 17:21:08 -0400
Date: Fri, 27 Sep 2013 22:15:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vojtech Bocek <vbocek@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: About atags_proc buffer size
Message-ID: <20130927211537.GN12758@n2100.arm.linux.org.uk>
References: <5245E9C9.9030509@gmail.com> <20130927204743.GK12758@n2100.arm.linux.org.uk> <5245F3F9.5040004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5245F3F9.5040004@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 11:09:13PM +0200, Vojtech Bocek wrote:
> It only needs to survive until init_atags_procfs is called, because it is
> copied to another buffer for procfs entry. Can I be sure it survives until
> that? My guess is that it is likely to survive, but not certain.
> 
> I suppose it is possible to somehow protect that bit of ram until it is
> read by init_atags_procfs, but I wonder if you even want to do that in
> mainline - if majority of devices doesn't use such big tag lists, then
> it is probably that device's vendor problem. I've met this problem on two
> devices so far though, both of them Android phones, one is the HTC One
> (that is MSM APQ8064 SoC) and I unfortunately can't remember the first
> one - I discarded it as usual Android kernel's mess.

We've been through several early allocators - particularly one which
allocates from the bottom of memory upwards, which would overwrite the
ATAGs long before init_atags_procfs gets called.

If we rely on the behaviour of the current early allocator not to
touch that, and it changes in the future, that's going to be rather
too fragile.
