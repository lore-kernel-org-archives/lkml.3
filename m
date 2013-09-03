Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab3ICI5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 04:57:17 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:57847 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab3ICI5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 04:57:15 -0400
Message-ID: <5225A466.2080303@colorfullife.com>
Date: Tue, 03 Sep 2013 10:57:10 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <dave.bueso@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, Andi Kleen <andi@firstfloor.org>,
        Rik van Riel <riel@redhat.com>,
        Jonathan Gonzalez <jgonzalez@linets.cl>
Subject: Re: ipc-msg broken again on 3.11-rc7?
References: <CA+icZUXuw7QBn4CPLLuiVUjHin0m6GRdbczGw=bZY+Z60sXNow@mail.gmail.com> <1372202983.1888.22.camel@buesod1.americas.hpqcorp.net> <521DE5D7.4040305@synopsys.com> <CA+icZUUrZG8pYqKcHY3DcYAuuw=vbdUvs6ZXDq5meBMjj6suFg@mail.gmail.com> <C2D7FE5348E1B147BCA15975FBA23075140FA3@IN01WEMBXA.internal.synopsys.com> <CA+icZUUn-r8iq6TVMAKmgJpQm4FhOE4b4QN_Yy=1L=0Up=rkBA@mail.gmail.com> <52205597.3090609@synopsys.com> <CA+icZUW=YXMC_2Qt=cYYz6w_fVW8TS4=Pvbx7BGtzjGt+31rLQ@mail.gmail.com> <C2D7FE5348E1B147BCA15975FBA230751411CB@IN01WEMBXA.internal.synopsys.com> <CALE5RAvaa4bb-9xAnBe07Yp2n+Nn4uGEgqpLrKMuOE8hhZv00Q@mail.gmail.com> <CAMJEocr1SgxQw0bEzB3Ti9bvRY74TE5y9e+PLUsAL1mJbK=-ew@mail.gmail.com> <CA+55aFy8tbBpac57fU4CN3jMDz46kCKT7+7GCpb18CscXuOnGA@mail.gmail.com> <C2D7FE5348E1B147BCA15975FBA230751413F4@IN01WEMBXA.internal.synopsys.com> <5224BCF6.2080401@colorfullife.com> <C2D7FE5348E1B147BCA15975FBA23075141642@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA23075141642@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 10:44 AM, Vineet Gupta wrote:
>> b) Could you check that it is not just a performance regression?
>>       Does ./msgctl08 1000 16 hang, too?
> Nope that doesn't hang. The minimal configuration that hangs reliably is msgctl
> 50000 2
>
> With this config there are 3 processes.
> ...
>    555   554 root     S     1208  0.4   0  0.0 ./msgctl08 50000 2
>    554   551 root     S     1208  0.4   0  0.0 ./msgctl08 50000 2
>    551   496 root     S     1208  0.4   0  0.0 ./msgctl08 50000 2
> ...
>
> [ARCLinux]$ cat /proc/551/stack
> [<80aec3c6>] do_wait+0xa02/0xc94
> [<80aecad2>] SyS_wait4+0x52/0xa4
> [<80ae24fc>] ret_from_system_call+0x0/0x4
>
> [ARCLinux]$ cat /proc/555/stack
> [<80c2950e>] SyS_msgrcv+0x252/0x420
> [<80ae24fc>] ret_from_system_call+0x0/0x4
>
> [ARCLinux]$ cat /proc/554/stack
> [<80c28c82>] do_msgsnd+0x116/0x35c
> [<80ae24fc>] ret_from_system_call+0x0/0x4
>
> Is this a case of lost wakeup or some such. I'm running with some more diagnostics
> and will report soon ...
What is the output of ipcs -q? Is the queue full or empty when it hangs?
I.e. do we forget to wake up a receiver or forget to wake up a sender?

--
     Manfred
