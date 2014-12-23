Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbaLWIVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:21:00 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62217 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaLWIU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:20:58 -0500
MIME-Version: 1.0
In-Reply-To: <87sig7beqt.fsf@x220.int.ebiederm.org>
References: <54982C98.9070806@oracle.com>
	<CAPAsAGzHyx=9oy7ZFdL3dERrKR3or_PiDqm_chbDRvx+c3ZHPg@mail.gmail.com>
	<87oaqvd6ni.fsf@x220.int.ebiederm.org>
	<CAPAsAGwRL-fg10cPYREbXmsk09EU4qVz-3AX+OkR-QifmOW2kQ@mail.gmail.com>
	<54985F05.2040603@oracle.com>
	<87sig7beqt.fsf@x220.int.ebiederm.org>
Date: Tue, 23 Dec 2014 12:20:57 +0400
Message-ID: <CAPAsAGxQegdd25rPxLxA7D8k_ykh1SD_m87t-yAE0BsqEqULgA@mail.gmail.com>
Subject: Re: fs: proc: gpf in find_entry
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "davej @mail.xmission.com>> Dave Jones" <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-22 23:39 GMT+03:00 Eric W. Biederman <ebiederm@xmission.com>:
> Sasha Levin <sasha.levin@oracle.com> writes:
>
>> On 12/22/2014 12:52 PM, Andrey Ryabinin wrote:
>>> 2014-12-22 18:51 GMT+03:00 Eric W. Biederman <ebiederm@xmission.com>:
>>>> These two instructions:
>>>>>>   11:   4d 85 ff                test   %r15,%r15
>>>>>>   14:   0f 84 de 01 00 00       je     0x1f8
>>>>
>>>> Should prevent a NULL %r15 value from ever reaching the trapping
>>>> instruction.
>>>
>>> If they were executed, then yes. But I think there was jump from somewhere
>>> to the instructions below those two.
>>
>> There is indeed a jump direct to that point, which avoids the %r15
>> check.
>
> Where do you see that direct jump, that certainly has not been posted
> in this thread?
>
> There are certainly no such code paths I in the source code.  There is
> only one NULL pointer check in find_entry and it is executed every time
> the loop executes.
>
> So at this point all I know is some set of tools has totally destroyed
> the code and made what Sasha Levin's is testing so far from the source
> code that this is a useless bug report.
>
> I have no reason to even suspect this bug is actually in the upstream
> kernel.
>

Generated code looks correct to me (considering that it was built with
sanitizer tools).
So this looks like a real BUG to me.

AFAICT this is 'head' == NULL:

   head = ctl_node->header;
   entry = &head->ctl_table[ctl_node - head->node];


> This appears to be a kind of testing that slows development and wastes
> peoples time.  Can someone give me a patch that sets the TAINTED flag
> when KASAN is loaded?
>

Pay attention to the first line of report:
[ 2015.960381] general protection fault: 0000 [#1] PREEMPT SMP KASAN
