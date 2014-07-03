Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbaGCSOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:14:18 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:40545 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaGCSOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:14:16 -0400
Message-ID: <53B59CB5.9060004@linux.vnet.ibm.com>
Date: Thu, 03 Jul 2014 23:41:01 +0530
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
References: <1404392547-11648-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <CA+55aFxOTqUAqEF7+83s890Q18qCHSQqDOxWqWHNjG_25hVhXg@mail.gmail.com>
In-Reply-To: <CA+55aFxOTqUAqEF7+83s890Q18qCHSQqDOxWqWHNjG_25hVhXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070318-8878-0000-0000-00000D5180F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 09:11 PM, Linus Torvalds wrote:
> On Thu, Jul 3, 2014 at 6:02 AM, Raghavendra K T
> <raghavendra.kt@linux.vnet.ibm.com> wrote:
>>
>> However it broke sys_readahead semantics: 'readahead() blocks until the specified
>> data has been read'
>
> What? Where did you find that insane sentence? And where did you find
> an application that depends on that totally insane semantics that sure
> as hell was never intentional.
>
> If this comes from some man-page,

Yes it is.

then the man-page is just full of
> sh*t, and is being crazy. The whole and *only* point of readahead() is
> that it does *not* block, and you can do it across multiple files.

Entirely agree. Infact I also had the strong opinion that we should
rather change man page instead of making Linux performing badly by doing
large unnecessary readahead when there is no actual read, and
performance numbers have proved that.



