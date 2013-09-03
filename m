Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402Ab3ICWqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 18:46:53 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:40592 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761242Ab3ICWqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 18:46:52 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230751416DC@IN01WEMBXA.internal.synopsys.com>
References: <CA+icZUXuw7QBn4CPLLuiVUjHin0m6GRdbczGw=bZY+Z60sXNow@mail.gmail.com>
	<CA+icZUUn-r8iq6TVMAKmgJpQm4FhOE4b4QN_Yy=1L=0Up=rkBA@mail.gmail.com>
	<52205597.3090609@synopsys.com>
	<CA+icZUW=YXMC_2Qt=cYYz6w_fVW8TS4=Pvbx7BGtzjGt+31rLQ@mail.gmail.com>
	<C2D7FE5348E1B147BCA15975FBA230751411CB@IN01WEMBXA.internal.synopsys.com>
	<CALE5RAvaa4bb-9xAnBe07Yp2n+Nn4uGEgqpLrKMuOE8hhZv00Q@mail.gmail.com>
	<CAMJEocr1SgxQw0bEzB3Ti9bvRY74TE5y9e+PLUsAL1mJbK=-ew@mail.gmail.com>
	<CA+55aFy8tbBpac57fU4CN3jMDz46kCKT7+7GCpb18CscXuOnGA@mail.gmail.com>
	<C2D7FE5348E1B147BCA15975FBA230751413F4@IN01WEMBXA.internal.synopsys.com>
	<5224BCF6.2080401@colorfullife.com>
	<C2D7FE5348E1B147BCA15975FBA23075141642@IN01WEMBXA.internal.synopsys.com>
	<5225A466.2080303@colorfullife.com>
	<C2D7FE5348E1B147BCA15975FBA2307514165E@IN01WEMBXA.internal.synopsys.com>
	<5225AA8D.6080403@colorfullife.com>
	<C2D7FE5348E1B147BCA15975FBA2307514168F@IN01WEMBXA.internal.synopsys.com>
	<5225B716.3090708@colorfullife.com>
	<C2D7FE5348E1B147BCA15975FBA230751416DC@IN01WEMBXA.internal.synopsys.com>
Date: Wed, 4 Sep 2013 00:46:50 +0200
Message-ID: <CA+icZUU5TQEH-SX9G97RFqfgUs1i2YHPU=HvUOY+YDKrU4RNzQ@mail.gmail.com>
Subject: Re: ipc msg now works (was Re: ipc-msg broken again on 3.11-rc7?)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <dave.bueso@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, Andi Kleen <andi@firstfloor.org>,
        Rik van Riel <riel@redhat.com>,
        Jonathan Gonzalez <jgonzalez@linets.cl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 12:32 PM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
> On 09/03/2013 03:47 PM, Manfred Spraul wrote:
>> Hi Vineet,
>>
>> On 09/03/2013 11:51 AM, Vineet Gupta wrote:
>>> On 09/03/2013 02:53 PM, Manfred Spraul wrote:
>>>> The access to msq->q_cbytes is not protected.
>>>>
>>>> Vineet, could you try to move the test for free space after ipc_lock?
>>>> I.e. the lock must not get dropped between testing for free space and
>>>> enqueueing the messages.
>>> Hmm, the code movement is not trivial. I broke even the simplest of cases (patch
>>> attached). This includes the additional change which Linus/Davidlohr had asked for.
>> The attached patch should work. Could you try it?
>>
>
> Yes this did the trick, now the default config of 100k iterations + 16 processes
> runs to completion.
>

Manfred's patch "ipc/msg.c: Fix lost wakeup in msgsnd()." is now upstream.

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=bebcb928c820d0ee83aca4b192adc195e43e66a2
