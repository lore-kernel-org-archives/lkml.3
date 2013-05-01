Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802Ab3EAWcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:32:14 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:43547 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab3EAWcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:32:11 -0400
Message-ID: <518197E2.7050004@linux.vnet.ibm.com>
Date: Wed, 01 May 2013 15:32:02 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] mmzone: make holding lock_memory_hotplug() a requirement
 for updating pgdat size
References: <1367446635-12856-1-git-send-email-cody@linux.vnet.ibm.com> <1367446635-12856-2-git-send-email-cody@linux.vnet.ibm.com> <alpine.DEB.2.02.1305011525580.8804@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1305011525580.8804@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050122-7408-0000-0000-00000FB7B14D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 03:26 PM, David Rientjes wrote:
> On Wed, 1 May 2013, Cody P Schafer wrote:
>
>> All updaters of pgdat size (spanned_pages, start_pfn, and
>> present_pages) currently also hold lock_memory_hotplug() (in addition
>> to pgdat_resize_lock()).
>>
>> Document this and make holding of that lock a requirement on the update
>> side for now, but keep the pgdat_resize_lock() around for readers that
>> can't lock a mutex.
>>
>> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
>
> Nack, these fields are initialized at boot without lock_memory_hotplug(),
> so you're statement is wrong, and all you need is pgdat_resize_lock().

They are also initialized at boot without pgdat_resize_lock(), if we 
consider boot time, quite a few of the statements on when locking is 
required are wrong.

That said, you are correct that it is not strictly required to hold 
lock_memory_hotplug() when updating the fields in question because 
pgdat_resize_lock() is used.



