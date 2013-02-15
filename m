Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab3BOTxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:53:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab3BOTxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:53:48 -0500
Message-ID: <511E923D.7050704@redhat.com>
Date: Fri, 15 Feb 2013 19:53:33 +0000
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        criu@openvz.org, linux-api@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without removing
 them from a queue
References: <1360768595-31943-1-git-send-email-avagin@openvz.org> <511E8223.6010506@redhat.com> <20130215194356.GA12413@redhat.com>
In-Reply-To: <20130215194356.GA12413@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 07:43 PM, Oleg Nesterov wrote:
> On 02/15, Pedro Alves wrote:
>>
>> Not sure I'm reading the patch right, but it looks like GDB would
>> be able to use this as alternative to PTRACE_GET_SIGINFO variant
> 
> No, it is different. PTRACE_GETSIGINFO reports the siginfo for the signal
> which was already dequeued (ignoring the fact ->last_siginfo != NULL doesn't
> necessarily mean we report a signal), while this patch allows to look at
> the pending signals which were not reported yet.

Ah, I had assumed queue position 0 would be the dequeued signal.

>> I wouldn't mind if this was added unconditionally
>> instead of wrapped on CONFIG_CHECKPOINT_RESTORE.
> 
> I agree. If you think gdb can use this new feature,  CONFIG_ can go away.

I think so -- we can add a gdb command to dump the list of
pending signals, which I think is something that'd be useful.

> 
>> We'd miss the poke
>> variant, but that looks like something that could be always be added
>> later.
> 
> Yes. _POKE_ or _QUEUE_ or _DEQUEUE_, we can add more features if user-
> space wants them.

-- 
Pedro Alves

