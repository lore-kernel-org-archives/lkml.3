Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaLMQ2i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 11:28:38 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:54827 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbaLMQ2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 11:28:35 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxmseHugpuNMqFxiz8r86PPwth=Fd-U-_wC8_E-kDP3hA@mail.gmail.com>
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
	<CA+55aFyRW6su2J5O+ie70GqMvO3TYuSj93xwyJaPjGK1M=vUgA@mail.gmail.com>
	<548B897C.8090803@oracle.com>
	<CA+55aFxmseHugpuNMqFxiz8r86PPwth=Fd-U-_wC8_E-kDP3hA@mail.gmail.com>
Date: Sun, 14 Dec 2014 00:28:33 +0800
Message-ID: <CAAJw_ZsQBeMRXgrM8CHS9FPTEk_fJYkqWm6NJpgrBGdY=_X6Tw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started seeing this behavior somewhere around 3.16 with
CONFIG_PREEMPT set. Setting CONFIG_PREEMPT off seems to help. And,
yes, it happens on high load (compiling mozilla, xul) and using qemu
chroot to compile mesa.

I'm seeing a few persons bisecting already. If you want, I could start
bisecting too, but 3.16 was unstable for me as I'm still on reiserfs.

Jeff.



On Sat, Dec 13, 2014 at 8:44 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Dec 12, 2014 at 4:34 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>
>> Right, it's virtio-9p. However, virtio-9p acts merely as a proxy to an underlying
>> tmpfs - so while it's slow, I don't think it's way slower than the average disk
>> backed ext4.
>
> I was thinking more in the sense of "how much of the trouble is about
> something like tmpfs eating tons of memory when trinity starts doing
> random system calls on those files".
>
> I was also thinking that some of it might be filesystem-specific. We
> already *did* see one trace where it was in the loop getting virtio
> channel data. Maybe it's actually possible to overwhelm the 9p
> filesystem exactly because the backing store is tmpfs, and basically
> have a CPU 100% busy handling ring events from the virtual
> filesystem..
>
> But I'm just flailing..
>
>                      Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
