Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaJYUjl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 16:39:41 -0400
Received: from numascale.com ([213.162.240.84]:50560 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbaJYUjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 16:39:39 -0400
Message-ID: <544B4A4C.5070807@numascale.com>
Date: Sat, 25 Oct 2014 14:59:24 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Steffen Persvold <sp@numascale.com>, LKML <linux-kernel@vger.kernel.org>
Subject: RCU fanout leaf balancing
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Finding earlier reference to increasing RCU fanout leaf for the purpose 
of "decrease[ing] cache-miss overhead for large systems", would your 
suggestion be to increase the value to the next hierarchy core-count 
above 16?

If we have say 32 interconnected 48-core servers; 3 sockets of dual-node 
8-core Opteron 6300s, so 1536 cores in all. Latency across the coherent 
interconnect is O(100x) higher than the internal Hypertransport 
interconnect, so if we set RCU_FANOUT_LEAF to 48 to keep leaf-checking 
local to one Hypertransport fabric, what wisdom would one use for 
RCU_FANOUT? 4x leaf?

Or, would it be more cache-friendly to set RCU_FANOUT_LEAF to 8 and 
RCU_FANOUT to 48?

Many thanks,
   Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
