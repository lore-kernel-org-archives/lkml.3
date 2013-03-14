Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab3CNXFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 19:05:46 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27953 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3CNXFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 19:05:45 -0400
X-IronPort-AV: E=Sophos;i="4.84,848,1355126400"; 
   d="scan'208";a="29828381"
Message-ID: <514257B7.5080206@codeaurora.org>
Date: Thu, 14 Mar 2013 16:05:27 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Gaignard <benjamin.gaignard@stericsson.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: gen_pool_add broken with LPAE based systems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We use genalloc for managing certain pools of physical memory. genalloc 
currently uses unsigned long for virtual addresses and phys_addr_t for 
physical addresses. Our ARM LPAE systems have 64-bit physical addresses 
but unsigned long is still 32 bits.  Using gen_pool_add breaks with 
addresses > 4G because gen_pool_add treats the address passed in as the 
virtual address. gen_pool allocates internally based on the 32 bit 
virtual address as well so everything is broken if we want to be able to 
manage the full address space after 4G. I see a couple of options:

1) Change gen_pool_add to use physical addresses and allocate based on 
physical addresses instead of virtual addresses
2) Change the virtual address to be a 64 bit type or something 
selectable to a 64 bit type.
3) Allow a flag per pool to select whether the allocator is virtual or 
physical and switch between those.
4) Split the APIs into virtual <-> physical and physical only and have 
separate types for each.

Any of these suggestions seem reasonable or is there another option to 
consider?

Thanks,
Laura
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
