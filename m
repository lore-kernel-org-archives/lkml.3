Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaEUSE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:04:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39943 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbaEUSE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:04:26 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CACna6ryC8jjpJwzuHMbwuskrCgr7STMN8Bs3a7HN5h-rBZ68Rg@mail.gmail.com>
References: <CACna6rzTUnxHJX8MmDAbmj5SsL_VscfdV5oj735zMtLY5k8JCA@mail.gmail.com> <CACna6rxb2+xBFRt-g7ttkSB++-WtVEMycC7G=wf1ircKPW12ZQ@mail.gmail.com> <537CE3C2.8030601@zytor.com> <CACna6ryC8jjpJwzuHMbwuskrCgr7STMN8Bs3a7HN5h-rBZ68Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Bisected 3.9 regression: Corrupted low memory (x86, mm: Move reserving low memory later in initialization)
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 21 May 2014 11:03:59 -0700
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Message-ID: <c969f4d3-8b82-456d-b126-77a3b66a88bd@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I'm sure.  The old memory reservation code kept the checker from working.

On May 21, 2014 10:58:39 AM PDT, "Rafał Miłecki" <zajec5@gmail.com> wrote:
>On 21 May 2014 19:34, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 05/21/2014 06:31 AM, Rafał Miłecki wrote:
>>> On 16 May 2014 07:29, Rafał Miłecki <zajec5@gmail.com> wrote:
>>>> Sorry for the late report, this bug appears on my old notebook I
>don't
>>>> commonly use. Anyway, I've noticed following problem when using
>>>> 3.15-rc1:
>>>>
>>>> Corrupted low memory at ffff88000000be98 (be98 phys) =
>b02a000400000000
>>>
>>> Ping?
>>>
>>
>> It's not a regression, but rather a progression: the checker now does
>> what it claims to do, which is to check for low memory corruption.
>>
>> However, the checker is also rather useless as anything other than a
>> diagnostic tool.  It tells you that your BIOS is corrupting memory,
>and
>> the solution to that is to reserve the memory, which we already do.
>>
>> All the checker tells us is that on your system, yes, we really do
>need
>> to reserve the memory.
>
>What about making checker a bit more user friendly?
>
>First of all, I got many repeated messages like:
>Corrupted low memory at (...)
>In the first e-mail you can see ~10 of them and I really got more.
>
>Secondly, if this is just a confirmation that low memory reservation
>was indeed needed, what about making it debugging only? Right now it
>sounds like an error for end-users. What about making it something
>like
>Low memory reservation prevented corruption at (...)
>
>The last question, just for sure... are you convinced what I'm seeing
>is not any kind of error? After all, it started appearing after commit
>that moves memory reservation. It's not a commit that enabled the
>checker or something like that.
>What it seems to be for someone not experienced is a bit opposite. It
>looks that after commit in question, kernel reserves low memory too
>late and BIOS already corrupts some data placed in it.
>However I'm not on expert, so I'll just listen to your opinion. I
>simply wanted to ask, just to be sure everything is alright.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
