Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaBGTxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:53:18 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:43338 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaBGTxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:53:17 -0500
Date: Fri, 7 Feb 2014 14:53:13 -0500
From: Tejun Heo <tj@kernel.org>
To: Imre Deak <imre.deak@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernfs: skip lockdep annotation always if ignore_lockdep
 is set
Message-ID: <20140207195313.GB8833@htj.dyndns.org>
References: <1391802421-7829-1-git-send-email-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391802421-7829-1-git-send-email-imre.deak@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 09:47:01PM +0200, Imre Deak wrote:
> We skip lockdep annotations for sysfs attributes with ignore_lockdep
> set. An exception is kernfs_deactivate where we annotate even in this
> case. Since the lockdep map key needed for the annotation is not
> initialized whenever ignore_lockdep is set, we'll get a warning for
> the uninitialized key.
> 
> Note that this happens since,
> 
> commit 517e64f57883bd63c5a4ab8b3d0d3ed68c55d0cf
> Author: Tejun Heo <tj@kernel.org>
> Date:   Thu Nov 28 14:54:29 2013 -0500
> 
> Before this change we had a valid key even in case of ignore_lockdep, so
> the annotation in kernfs_deactivate worked, or at least didn't produce
> the above warning. Fix this by skipping the annotation whenever
> ignore_lockdep is set.
> 
> The actual attribute triggering the bug was 'delete_device' in
> drivers/i2c/i2c-core.c, for the backtrace see the reference below.

I think Greg already has about the same patch queued.

  http://lkml.kernel.org/g/20140129170403.GJ30842@htj.dyndns.org

Thanks.

-- 
tejun
