Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab3BKOxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:53:50 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:47713 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757131Ab3BKOxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:53:46 -0500
Message-ID: <511905D7.3040209@parallels.com>
Date: Mon, 11 Feb 2013 18:53:11 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Andrew Vagin <avagin@parallels.com>, mtk.manpages@gmail.com,
        David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrey Wagin <avagin@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [CRIU] [PATCH 3/3] signalfd: add ability to read siginfo-s without
 dequeuing signals (v2)
References: <1358849741-9611-4-git-send-email-avagin@openvz.org> <20130208191056.GA13674@redhat.com> <CAKgNAki0xt_wwixp7kdv04fKOCtCh-ObQjkFE9PiX6FapkO34A@mail.gmail.com> <201302111029.50998.vda.linux@googlemail.com> <20130211105941.GA26717@paralelels.com> <CAK1hOcMepaOD80GOvUv1xz3xibTG_iKMK-w7698K6KfRmcKGeA@mail.gmail.com>
In-Reply-To: <CAK1hOcMepaOD80GOvUv1xz3xibTG_iKMK-w7698K6KfRmcKGeA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 06:46 PM, Denys Vlasenko wrote:
> On Mon, Feb 11, 2013 at 11:59 AM, Andrew Vagin <avagin@parallels.com> wrote:
>>>> I suppose I had wondered along similar lines, but in a slightly
>>>> different direction: would the use of a /proc interface to get the
>>>> queued signals make some sense?
>>>
>>> I think that /proc interface beats adding magic flags and magic semantic
>>> to [p]read.
>>>
>>> It also has the benefit of being human-readable. You don't need
>>> to write a special C program to "cat /proc/$$/foo".
>>>
>>> Andrey, I know that it is hard to let go of the code you invested time
>>> and efforts in creating. But this isn't the last patch, is it?
>>> You will need to retrieve yet more data for process checkpointing.
>>> When you start working on the next patch for it, consider trying
>>> /proc approach.
>>
>> I don't think that we need to convert siginfo into a human readable format
>> in kernel.
> 
> My point is that bolting hacks onto various bits of kernel API
> in order to support process checkpointing makes those APIs
> (their in-kernel implementation) ridden with special cases
> and harder to support in the future.
> 
> Process checkpointing needs to bite the bullet and
> create its own API instead.

This is bad approach as well. What we should do is come up with a sane
API that makes sense without the checkpoint-restore project _when_ _possible_.

> Whether it would be a /proc/PID/checkpoint or a
> ptrace(PTRACE_GET_CHKPOINT_DATA) is another question.

Thanks,
Pavel
