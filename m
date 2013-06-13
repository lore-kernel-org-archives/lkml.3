Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab3FMDs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 23:48:28 -0400
Received: from mail-ye0-f169.google.com ([209.85.213.169]:40836 "EHLO
	mail-ye0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab3FMDs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 23:48:27 -0400
Date: Wed, 12 Jun 2013 20:48:21 -0700
From: Tejun Heo <tj@kernel.org>
To: Tejun Heo <theo@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH percpu/for-3.11] percpu-refcount: consistently use plain
 (non-sched) RCU
Message-ID: <20130613034821.GA9451@mtj.dyndns.org>
References: <20130612204031.GA15092@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612204031.GA15092@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 01:40:32PM -0700, Tejun Heo wrote:
> From e96262150a513ce3d54ff221d4ace8aeec96e0bf Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Wed, 12 Jun 2013 13:37:42 -0700
> 
> percpu_ref_get/put() are using preempt_disable/enable() while
> percpu_ref_kill() is using plain call_rcu() instead of
> call_rcu_sched().  This is buggy as grace periods of the two may not
> match.  Fix it by using plain RCU in percpu_ref_get/put().
> 
> (I suggested using sched RCU in the first place but there's no actual
>  benefit in doing so unless we're gonna introduce different variants
>  of get/put to be called while preemption is alredy disabled, which we
>  definitely shouldn't.)
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Rusty Russell <rusty@rustcorp.com.au>

Applied to percpu/for-3.11.

Thanks.

-- 
tejun
