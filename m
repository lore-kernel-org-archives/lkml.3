Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbaGCSil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:38:41 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:50952 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaGCSij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:38:39 -0400
Message-ID: <53B5A26B.7040606@linux.vnet.ibm.com>
Date: Fri, 04 Jul 2014 00:05:23 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm readahead: Fix sys_readahead breakage by reverting
 2MB limit (bug 79111)
References: <1404392547-11648-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <CA+55aFxOTqUAqEF7+83s890Q18qCHSQqDOxWqWHNjG_25hVhXg@mail.gmail.com> <53B59CB5.9060004@linux.vnet.ibm.com> <CA+55aFyRgYW6Y8paYKGfqE205enhiPsZ1C8wrKpFavVXq7ZAtA@mail.gmail.com>
In-Reply-To: <CA+55aFyRgYW6Y8paYKGfqE205enhiPsZ1C8wrKpFavVXq7ZAtA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070318-2000-0000-0000-000000D1CDF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 11:52 PM, Linus Torvalds wrote:
> On Thu, Jul 3, 2014 at 11:11 AM, Raghavendra K T
> <raghavendra.kt@linux.vnet.ibm.com> wrote:
>>>
>>> If this comes from some man-page,
>>
>> Yes it is.
>
> Ok, googling actually finds a fairly recent patch to fix it
>
>     http://www.spinics.net/lists/linux-mm/msg70517.html
>
> and several much older "that's not true" comments.

Thanks. I had missed that.

>
> That said, the bugzilla entry you mentioned does mention "can't boot
> 3.14 now". I'm not sure what the meaning of that sentence is, though.
> Does it mean "can't boot 3.14 to test it because the machine is busy",
> or is it a typo and really meant 3.15, and that some bootup script
> *depended* on readahead()? I don't know. It seems strange.

I think your guess is right, it meant to say "I can't boot it anymore
since I already upgraded to 3.15", because eventually bootup script (if
it is) should have to read IIUC.


