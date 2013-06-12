Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab3FLXed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 19:34:33 -0400
Received: from mail-gh0-f175.google.com ([209.85.160.175]:63107 "EHLO
	mail-gh0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab3FLXeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 19:34:22 -0400
Date: Wed, 12 Jun 2013 16:34:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <theo@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/2] percpu-refcount: implement percpu_tryget() along
 with percpu_ref_kill_and_confirm()
Message-ID: <20130612233417.GA978@mtj.dyndns.org>
References: <20130612204532.GB15092@htj.dyndns.org>
 <20130612204627.GC15092@htj.dyndns.org>
 <20130612210824.GG6151@google.com>
 <20130612211747.GA2866@htj.dyndns.org>
 <20130612214630.GH6151@google.com>
 <20130612233151.GA32700@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612233151.GA32700@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 04:31:51PM -0700, Tejun Heo wrote:
> The original intention of the nested refcnting probably is allowing
> draining css's separately so that subsystems can be added and removed
> from an existing hierarchy.  That never worked out, so it could be
> that we can collapse all the css refcnts into cgroup refcnt, which BTW
> is currently using the dentry reference count.  I'm fairly certain
> that we can collapse it but that's a separate issue we can deal with
> later.

Hmmm.... I *think* we might need per-css refcnts to implement unified
hierarchy to allow turning on and off controllers along the single
hierarchy.  I'll think more about it but this is sorta off topic for
this series.

Thanks.

-- 
tejun
