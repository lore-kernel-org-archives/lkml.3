Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaBMJ7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:59:41 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:34981 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaBMJ7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:59:39 -0500
Message-ID: <52FC98A6.1000701@linux.vnet.ibm.com>
Date: Thu, 13 Feb 2014 15:34:22 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V5] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
References: <1390388025-1418-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140206145105.27dec37b16f24e4ac5fd90ce@linux-foundation.org> <alpine.DEB.2.02.1402061456290.31828@chino.kir.corp.google.com> <20140206152219.45c2039e5092c8ea1c31fd38@linux-foundation.org> <alpine.DEB.2.02.1402061537180.3441@chino.kir.corp.google.com> <alpine.DEB.2.02.1402061557210.5061@chino.kir.corp.google.com> <52F4B8A4.70405@linux.vnet.ibm.com> <alpine.DEB.2.02.1402071239301.4212@chino.kir.corp.google.com> <52F88C16.70204@linux.vnet.ibm.com> <alpine.DEB.2.02.1402100200420.30650@chino.kir.corp.google.com> <52F8C556.6090006@linux.vnet.ibm.com> <alpine.DEB.2.02.1402101333160.15624@chino.kir.corp.google.com> <52FC6F2A.30905@linux.vnet.ibm.com> <alpine.DEB.2.02.1402130003320.11689@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1402130003320.11689@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021309-3864-0000-0000-00000C673FEE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 01:35 PM, David Rientjes wrote:
> On Thu, 13 Feb 2014, Raghavendra K T wrote:
>
>> I was able to test (1) implementation on the system where readahead problem
>> occurred. Unfortunately it did not help.
>>
>> Reason seem to be that CONFIG_HAVE_MEMORYLESS_NODES dependency of
>> numa_mem_id(). The PPC machine I am facing problem has topology like
>> this:
[...]
>>
>> So it seems numa_mem_id() does not help for all the configs..
>> Am I missing something ?
>>
>
> You need the patch from http://marc.info/?l=linux-mm&m=139093411119013
> first.

Thanks David, unfortunately even after applying that patch, I do not see
the improvement.

Interestingly numa_mem_id() seem to still return the value of a
memoryless node.
May be  per cpu _numa_mem_ values are not set properly. Need to dig out ....

