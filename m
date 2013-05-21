Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab3EUM3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 08:29:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:60367 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab3EUM3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 08:29:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,714,1363158000"; 
   d="scan'208";a="305660399"
Message-ID: <519B68A4.3010406@linux.intel.com>
Date: Tue, 21 May 2013 15:29:24 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alex Rosenbaum <alexr@mellanox.com>
CC: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v3 net-next 0/4] net: low latency Ethernet device polling
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com> <519B632F.7040202@mellanox.com>
In-Reply-To: <519B632F.7040202@mellanox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the questions you asked are covered in our RFC cover letter, but 
I will touch them briefly

On 21/05/2013 15:06, Alex Rosenbaum wrote:
> 1. It seem this patch does not cover epoll/select and such IO muxing APIs?

We are thinking about how to implement epoll support as one of the next 
steps.

What benchmarks are you using to test poll/select/epoll?


> 2. How is the logic aware of RSS and RFS?
>
> With TCP sockets, the driver knows the specific ring it need to poll so
> this should be mapped and provide the best latency.

This code is blissfully oblivious of RFS and RSS, it only assumes that 
the packets for a socket are likely to continue to come on the same queue.
The code is designed to be correct even if you get your data on the 
wrong queue. (your performance will suffer but no more than that.)


> 3. I could not find any reference to multi-thread on single core logic.
> This can causes the opposite effect and create contentions and higher
> latency’s.

Again, the only bad thing that will happen if you misconfigure this is a 
performance hit, we will not deadlock.

-Eliezer
