Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbbABVk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 16:40:29 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbbABVkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 16:40:20 -0500
Message-ID: <54A7103E.6020500@nod.at>
Date: Fri, 02 Jan 2015 22:40:14 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        DaeSeok Youn <daeseok.youn@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, vdavydov@parallels.com,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH] [RFC] Deter exploit bruteforcing
References: <1419457167-15042-1-git-send-email-richard@nod.at> <CAGXu5jKxzyjzoY_khgZu7TbxMhfG3jiXGObiaiUhx6g5-k9c6Q@mail.gmail.com> <20150102051142.GF4873@amd> <54A67A38.3000207@nod.at> <20150102194616.GA27538@amd>
In-Reply-To: <20150102194616.GA27538@amd>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.01.2015 um 20:46 schrieb Pavel Machek:
>>> Does this break trinity, crashme, and similar programs?
>>
>> If they fork() without execve() and a child dies very fast the next fork()
>> will be throttled.
>> This is why I'd like to make this feature disabled by default.
>>
>>> Can you detect it died due to the stack canary? Then, the patch might
>>> be actually acceptable.
>>
>> I don't think so as this is glibc specific.
> 
> Can the slowdown be impelmented in glibc, then?

glibc has a lot of asserts where it can detect stack smashing and kills the
current process using abort(). Here it could of course also call sleep().

> If not, can glibc provide enough information to the kernel to allow us
> to do the right thing?

IMHO we should not strictly focus on the stack canary.
If an attacker can kind of control the attacked child and it segfaults the generic
in-kernel bruteforce detection will still work.
Many exploits use the fact that after fork() the child has the same memory as before
and brute force is possible. A user space solution won't help here.

Thanks,
//richard
