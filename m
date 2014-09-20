Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbaITF05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 01:26:57 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:54515 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457AbaITF04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 01:26:56 -0400
Date: Sat, 20 Sep 2014 01:26:53 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org, kmo@daterainc.com
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 3/3] percpu-refcount: make percpu_ref based on longs
 instead of ints
Message-ID: <20140920052653.GB7926@mtj.dyndns.org>
References: <1410142342-8185-1-git-send-email-tj@kernel.org>
 <1410142342-8185-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410142342-8185-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 11:12:22AM +0900, Tejun Heo wrote:
> percpu_ref is currently based on ints and the number of refs it can
> cover is (1 << 31).  This makes it impossible to use a percpu_ref to
> count memory objects or pages on 64bit machines as it may overflow.
> This forces those users to somehow aggregate the references before
> contributing to the percpu_ref which is often cumbersome and sometimes
> challenging to get the same level of performance as using the
> percpu_ref directly.
> 
> While using ints for the percpu counters makes them pack tighter on
> 64bit machines, the possible gain from using ints instead of longs is
> extremely small compared to the overall gain from per-cpu operation.
> This patch makes percpu_ref based on longs so that it can be used to
> directly count memory objects or pages.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kent Overstreet <kmo@daterainc.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>

Applied 1 and 3 to percpu/for-3.18.

Thanks.

-- 
tejun
