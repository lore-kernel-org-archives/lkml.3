Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaHOSLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:11:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:2180 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbaHOSLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:11:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,872,1400050800"; 
   d="scan'208";a="559134443"
Message-ID: <53EE4D11.5020001@intel.com>
Date: Fri, 15 Aug 2014 11:10:25 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Frantisek Hrbata <fhrbata@redhat.com>, linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com, akpm@linux-foundation.org, dvlasenk@redhat.com,
        prarit@redhat.com, lwoodman@redhat.com, hannsj_uhl@de.ibm.com
Subject: Re: [PATCH V2 2/2] x86: add phys addr validity check for /dev/mem
 mmap
References: <1408025927-16826-1-git-send-email-fhrbata@redhat.com> <1408103043-31015-1-git-send-email-fhrbata@redhat.com> <1408103043-31015-3-git-send-email-fhrbata@redhat.com>
In-Reply-To: <1408103043-31015-3-git-send-email-fhrbata@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2014 04:44 AM, Frantisek Hrbata wrote:
> +int valid_phys_addr_range(phys_addr_t addr, size_t count)
> +{
> +	return addr + count <= __pa(high_memory);
> +}
> +
> +int valid_mmap_phys_addr_range(unsigned long pfn, size_t count)
> +{
> +	return arch_pfn_possible(pfn + (count >> PAGE_SHIFT));
> +}

It definitely fixes the issue as you described it.

It's a bit unfortunate that the highmem check isn't tied in to the
_existing_ /dev/mem limitations in some way, but it's not a deal breaker
for me.

The only other thing is to make sure this doesn't add some limitation to
64-bit where we can't map things above the end of memory (end of memory
== high_memory on 64-bit).  As long as you've done this, I can't see a
downside.
