Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab3J1PpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:45:24 -0400
Received: from mailout08.t-online.de ([194.25.134.20]:35610 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab3J1PpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:45:22 -0400
Message-ID: <526E8685.3030200@t-online.de>
Date: Mon, 28 Oct 2013 16:45:09 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_?= =?ISO-8859-1?Q?Weisbecker?= 
	<fweisbec@gmail.com>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request during
 shutdown
References: <525BD08C.2080101@t-online.de> <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com> <CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com> <alpine.DEB.2.02.1310251221310.5266@ionos.tec.linutronix.de> <CA+55aFxw1Hm4QVeEigkByP5RppSL30oHnLoR16C=henf-a=uFQ@mail.gmail.com> <20131026114303.GA24067@gmail.com> <526E79A2.9080303@t-online.de> <20131028150114.GA12905@gmail.com> <20131028151637.GA13251@gmail.com>
In-Reply-To: <20131028151637.GA13251@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: SUnKLiZXwhh+FxQ+Cu2AVPOPLwGsQ8Ay81sCe9EEF4NrmvauDqUA2csrRN6RMWgwX4
X-TOI-MSGID: 207cfd85-36d1-4358-b1b1-74fb594a0999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.10.2013 16:16, Ingo Molnar wrote:
> * Ingo Molnar <mingo@kernel.org> wrote:
>
>>> I tried that patch, together with all the kobj debug options
>>> enabled. With that kernel configuration I was unable to
>>> reproduce the problem during 500 typical workload / reboot
>>> cycles. Without the debug options I was able to reproduce the
>>> last reported panic after 91 cycles. The debug options seem to
>>> change timing sufficiently to mask the bug ;-(
>> Could you send me the kernel config please?
> I got your .config off-list, thanks Knut!
>
> It has all DEBUG_OBJECT options enabled:
>
>   CONFIG_DEBUG_OBJECTS=y
>   # CONFIG_DEBUG_OBJECTS_SELFTEST is not set
>   CONFIG_DEBUG_OBJECTS_FREE=y
>   CONFIG_DEBUG_OBJECTS_TIMERS=y
>   CONFIG_DEBUG_OBJECTS_WORK=y
>   CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
>   CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
>   CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
>
> but it also has DEBUG_PAGEALLOC enabled:
>
>   CONFIG_DEBUG_PAGEALLOC=y
>
> I'd suggest disabling that one - it kind of overlaps debugobjects
> and it will definitely be a big slowdown.

ACK
> I'd also suggest turning off lockdep for now:
>
>   CONFIG_PROVE_LOCKING=y
>
> because we know it does not trigger any useful warning. This too
> should speed up things a bit.

Well, for now that´s true. On one machine it emits the old warning about the
videobuf_dvb_find_frontend() /  dvb_device_open() circular reference,
but that´s definitely unrelated.

>
> Whether this would make the crash reproducable again I don't know
> :-/

We´ll see ;-)
> Thanks,
>
> 	Ingo
>

