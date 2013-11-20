Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab3KTFv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 00:51:28 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:49823 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3KTFvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 00:51:25 -0500
Date: Wed, 20 Nov 2013 00:51:21 -0500
From: Tejun Heo <tj@kernel.org>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: cl@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] percpu: stop the loop when a cpu belongs to a new
 group
Message-ID: <20131120055121.GA13754@mtj.dyndns.org>
References: <1382345893-6644-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <20131027123008.GJ14934@mtj.dyndns.org>
 <20131028030055.GC15642@weiyang.vnet.ibm.com>
 <20131028113120.GB11541@mtj.dyndns.org>
 <20131028151746.GA7548@weiyang.vnet.ibm.com>
 <20131120030056.GA15273@weiyang.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120030056.GA15273@weiyang.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 20, 2013 at 11:00:56AM +0800, Wei Yang wrote:
> What do you think about this one?
> 
> >
> >From bd70498b9df47b25ff20054e24bb510c5430c0c3 Mon Sep 17 00:00:00 2001
> >From: Wei Yang <weiyang@linux.vnet.ibm.com>
> >Date: Thu, 10 Oct 2013 09:42:14 +0800
> >Subject: [PATCH] percpu: optimize group assignment when cpu_distance_fn is
> > NULL
> >
> >When cpu_distance_fn is NULL, all CPUs belongs to group 0. The original logic
> >will continue to go through each CPU and its predecessor. cpu_distance_fn is
> >always NULL when pcpu_build_alloc_info() is called from pcpu_page_first_chunk().
> >
> >By applying this patch, the time complexity will drop to O(n) form O(n^2) in
> >case cpu_distance_fn is NULL.

The test was put in the inner loop because the nesting was already too
deep and cpu_distance_fn is unlikely to be NULL on machines where the
number of CPUs is high enough to matter.  If that O(n^2) loop is gonna
be a problem, it's gonna be a problem on large NUMA machines and we'll
have to do something about it for cases where cpu_distance_fn exists
anyway.

The patch is just extremely marginal.  Ah well... why not?  I'll apply
it once -rc1 drops.

Thanks.

-- 
tejun
