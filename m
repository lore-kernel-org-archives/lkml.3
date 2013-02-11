Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab3BKOrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:47:16 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:47066 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab3BKOrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:47:15 -0500
MIME-Version: 1.0
In-Reply-To: <20130211105941.GA26717@paralelels.com>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org>
 <20130208191056.GA13674@redhat.com> <CAKgNAki0xt_wwixp7kdv04fKOCtCh-ObQjkFE9PiX6FapkO34A@mail.gmail.com>
 <201302111029.50998.vda.linux@googlemail.com> <20130211105941.GA26717@paralelels.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 11 Feb 2013 15:46:52 +0100
Message-ID: <CAK1hOcMepaOD80GOvUv1xz3xibTG_iKMK-w7698K6KfRmcKGeA@mail.gmail.com>
Subject: Re: [CRIU] [PATCH 3/3] signalfd: add ability to read siginfo-s
 without dequeuing signals (v2)
To: Andrew Vagin <avagin@parallels.com>
Cc: mtk.manpages@gmail.com, David Howells <dhowells@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-api@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrey Wagin <avagin@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 11:59 AM, Andrew Vagin <avagin@parallels.com> wrote:
>> > I suppose I had wondered along similar lines, but in a slightly
>> > different direction: would the use of a /proc interface to get the
>> > queued signals make some sense?
>>
>> I think that /proc interface beats adding magic flags and magic semantic
>> to [p]read.
>>
>> It also has the benefit of being human-readable. You don't need
>> to write a special C program to "cat /proc/$$/foo".
>>
>> Andrey, I know that it is hard to let go of the code you invested time
>> and efforts in creating. But this isn't the last patch, is it?
>> You will need to retrieve yet more data for process checkpointing.
>> When you start working on the next patch for it, consider trying
>> /proc approach.
>
> I don't think that we need to convert siginfo into a human readable format
> in kernel.

My point is that bolting hacks onto various bits of kernel API
in order to support process checkpointing makes those APIs
(their in-kernel implementation) ridden with special cases
and harder to support in the future.

Process checkpointing needs to bite the bullet and
create its own API instead.

Whether it would be a /proc/PID/checkpoint or a
ptrace(PTRACE_GET_CHKPOINT_DATA) is another question.

-- 
vda
