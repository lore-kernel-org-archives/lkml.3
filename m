Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbaLDR5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:57:18 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64826 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbaLDR5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:57:17 -0500
Date: Thu, 4 Dec 2014 12:57:13 -0500
From: Tejun Heo <tj@kernel.org>
To: Leonard Crestez <lcrestez@ixiacom.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Sorin Dumitru <sdumitru@ixiacom.com>
Subject: Re: [RFC v2] percpu: Add a separate function to merge free areas
Message-ID: <20141204175713.GE2995@htj.dyndns.org>
References: <547E3E57.3040908@ixiacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547E3E57.3040908@ixiacom.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 03, 2014 at 12:33:59AM +0200, Leonard Crestez wrote:
> It seems that free_percpu performance is very bad when working with small 
> objects. The easiest way to reproduce this is to allocate and then free a large 
> number of percpu int counters in order. Small objects (reference counters and 
> pointers) are common users of alloc_percpu and I think this should be fast.
> This particular issue can be encountered with very large number of net_device
> structs.

Do you actually experience this with an actual workload?  The thing is
allocation has the same quadratic complexity.  If this is actually an
issue (which can definitely be the case), I'd much prefer implementing
a properly scalable area allocator than mucking with the current
implementation.

Thanks.

-- 
tejun
