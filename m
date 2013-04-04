Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab3DDBmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 21:42:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:8963 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761598Ab3DDBmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 21:42:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="313340274"
Date: Thu, 4 Apr 2013 09:42:09 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Christopher Li <sparse@chrisli.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel/workqueue.c:4434:61: sparse: expression using sizeof bool
Message-ID: <20130404014209.GB7328@localhost>
References: <5156dabb.76yJdh7eK0MDrdWo%fengguang.wu@intel.com>
 <20130403215718.GH3411@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403215718.GH3411@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC Christopher and LKML.

On Wed, Apr 03, 2013 at 02:57:18PM -0700, Tejun Heo wrote:
> Hello, Fengguang.

Hi Tejun!

> On Sat, Mar 30, 2013 at 08:29:47PM +0800, kbuild test robot wrote:
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-better-dbg
> > head:   ea44ca757342b769c176fd6d0b3fb525b22eeda9
> > commit: c04655aeae70173688bca4c62b35737ab6958e82 workqueue: include workqueue info when printing debug dump of a worker task
> > date:   10 hours ago
> > 
> > 
> > sparse warnings: (new ones prefixed by >>)
> > 
> >    kernel/workqueue.c:287:8: sparse: symbol 'cpu_worker_pools' was not declared. Should it be static?
> >    kernel/workqueue.c:300:25: sparse: symbol 'system_highpri_wq' was not declared. Should it be static?
> > >> kernel/workqueue.c:4434:61: sparse: expression using sizeof bool
> >    kernel/workqueue.c:2060:32: sparse: context imbalance in 'manage_workers' - unexpected unlock
> > 
> > vim +4434 kernel/workqueue.c
> > 
> ...
> >   4433		/* copy worker description */
> > > 4434		probe_kernel_read(&desc_valid, &worker->desc_valid, sizeof(desc_valid));
> >   4435		if (desc_valid)
> 
> I don't know what to make of this warning.  Yes, it's probing a bool
> variable and of course using sizeof(bool) to do that.  Why does sparse
> complain about this?

I guess sparse warns on sizeof(bool) because it is compiler defined.
It may be 1, 4, or even 8 depending on the gcc version and platform.

Thanks,
Fengguang
