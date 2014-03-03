Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaCCWo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:44:59 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31256 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbaCCWo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:44:58 -0500
Message-ID: <531505E4.8020802@oracle.com>
Date: Mon, 03 Mar 2014 17:44:52 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernfs: possible deadlock between of->mutex and mmap_sem
References: <53113485.2090407@oracle.com> <20140303223933.GC26523@mtj.dyndns.org>
In-Reply-To: <20140303223933.GC26523@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 05:39 PM, Tejun Heo wrote:
> On Fri, Feb 28, 2014 at 08:14:45PM -0500, Sasha Levin wrote:
>> Hi all,
>>
>> I've stumbled on the following while fuzzing with trinity inside a
>> KVM tools running the latest -next kernel.
>>
>> We deal with files that have an mmap op by giving them a different
>> locking class than the files which don't due to mmap_sem nesting
>> being different for those files.
>>
>> We assume that for mmap supporting files, of->mutex will be nested
>> inside mm->mmap_sem. However, this is not always the case. Consider
>> the following:
>>
>> 	kernfs_fop_write()
>> 		copy_from_user()
>> 			might_fault()
>>
>> might_fault() suggests that we may lock mm->mmap_sem, which causes a
>> reverse lock nesting of mm->mmap_sem inside of of->mutex.
>>
>> I'll send a patch to fix it some time next week unless someone beats me to it :)
>
> How are you planning to fix it?  Prolly the right thing to do would be
> caching atomic_write_len in open_file and copy data before grabbing
> any locks.

I've actually didn't have a plan when I wrote that, was just planning on putting effort into it.


Thanks,
Sasha

