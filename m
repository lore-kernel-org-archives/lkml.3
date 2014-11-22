Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaKVAS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 19:18:58 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:64637 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbaKVAS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 19:18:57 -0500
MIME-Version: 1.0
In-Reply-To: <20141122001111.GA26007@htj.dyndns.org>
References: <20141119235033.GE11386@lerouge>
	<20141120122339.GA14877@htj.dyndns.org>
	<alpine.DEB.2.11.1411202204030.3950@nanos>
	<20141120221122.GA25393@htj.dyndns.org>
	<alpine.DEB.2.11.1411202315230.3950@nanos>
	<20141120230514.GB25393@htj.dyndns.org>
	<alpine.DEB.2.11.1411210109460.6439@nanos>
	<20141121141332.GA8808@lerouge>
	<20141121162506.GA15461@htj.dyndns.org>
	<20141121214444.GB9198@lerouge>
	<20141122001111.GA26007@htj.dyndns.org>
Date: Fri, 21 Nov 2014 16:18:56 -0800
X-Google-Sender-Auth: l9fBTva5mn_HZwfcAgrF9xGQCL0
Message-ID: <CA+55aFzC+PRnnT79OzQhoVBu+jtTH=QP+n_puB8Ti2T9wNo5-A@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 4:11 PM, Tejun Heo <tj@kernel.org> wrote:
>
> I don't think there's much percpu allocator itself can do.  The
> ability to grow dynamically comes from being able to allocate
> relatively consistent layout among areas for different CPUs and pretty
> much requires vmalloc area and it'd generally be a good idea to take
> out the vmalloc fault anyway.

Why do you guys worry so much about the vmalloc fault?

This started because of a very different issue: putting the actual
stack in vmalloc space. Then it can cause nasty triple faults etc.

But the normal vmalloc fault? Who cares, really? If that causes
problems, they are bugs. Fix them.

                    Linus
