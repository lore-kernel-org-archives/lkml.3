Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaHNRVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:21:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41637 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbaHNRVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:21:31 -0400
Message-ID: <53ECEFF5.1040800@zytor.com>
Date: Thu, 14 Aug 2014 10:20:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, Frantisek Hrbata <fhrbata@redhat.com>,
        linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        oleg@redhat.com, kamaleshb@in.ibm.com, hechjie@cn.ibm.com,
        akpm@linux-foundation.org, dvlasenk@redhat.com, prarit@redhat.com,
        lwoodman@redhat.com, hannsj_uhl@de.ibm.com
Subject: Re: [PATCH 1/1] x86: add phys addr validity check for /dev/mem mmap
References: <1408025927-16826-1-git-send-email-fhrbata@redhat.com> <1408025927-16826-2-git-send-email-fhrbata@redhat.com> <53ECE573.1030405@intel.com>
In-Reply-To: <53ECE573.1030405@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2014 09:36 AM, Dave Hansen wrote:
> Thanks for dredging this back up!
> 
> On 08/14/2014 07:18 AM, Frantisek Hrbata wrote:
>> +int valid_phys_addr_range(phys_addr_t addr, size_t count)
>> +{
>> +	return addr + count <= __pa(high_memory);
>> +}
> 
> Is this correct on 32-bit?  It would limit /dev/mem to memory below 896MB.
> 

Last I checked, /dev/mem was already broken for highmem... which is
actually a problem.  I would prefer to see it fixed.

	-hpa

