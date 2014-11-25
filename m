Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaKYRYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:24:34 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42828 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaKYRYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:24:32 -0500
Message-ID: <5474BADC.5030808@oracle.com>
Date: Tue, 25 Nov 2014 10:22:36 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, tglx@linutronix.de, corbet@lwn.net,
        mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com,
        mgorman@suse.de, raistlin@linux.it, kirill.shutemov@linux.intel.com,
        atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org,
        serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com,
        vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org,
        yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com,
        axboe@fb.com, paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a timeslice
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com> <5473E388.6000605@redhat.com> <547497A9.1080800@oracle.com> <54749F77.50905@redhat.com>
In-Reply-To: <54749F77.50905@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 08:25 AM, Rik van Riel wrote:
> On 11/25/2014 09:52 AM, Khalid Aziz wrote:
>> On 11/24/2014 07:03 PM, Rik van Riel wrote:
>>> -----BEGIN PGP SIGNED MESSAGE-----
>>> Hash: SHA1
>>>
>>> On 11/24/2014 03:56 PM, Khalid Aziz wrote:
>>>> sched/fair: Add advisory flag for borrowing a timeslice
>>>>
>>>> This patch adds a way for a task to request to borrow one
>>>> timeslice from future if it is about to be preempted, so it could
>>>> delay preemption and complete any critical task it is in the middle
>>>> of.
>>>>
>>>> This feature helps with performance on databases and has been used
>>>> for many years on other OSs by the databases. This feature helps in
>>>> situation where a task acquires a lock before performing a critical
>>>> operation on the database and happens to get preempted
>>>
>>> Why don't the other tasks that want the lock sleep on the
>>> lock?
>>>
>>> I can see this "solution" help mostly with userspace spinlocks,
>>> which are relics of a past era that need to die. There is no
>>> way userspace spinlocks will not fail miserably on virtual
>>> machines, and it is time to get rid of them.
>>
>> This solution indeed is for userspace spinlocks. Database code has been
>> written with all critical locking implemented in userspace (as I have
>> been told by database folks. I am not a database guy).
>
> They should fix that.

Agreed, but that is a very large task for databases for sure and 
potentially for java as well (think exhaustive testing as well besides 
code re-write). I do not see this happening except as part of major 
re-architecture. In the mean time, if we can give them help without 
impacting kernel significantly for other users, it only makes Linux a 
more usable platform for them.

Thanks,
Khalid
