Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaEUR6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:58:41 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:46451 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaEUR6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:58:39 -0400
MIME-Version: 1.0
In-Reply-To: <537CE3C2.8030601@zytor.com>
References: <CACna6rzTUnxHJX8MmDAbmj5SsL_VscfdV5oj735zMtLY5k8JCA@mail.gmail.com>
	<CACna6rxb2+xBFRt-g7ttkSB++-WtVEMycC7G=wf1ircKPW12ZQ@mail.gmail.com>
	<537CE3C2.8030601@zytor.com>
Date: Wed, 21 May 2014 19:58:39 +0200
Message-ID: <CACna6ryC8jjpJwzuHMbwuskrCgr7STMN8Bs3a7HN5h-rBZ68Rg@mail.gmail.com>
Subject: Re: Bisected 3.9 regression: Corrupted low memory (x86, mm: Move
 reserving low memory later in initialization)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 May 2014 19:34, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/21/2014 06:31 AM, Rafał Miłecki wrote:
>> On 16 May 2014 07:29, Rafał Miłecki <zajec5@gmail.com> wrote:
>>> Sorry for the late report, this bug appears on my old notebook I don't
>>> commonly use. Anyway, I've noticed following problem when using
>>> 3.15-rc1:
>>>
>>> Corrupted low memory at ffff88000000be98 (be98 phys) = b02a000400000000
>>
>> Ping?
>>
>
> It's not a regression, but rather a progression: the checker now does
> what it claims to do, which is to check for low memory corruption.
>
> However, the checker is also rather useless as anything other than a
> diagnostic tool.  It tells you that your BIOS is corrupting memory, and
> the solution to that is to reserve the memory, which we already do.
>
> All the checker tells us is that on your system, yes, we really do need
> to reserve the memory.

What about making checker a bit more user friendly?

First of all, I got many repeated messages like:
Corrupted low memory at (...)
In the first e-mail you can see ~10 of them and I really got more.

Secondly, if this is just a confirmation that low memory reservation
was indeed needed, what about making it debugging only? Right now it
sounds like an error for end-users. What about making it something
like
Low memory reservation prevented corruption at (...)

The last question, just for sure... are you convinced what I'm seeing
is not any kind of error? After all, it started appearing after commit
that moves memory reservation. It's not a commit that enabled the
checker or something like that.
What it seems to be for someone not experienced is a bit opposite. It
looks that after commit in question, kernel reserves low memory too
late and BIOS already corrupts some data placed in it.
However I'm not on expert, so I'll just listen to your opinion. I
simply wanted to ask, just to be sure everything is alright.

-- 
Rafał
