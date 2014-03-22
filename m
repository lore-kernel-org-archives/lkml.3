Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaCVNyS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 09:54:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52206 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaCVNyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 09:54:15 -0400
Date: Sat, 22 Mar 2014 13:54:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [rcuwalk] e2a728c2785: -29.4% aim7.2000.jobs-per-min, +71%
 turbostat.Pkg_W
Message-ID: <20140322135412.GF18016@ZenIV.linux.org.uk>
References: <20140322115636.GA14400@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140322115636.GA14400@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 07:56:36PM +0800, Fengguang Wu wrote:
> Hi Al,
> 
> We noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git untested-mnt_hash
> commit e2a728c2785d6aab45d1a6d2c61e986d385c30bf ("rcuwalk: recheck mount_lock after mountpoint crossing attempts")

*doh*

Sorry about that - what happens is that __follow_mount_rcu() does that
check every time it's called, not on every negative lookup from
__lookup_mnt().  IOW, it's a massive overkill - most of the time
we don't call __lookup_mnt() at all, due to d_mountpoint() being false,
or get a positive from it.

Fixed and force-pushed; should get much better now...
