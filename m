Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab3GIBLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 21:11:38 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:43994 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3GIBLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 21:11:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9twiAK18Ny7QMMZA+DHFB=wQ2pxg8rDV+vj91TJjd_e2fg@mail.gmail.com>
References: <CAPM=9twiAK18Ny7QMMZA+DHFB=wQ2pxg8rDV+vj91TJjd_e2fg@mail.gmail.com>
Date: Tue, 9 Jul 2013 11:11:35 +1000
Message-ID: <CAPM=9tzT3EaZm=BRxxQe8+u-VtE8_F72-6X9ZJbLgnX7XMV7Vw@mail.gmail.com>
Subject: Re: sending SEGV to qemu crashes host kernel in Fedora 19
From: Dave Airlie <airlied@gmail.com>
To: qemu-devel@nongnu.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 10:35 AM, Dave Airlie <airlied@gmail.com> wrote:
> Hi,
>
> F19
> kernel-3.9.8-300.fc19.x86_64
> qemu-kvm-1.4.2-4.fc19.x86_64
>
> If I start a complete F19 install in the guest and send the qemu
> process a SEGV signal, the host kernel starts giving me random kmalloc
> errors soon after, if I send a normal kill signal things seem fine.
>
> CPU is Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz, on a HP 220z workstation.
>
> I initially blamed bad RAM but this reproduces everytime, and I
> swapped DIMMs around
>
> I haven't tested with upstream kernel/qemu yet, but I wondered if
> anyone else has seen this.
>
> I noticed this because some work I was doing was segfaulting my qemu
> and then my machine would die a few mins later.

Of course now I read my fedora kernel emails and notice vhost_net does
bad things,

disabling vhost_net seems to make it work fine, hopefully the next
Fedora kernel will bring the magic fixes.

Dave.
