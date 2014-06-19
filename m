Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310AbaFSTGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:06:54 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:34107 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbaFSTGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:06:52 -0400
Date: Thu, 19 Jun 2014 15:06:49 -0400
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, cl@linux-foundation.org,
        kmo@daterainc.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] percpu-refcount: implement percpu_ref_reinit()
 and percpu_ref_is_zero()
Message-ID: <20140619190649.GB7390@mtj.dyndns.org>
References: <1403053685-28240-1-git-send-email-tj@kernel.org>
 <1403053685-28240-7-git-send-email-tj@kernel.org>
 <20140619022055.GD20100@mtj.dyndns.org>
 <53A25286.1030003@cn.fujitsu.com>
 <20140619133104.GH11042@htj.dyndns.org>
 <20140619165501.GB4904@linux.vnet.ibm.com>
 <20140619170305.GA8723@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619170305.GA8723@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 10:03:05AM -0700, Paul E. McKenney wrote:
> documentation: Add acquire/release barriers to pairing rules
> 
> It is possible to pair acquire and release barriers with other barriers,
> so this commit adds them to the list in the SMP barrier pairing section.
> 
> Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index a6ca533a73fc..2a7c3c4fb53f 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -757,10 +757,12 @@ SMP BARRIER PAIRING
>  When dealing with CPU-CPU interactions, certain types of memory barrier should
>  always be paired.  A lack of appropriate pairing is almost certainly an error.
>  
> -A write barrier should always be paired with a data dependency barrier or read
> -barrier, though a general barrier would also be viable.  Similarly a read
> -barrier or a data dependency barrier should always be paired with at least an
> -write barrier, though, again, a general barrier is viable:
> +A write barrier should always be paired with a data dependency barrier,
> +acquire barrier, release barrier, or read barrier, though a general
> +barrier would also be viable.  Similarly a read barrier or a data
> +dependency barrier should always be paired with at least a write barrier,
> +an acquire barrier, or a release barrier, though, again, a general
> +barrier is viable:

FWIW,

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
