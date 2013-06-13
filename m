Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab3FMXor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 19:44:47 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:43486 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3FMXop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 19:44:45 -0400
Date: Thu, 13 Jun 2013 16:44:59 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <theo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/2] percpu-refcount: implement percpu_tryget() along
 with percpu_ref_kill_and_confirm()
Message-ID: <20130613234459.GE28664@moria.home.lan>
References: <20130612204532.GB15092@htj.dyndns.org>
 <20130612204627.GC15092@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612204627.GC15092@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 01:46:27PM -0700, Tejun Heo wrote:
> From de3c0749e2c1960afcc433fc5da136b85c8bd896 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Wed, 12 Jun 2013 13:37:42 -0700
> 
> Implement percpu_tryget() which succeeds iff the refcount hasn't been
> killed yet.  Because the refcnt is per-cpu, different CPUs may have
> different perceptions on when the counter has been killed and tryget()
> may continue to succeed for a while after percpu_ref_kill() returns.
> 
> For use cases where it's necessary to know when all CPUs start to see
> the refcnt as dead, percpu_ref_kill_and_confirm() is added.  The new
> function takes an extra argument @confirm_kill which is invoked when
> the refcnt is guaranteed to be viewed as killed on all CPUs.
> 
> While this isn't the prettiest interface, it doesn't force synchronous
> wait and is much safer than requiring the caller to do its own
> call_rcu().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Kent Overstreet <koverstreet@google.com>
