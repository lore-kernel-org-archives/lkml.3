Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaFSNg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:36:29 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:47906 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaFSNg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:36:28 -0400
Date: Thu, 19 Jun 2014 09:36:24 -0400
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, cl@linux-foundation.org,
        kmo@daterainc.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] percpu-refcount: implement percpu_ref_reinit() and
 percpu_ref_is_zero()
Message-ID: <20140619133624.GI11042@htj.dyndns.org>
References: <1403053685-28240-1-git-send-email-tj@kernel.org>
 <1403053685-28240-7-git-send-email-tj@kernel.org>
 <53A1097F.3060400@cn.fujitsu.com>
 <20140618153222.GA11042@htj.dyndns.org>
 <53A243B8.4010501@cn.fujitsu.com>
 <20140619020727.GC20100@mtj.dyndns.org>
 <20140619022708.GB4669@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619022708.GB4669@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Paul.

On Wed, Jun 18, 2014 at 07:27:08PM -0700, Paul E. McKenney wrote:
> Yep, smp_load_acquire() orders its load against later loads and stores,
> so it really does need a memory barrier on weakly ordered systems.

Yeap.

> This is the "publish" operation for dynamically allocated per-CPU
> references?  If so, agreed, you should be able to rely on dependency
> ordering.  Make sure to comment the smp_read_barrier_depends().  ;-)

Definitely, there aren't many things which are more frustrating than
barriers w/o comments explaining their pairing.  I'm pairing
store_release with read_barrier_depends as that's what RCU is doing.
Is this the preferred way now?  I like the new store_release and
load_acquire as they document what's being barriered better but as Lai
suggested in another reply it does seem a bit unbalanced.  I wonder
whether load_acquire_depends would make sense.

Thanks.

-- 
tejun
