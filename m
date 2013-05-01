Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881Ab3EAWsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:48:17 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57522 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759778Ab3EAWsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:48:13 -0400
Message-ID: <51819B9F.3090407@linux.vnet.ibm.com>
Date: Wed, 01 May 2013 15:47:59 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] mmzone: note that node_size_lock should be manipulated
 via pgdat_resize_lock()
References: <1367446635-12856-1-git-send-email-cody@linux.vnet.ibm.com> <1367446635-12856-4-git-send-email-cody@linux.vnet.ibm.com> <alpine.DEB.2.02.1305011528550.8804@chino.kir.corp.google.com> <51819900.1010301@linux.vnet.ibm.com> <alpine.DEB.2.02.1305011541260.8804@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1305011541260.8804@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050122-9360-0000-0000-000011FCE076
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 03:42 PM, David Rientjes wrote:
> On Wed, 1 May 2013, Cody P Schafer wrote:
>
>>>> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
>>>
>>> Nack, pgdat_resize_unlock() is unnecessary if irqs are known to be
>>> disabled.
>>>
>>
>> All this patch does is is indicate that rather than using node_size_lock
>> directly (as it won't be around without CONFIG_MEMORY_HOTPLUG), one should use
>> the pgdat_resize_[un]lock() helper macros.
>>
>
> I think that's obvious given the lock is surrounded by
> #ifdef CONFIG_MEMORY_HOTPLUG.  The fact remains that hotplug code need not
> use pgdat_resize_lock() if irqs are disabled.
>

Obvious how? This comment is the documentation on how to handle locking 
of pg_data_t, and doesn't mention pgdat_resize_lock() at all. Sure, a 
newcomer would probably find pgdat_resize_lock() eventually, even more 
so if they were interested in performance gains from not re-disabling 
local irqs.

I don't see a convincing reason to omit relevant documentation and make 
it more difficult to find the "right" way to do things.

