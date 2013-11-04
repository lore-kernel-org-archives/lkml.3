Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab3KDU7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:59:51 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:64224 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749Ab3KDU7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:59:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkAHACkKeFJ5LOn3/2dsb2JhbABZgweDPLdJhUWBKxd0giUBAQU6HCMQCAMYCSUPBSUDIROIAL5aFo9CB4QuA5Qrg16KRYdFgzoo
Date: Tue, 5 Nov 2013 07:59:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: bpm@sgi.com, elder@kernel.org, xfs@oss.sgi.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] xfs: simplify kmem_{zone_}zalloc
Message-ID: <20131104205943.GQ6188@dastard>
References: <52777511.1020605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52777511.1020605@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 06:21:05PM +0800, Gu Zheng wrote:
> Introduce flag KM_ZERO which is used to alloc zeroed entry, and convert
> kmem_{zone_}zalloc to call kmem_{zone_}alloc() with KM_ZERO directly,
> in order to avoid the setting to zero step. 
> And following Dave's suggestion, make kmem_{zone_}zalloc static inline
> into kmem.h as they're now just a simple wrapper.
> 
> V2:
>   Make kmem_{zone_}zalloc static inline into kmem.h as Dave suggested.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Looks good. It also results in a slight reduction in code size:

   text    data     bss     dec     hex filename
 792234   99018     632  891884   d9bec fs/xfs/xfs.o.orig
 792090   99018     632  891740   d9b5c fs/xfs/xfs.o

Which means making it inline hasn't cost us anything at individual
call sites.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
