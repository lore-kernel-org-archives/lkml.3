Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbaIKWhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:37:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24851 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaIKWhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:37:03 -0400
Message-ID: <541223F9.2090500@oracle.com>
Date: Thu, 11 Sep 2014 18:36:41 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: kirill.shutemov@linux.intel.com, khlebnikov@openvz.org, riel@redhat.com,
        mgorman@suse.de, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz,
        hughd@google.com, vbabka@suse.cz, walken@google.com,
        minchan@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: introduce VM_BUG_ON_MM
References: <1410032326-4380-1-git-send-email-sasha.levin@oracle.com>	<1410032326-4380-2-git-send-email-sasha.levin@oracle.com> <20140911141629.e24f7fa5a2ec2401d4f3b429@linux-foundation.org>
In-Reply-To: <20140911141629.e24f7fa5a2ec2401d4f3b429@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 05:16 PM, Andrew Morton wrote:
> On Sat,  6 Sep 2014 15:38:45 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> Very similar to VM_BUG_ON_PAGE and VM_BUG_ON_VMA, dump struct_mm
>> when the bug is hit.
>>
>> ...
>>
>> +void dump_mm(const struct mm_struct *mm)
>> +{
>> +	printk(KERN_ALERT
> 
> I'm not sure why we should use KERN_ALERT here - KERN_EMERG is for
> "system is unusable", which is a fair descrition of a post-BUG kernel,
> yes?

Yes. I was following suit with dump_page and assumed there's a good reasoning
behind KERN_ALERT.

>> +		"mm %p mmap %p seqnum %d task_size %lu\n"
>> +#ifdef CONFIG_MMU
>> +		"get_unmapped_area %p\n"
>> +#endif
> 
> This printk is rather hilarious.  I can't think of a better way apart
> from a great string of individual printks.
> 
> And maybe we should use individual printks - dump_mm() presently uses
> 114 bytes of stack for that printk and that's somewhat of a concern
> considering the situations when it will be called.
> 
> 
> How's this look?

Works for me.


Thanks,
Sasha

