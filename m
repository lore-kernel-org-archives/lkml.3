Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaLMAXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 19:23:18 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:39013 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbaLMAXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 19:23:17 -0500
MIME-Version: 1.0
In-Reply-To: <548B8046.4040808@oracle.com>
References: <20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141205171501.GA1320@redhat.com>
	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
	<1417806247.4845.1@mail.thefacebook.com>
	<CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
	<20141211145408.GB16800@redhat.com>
	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<548A122C.8000906@oracle.com>
	<CA+55aFw68nC+5s=iX2R4SLsgG3nBvURmDXYvX5pFJgHBnQoHMA@mail.gmail.com>
	<548A2165.9030107@oracle.com>
	<548B8046.4040808@oracle.com>
Date: Fri, 12 Dec 2014 16:23:16 -0800
X-Google-Sender-Auth: Is5LFLPvse-eE-WQmbZJskeGMYk
Message-ID: <CA+55aFyRW6su2J5O+ie70GqMvO3TYuSj93xwyJaPjGK1M=vUgA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 3:54 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> I ran bisection on trinity, rather than the kernel, and got the following
> result:

Heh. That commit is pretty small, but I guess the effect of having a
number of regular files open and being used on the trinity loads can
be almost arbitrarily large.

Where do those files get opened? What filesystem?

That might actually explain your and DaveJ's big differences: you are
running in virtualization, and I remember some 9p traces with virtio
etc from your reports.

While DaveJ obviously runs on bare hardware, possibly on /tmp and tmpfs?

> I've been running trinity f2be2d5ff^ on -next for two hours now, and there's
> no sign of a lockup. Previously it took ~10 minutes trigger.

DaveJ?  Is there anything limiting the size of those files?

                   Linus
