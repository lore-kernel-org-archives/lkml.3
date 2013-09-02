Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab3IBQJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 12:09:45 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:56970 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758315Ab3IBQJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 12:09:42 -0400
Message-ID: <5224B83F.7040503@gmail.com>
Date: Mon, 02 Sep 2013 10:09:35 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com> <52200DAE.2020303@hp.com> <CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com> <CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com> <CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com> <CA+55aFxvEjdEFK0dXn783eVN0PEXVhb5k8OnrbxSWDpXgyTwWw@mail.gmail.com> <CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com> <CA+55aFwHx=tCzdo50jJB0ey7-CTVSo6RRQHe6R9fAya7nPn00A@mail.gmail.com> <CA+icZUWmQHWHMr1symL7j0iYqUMJBiOuRJ=EJz4F-xkQtdnJLg@mail.gmail.com> <CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com> <CA+icZUUwy=sbt6BOirH6N4mSrQOykb=Z3GSdCb7vy_eVfG2RYw@mail.gmail.com> <CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com> <CA+icZUWPUDorK+9KRD-H3FpbDeC_7LMatzrYk35jZk13vNuLBQ@mail.gmail.com> <CA+55aFzBBADPxK3mJrKt2Qx-y-VJjk9fOrN6A0YRPrujXBNeQg@mail.gmail.com> <CA+icZUWHS2QeWTN0a8DwmMJ1UnvKjvox8t9MTLXMMU8oQOHtCQ@mail.gmail.com>
In-Reply-To: <CA+icZUWHS2QeWTN0a8DwmMJ1UnvKjvox8t9MTLXMMU8oQOHtCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/2/13 4:30 AM, Sedat Dilek wrote:
> On Sun, Sep 1, 2013 at 5:55 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Sun, Sep 1, 2013 at 8:45 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>
>>> Samples: 160K of event 'cycles:pp', Event count (approx.): 77003901089
>>> +  12,46%  t_lockref_from-  [kernel.kallsyms]     [k] irq_return
>>> +   4,86%  t_lockref_from-  [kernel.kallsyms]     [k] lockref_get_or_lock
>>> +   4,42%  t_lockref_from-  [kernel.kallsyms]     [k] __ticket_spin_lock
>>> +   4,28%  t_lockref_from-  [kernel.kallsyms]     [k] __acct_update_integrals
>>
>> You need to go into __ticket_spin_lock to see who the callers are.
>>
>> Just go down to it and press enter to expand it (and then you need to
>> go and expand that entry too to get the callers)
>>
>
> I am new to perf usage.

One option for you is 'perf report --stdio ..'. That bypasses the tui.

David
