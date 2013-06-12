Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab3FLUzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:55:07 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52995 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab3FLUzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:55:04 -0400
Date: Wed, 12 Jun 2013 13:55:00 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <theo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH percpu/for-3.11] percpu-refcount: consistently use plain
 (non-sched) RCU
Message-ID: <20130612205500.GE6151@google.com>
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

Acked-by: Kent Overstreet <koverstreet@google.com>
