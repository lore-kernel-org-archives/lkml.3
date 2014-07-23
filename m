Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbaGWPKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:10:11 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:59127 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095AbaGWPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:10:09 -0400
Date: Wed, 23 Jul 2014 11:10:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: get the probable node ID from the first CPU
 of the mask
Message-ID: <20140723151006.GC7103@htj.dyndns.org>
References: <1406005442-12070-1-git-send-email-laijs@cn.fujitsu.com>
 <20140722153023.GF13851@htj.dyndns.org>
 <53CF0F46.8000508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CF0F46.8000508@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 09:26:30AM +0800, Lai Jiangshan wrote:
> On 07/22/2014 11:30 PM, Tejun Heo wrote:
> > On Tue, Jul 22, 2014 at 01:04:02PM +0800, Lai Jiangshan wrote:
> >> +		node = cpu_to_node(cpumask_first(pool->attrs->cpumask));
> > 
> > Minor but maybe cpumask_any() is a better fit here?
> > 
> 
> It is OK, the result are the same. But I still think cpumask_first() is better since
> its name sounds deterministic while we need a deterministic value for pool->node.

The CPU can be any CPU in the mask.  That's the whole point of
cpumask_any().  Please use it.

-- 
tejun
