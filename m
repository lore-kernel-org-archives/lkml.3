Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936065Ab3DIPIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:08:44 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:23552 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934973Ab3DIPIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:08:43 -0400
Message-ID: <51642EEB.1010204@parallels.com>
Date: Tue, 09 Apr 2013 19:08:27 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>, Matt Mackall <mpm@selenic.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFC PATCH 1/1] mm: Another attempt to monitor task's memory
 changes
References: <515F0484.1010703@parallels.com> <20130408153024.4edbcb491f18c948adbe9fe8@linux-foundation.org>
In-Reply-To: <20130408153024.4edbcb491f18c948adbe9fe8@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 02:30 AM, Andrew Morton wrote:
> On Fri, 05 Apr 2013 21:06:12 +0400 Pavel Emelyanov <xemul@parallels.com> wrote:
> 
>> Hello,
>>
>> This is another attempt (previous one was [1]) to implement support for 
>> memory snapshot for the the checkpoint-restore project (http://criu.org).
>> Let me remind what the issue is.
>>
>> << EOF
>> To create a dump of an application(s) we save all the information about it
>> to files, and the biggest part of such dump is the contents of tasks' memory.
>> However, there are usage scenarios where it's not required to get _all_ the
>> task memory while creating a dump. For example, when doing periodical dumps,
>> it's only required to take full memory dump only at the first step and then
>> take incremental changes of memory. Another example is live migration. We 
>> copy all the memory to the destination node without stopping all tasks, then
>> stop them, check for what pages has changed, dump it and the rest of the state,
>> then copy it to the destination node. This decreases freeze time significantly.
>>
>> That said, some help from kernel to watch how processes modify the contents
>> of their memory is required. Previous attempt used ftrace to inform userspace
>> about memory being written to. This one is different.
>>
>> EOF
> 
> Did you consider teaching the kernel to perform a strong hash on a
> page's contents so that userspace can do a before-and-after check to see
> if it changed?

I did (unless I misunderstood _your_ idea with hashes :( ), but judged, that
a single bit on a pte would be less cpu and memory consuming than calculating
and keeping 32/64 bits of hash value.


As far as all other comments are concerned -- thanks a LOT for the feedback!
I will address them all.


Thanks,
Pavel
