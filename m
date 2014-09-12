Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaILUMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:12:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbaILUMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:12:51 -0400
Date: Sat, 13 Sep 2014 05:12:41 +0900
From: Tejun Heo <theo@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Cc: Gustavo Luiz Duarte <gduarte@redhat.com>,
        Mike Anderson <mike.anderson@us.ibm.com>,
        Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH wq/for-3.18] workqueue: apply __WQ_ORDERED to
 create_singlethread_workqueue()
Message-ID: <20140912201241.GB23756@mtj.dyndns.org>
References: <20140912195328.GA23756@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140912195328.GA23756@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 04:53:28AM +0900, Tejun Heo wrote:
> From e141deffe6a30cfe7dd6ad97f21afa85b80ca3ac Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Sat, 13 Sep 2014 04:14:30 +0900
> 
> create_singlethread_workqueue() is a compat interface for singled
> threaded workqueue which maps to ordered workqueue w/ rescuer in the
> current implementation.  create_singlethread_workqueue() currently
> implemented by invoking alloc_workqueue() w/ appropriate parameters.
> 
> 8719dceae2f9 ("workqueue: reject adjusting max_active or applying
> attrs to ordered workqueues") introduced __WQ_ORDERED to protect
> ordered workqueues against dynamic attribute changes which can break
> ordering guarantees but forgot to apply it to
> create_singlethread_workqueue().  While this can be potentially
> dangerous, this isn't a problem in practice given the existing uses of
> dynamic attribute changes.
> 
> Let's make create_singlethread_workqueue() wrap
> alloc_ordered_workqueue() instead so that it inherits __WQ_ORDERED and
> can implicitly track future ordered_workqueue changes.

Oops, this is the right change but w/ wrong description and branch.
W/o __WQ_ORDERED, create_singlethread_workqueue() is broken on NUMA
setups.  Will respin the patch.

Thanks.

-- 
tejun
