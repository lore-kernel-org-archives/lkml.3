Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3ISPio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 11:38:44 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:41795 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3ISPim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 11:38:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130918065101.GA22060@drongo>
References: <1378330796.4321.50.camel@pasglop>
	<1378395204-25342-1-git-send-email-fweisbec@gmail.com>
	<20130918065101.GA22060@drongo>
Date: Thu, 19 Sep 2013 10:38:41 -0500
Message-ID: <CAFTL4hyFA6g8=zPuv97EweyGdTvR1tWqZtOyFjA0Xr6u+SkoKQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] irq: Fix stack overflow due to softirq called on
 current stack
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/9/18 Paul Mackerras <paulus@samba.org>:
> Frederic,
>
> On Thu, Sep 05, 2013 at 05:33:21PM +0200, Frederic Weisbecker wrote:
>>
>> This series is a proposition to fix the crash reported here: http://lkml.kernel.org/r/1378330796.4321.50.camel%40pasglop
>> And it has the upside to also consolidate a bit the arch do_softirq overriden implementation.
>
> I tried this series on a ppc64 machine running KVM guests and doing
> network traffic, while under memory pressure, and it seems to work
> fine.  Although the original problem was never completely
> deterministically reproducible, the problem did originally show up
> with the combination of memory pressure, network traffic and KVM
> guests.  I pushed the test machine moderately hard for a while and
> there was no sign of stack overflow.  So:
>
> Tested-by: Paul Mackerras <paulus@samba.org>

Thanks!

>
> Are you going to push this upstream?

Yeah I'll prepare a pull request and let Thomas decide about the fate
of these patches.

Thanks!
