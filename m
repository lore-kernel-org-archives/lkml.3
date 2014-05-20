Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaETRGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:06:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:32768 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaETRGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:06:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,875,1392192000"; 
   d="scan'208";a="542223732"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Andi Kleen <ak@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/8] ixgbe: Out of line ixgbe_read/write_reg
Thread-Topic: [PATCH 1/8] ixgbe: Out of line ixgbe_read/write_reg
Thread-Index: AQHPcVAZKKq1T2MZKk2zTQ/UkJwTz5tI7lIAgAAXpoCAAShegA==
Date: Tue, 20 May 2014 17:06:17 +0000
Message-ID: <14DF3A68-94EE-499E-9B67-635CAF0AD6C7@intel.com>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
 <1400276595-6965-2-git-send-email-andi@firstfloor.org>
 <7477F573-2AED-4D26-8D5F-DB80DFA7EDEF@intel.com>
 <20140519232531.GJ19657@tassilo.jf.intel.com>
In-Reply-To: <20140519232531.GJ19657@tassilo.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.26.130]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8023E5A59B8A704F82EC141D71755564@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 19, 2014, at 4:25 PM, Andi Kleen <ak@linux.intel.com> wrote:

> On Mon, May 19, 2014 at 10:00:52PM +0000, Rustad, Mark D wrote:
>> On May 16, 2014, at 2:43 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> 
>>> From: Andi Kleen <ak@linux.intel.com>
>>> 
>>> ixgbe_read_reg and ixgbe_write_reg are frequently called and are very big
>>> because they have complex error handling code.
>> 
>> Actually, this patch doesn't do anything to ixgbe_write_reg, which would almost certainly be very bad for performance, but instead changes ixgbe_write_reg64.
> 
> I doubt a few cycles around the write make a lot of difference for MMIO. MMIO is dominated
> by other things.
> 
>> The latter is not in a performance-sensitive path, but is only called from one site, so there is little reason to take it out-of-line.
> 
> True I moved the wrong one.
> 
> ixgbe_write_reg                                    3305  (0.00%)  8     409  
> 
> 
>> I already have a patch in queue to make ixgbe_read_reg out-of-line, because it does have a very costly memory footprint inline, as you have found.
> 
> Please move write_reg too.

I will take a look at moving most of them out-of-line. There are just a few in very hot paths that should remain inline.

-- 
Mark Rustad, Networking Division, Intel Corporation

