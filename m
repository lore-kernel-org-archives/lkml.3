Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbbAWQDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:03:42 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:48958 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbbAWQDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:03:39 -0500
Date: Fri, 23 Jan 2015 11:03:35 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au, mhocko@suse.cz, cl@linux.com
Subject: Re: mmotm 2015-01-22-15-04: qemu failure due to 'mm: memcontrol:
 remove unnecessary soft limit tree node test'
Message-ID: <20150123160335.GB32592@phnom.home.cmpxchg.org>
References: <54c1822d.RtdGfWPekQVAw8Ly%akpm@linux-foundation.org>
 <20150123050802.GB22751@roeck-us.net>
 <20150123141817.GA22926@phnom.home.cmpxchg.org>
 <54C26CE3.2060001@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C26CE3.2060001@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 07:46:43AM -0800, Guenter Roeck wrote:
> I added some debugging. First, the problem is only seen with SMP disabled.
> Second, there is only one online node.
> 
> Without your patch:
> 
> Node 0 online 1 high 1 memory 1 cpu 0 normal 1 tmp 0 rtpn c00000003d240600
> Node 1 online 0 high 0 memory 0 cpu 0 normal 0 tmp -1 rtpn c00000003d240640
> Node 2 online 0 high 0 memory 0 cpu 0 normal 0 tmp -1 rtpn c00000003d240680
> 
> [ and so on up to node 255 ]
> 
> With your patch:
> 
> Node 0 online 1 high 1 memory 1 cpu 0 normal 1 rtpn c00000003d240600
> Unable to handle kernel paging request for data at address 0x0000af50
> Faulting instruction address: 0xc000000000895a3c
> Oops: Kernel access of bad area, sig: 11 [#1]
> 
> The log message is after the call to kzalloc_node.
> 
> So it doesn't look like the fallback is working, at least not with ppc64
> in non-SMP mode.

Yep, and Christoph confirmed that it's not meant to work like that.
The patch is flawed.

Thanks for testing and sorry for breaking your setup.
