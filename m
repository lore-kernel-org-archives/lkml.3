Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbbABXA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 18:00:29 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbbABXA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 18:00:28 -0500
Message-ID: <54A72306.2050908@nod.at>
Date: Sat, 03 Jan 2015 00:00:22 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jkosina@suse.cz>
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
References: <1419457167-15042-1-git-send-email-richard@nod.at> <CAGXu5jKxzyjzoY_khgZu7TbxMhfG3jiXGObiaiUhx6g5-k9c6Q@mail.gmail.com> <20150102051142.GF4873@amd> <54A67A38.3000207@nod.at> <20150102194616.GA27538@amd> <54A7103E.6020500@nod.at> <20150102222936.GA29018@amd> <alpine.LRH.2.00.1501022331060.30884@twin.jikos.cz> <20150102224646.GB29018@amd> <alpine.LNX.2.00.1501022348070.16297@pobox.suse.cz> <20150102225420.GC29018@amd>
In-Reply-To: <20150102225420.GC29018@amd>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.01.2015 um 23:54 schrieb Pavel Machek:
> On Fri 2015-01-02 23:49:52, Jiri Kosina wrote:
>> On Fri, 2 Jan 2015, Pavel Machek wrote:
>>
>>>> You also want to protect against binaries that are evil on purpose,
>>>> right?
>>>
>>> Umm. No. Not by default. We don't want to break crashme or trinity by
>>> default.
>>
>> I thought trinity is issuing syscalls directly (would make more sense than 
>> going through glibc, wouldn't it?) ... haven't checked the source though.
> 
> Patch in this thread wanted to insert delays into kernel on SIGSEGV
> processing. That's bad idea by default.

No. This is not what this patch does.

> But changing glibc to do sleep(30); abort(); instead of abort(); to
> slow down bruteforcing of canaries makes some kind of sense... and
> should be ok by default.

As I saidn only focusing one the specific stack canary case is not enough.

Thanks,
//richard
