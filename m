Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbaLMAek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 19:34:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25920 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbaLMAej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 19:34:39 -0500
Message-ID: <548B897C.8090803@oracle.com>
Date: Fri, 12 Dec 2014 19:34:04 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?RMOibmllbCBGcmFnYQ==?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <20141201230339.GA20487@ret.masoncoding.com>	<1417529606.3924.26.camel@maggy.simpson.net>	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>	<1417540493.21136.3@mail.thefacebook.com>	<20141203184111.GA32005@redhat.com>	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>	<20141205171501.GA1320@redhat.com>	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>	<1417806247.4845.1@mail.thefacebook.com>	<CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>	<20141211145408.GB16800@redhat.com>	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>	<548A122C.8000906@oracle.com>	<CA+55aFw68nC+5s=iX2R4SLsgG3nBvURmDXYvX5pFJgHBnQoHMA@mail.gmail.com>	<548A2165.9030107@oracle.com>	<548B8046.4040808@oracle.com> <CA+55aFyRW6su2J5O+ie70GqMvO3TYuSj93xwyJaPjGK1M=vUgA@mail.gmail.com>
In-Reply-To: <CA+55aFyRW6su2J5O+ie70GqMvO3TYuSj93xwyJaPjGK1M=vUgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 07:23 PM, Linus Torvalds wrote:
> On Fri, Dec 12, 2014 at 3:54 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> >
>> > I ran bisection on trinity, rather than the kernel, and got the following
>> > result:
> Heh. That commit is pretty small, but I guess the effect of having a
> number of regular files open and being used on the trinity loads can
> be almost arbitrarily large.
> 
> Where do those files get opened? What filesystem?

Right, it's virtio-9p. However, virtio-9p acts merely as a proxy to an underlying
tmpfs - so while it's slow, I don't think it's way slower than the average disk
backed ext4.


Thanks,
Sasha
