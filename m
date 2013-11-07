Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab3KGV6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 16:58:33 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:59650 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab3KGV6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 16:58:24 -0500
Message-ID: <527C0CF7.705@linux.vnet.ibm.com>
Date: Thu, 07 Nov 2013 13:58:15 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        rostedt@goodmis.org, Seth Jennings <sjennings@variantweb.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/11] rbtree: Fix rbtree_postorder_for_each_entry_safe()
 iterator
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com> <1383788572-25938-2-git-send-email-cody@linux.vnet.ibm.com> <20131107133800.c779b2f2b2ec73c91cd25f47@linux-foundation.org>
In-Reply-To: <20131107133800.c779b2f2b2ec73c91cd25f47@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110721-6688-0000-0000-000003473B25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 01:38 PM, Andrew Morton wrote:
> On Wed,  6 Nov 2013 17:42:30 -0800 Cody P Schafer <cody@linux.vnet.ibm.com> wrote:
>
>> The iterator rbtree_postorder_for_each_entry_safe() relies on pointer
>> underflow behavior when testing for loop termination. In particular
>> it expects that
>>    &rb_entry(NULL, type, field)->field
>> is NULL. But the result of this expression is not defined by a C standard
>> and some gcc versions (e.g. 4.3.4) assume the above expression can never
>> be equal to NULL. The net result is an oops because the iteration is not
>> properly terminated.
>>
>> Fix the problem by modifying the iterator to avoid pointer underflows.
>
> So the sole caller is in zswap.c.  Is that code actually generating oopses?

I can't reproduce the oopses (at all) with my build/gcc version, but Jan 
has reported seeing them (not in zswap, however).

>
> IOW, is there any need to fix this in 3.12 or earlier?
>

The zswap usage change showed up in 3.12.
In my opinion, it is probably a good idea to apply the fix to 3.12.

