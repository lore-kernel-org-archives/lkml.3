Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942AbaLLUUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:20:04 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:42809 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbaLLUUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:20:03 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1412121157060.18579@nftneq.ynat.uz>
References: <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141205171501.GA1320@redhat.com>
	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
	<1417806247.4845.1@mail.thefacebook.com>
	<CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
	<20141211145408.GB16800@redhat.com>
	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<20141212185454.GB4716@redhat.com>
	<CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
	<alpine.DEB.2.02.1412121157060.18579@nftneq.ynat.uz>
Date: Fri, 12 Dec 2014 12:20:01 -0800
X-Google-Sender-Auth: Yo5E2zvvRAh027Gc0iaNhTh_s5o
Message-ID: <CA+55aFwLZi-JXAx9U-6rPPqoD1rmFjbzhv4acA9NKWEKo-UPRg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Lang <david@lang.hm>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 11:58 AM, David Lang <david@lang.hm> wrote:
>
> If the machine has NOHZ and has a cpu bound userspace task, it could take
> quite a while before userspace would trigger a reschedule (at least if I've
> understood the comments on this thread properly)

The thing is, we'd have to return to user space for that to happen.
And when we do that, we check the "should we schedule" flag again. So
races like this really shouldn't matter, but there could be something
kind-of-similar that just ends up causing a wakeup to be delayed.

But it would need to be delayed for seconds (for the RCU threads) or
for tens of seconds (for the watchdog) to matter.

Which just seems unlikely. Even the "very high load" thing shouldn't
really matter, since while that could delay one particular thread
being scheduled, it shouldn't delay the next "should we schedule"
test. In fact, high load would normally be extected to make the next
"should we schedule" come faster.

But this is where some load calculation overflow might screw things
up, of course.

                 Linus
