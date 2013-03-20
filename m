Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab3CTCLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 22:11:53 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:54029 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3CTCLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 22:11:51 -0400
MIME-Version: 1.0
X-Originating-IP: [108.230.157.199]
In-Reply-To: <CABx3TkU7e9ZUDYhegUBD+XbG03+Q+dxF8jzeUe4Cao9Hg_TpBw@mail.gmail.com>
References: <CABx3TkU7e9ZUDYhegUBD+XbG03+Q+dxF8jzeUe4Cao9Hg_TpBw@mail.gmail.com>
Date: Tue, 19 Mar 2013 19:11:50 -0700
X-Google-Sender-Auth: e97zWmWChWSBdAs-XqYLltJjhlc
Message-ID: <CABx3TkUnOrWAdw70+2Sg=UGmp6pEWa2qM4QtY=XofJgOU5=UiA@mail.gmail.com>
Subject: Re: [BUG][mvebu] mvneta: cannot request irq 25 on openblocks-ax3
From: Ryan Press <presslab@hotmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregory.clement@free-electrons.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

>On 03/19/2013 05:43 PM, Gregory CLEMENT wrote:
>> On Tue, Mar 19, 2013 at 10:12:37PM +0900, Masami Hiramatsu wrote:
>>>
>>> Here I've hit a bug on the recent kernel. As far as I know, this bug
>>> exists on 3.9-rc1 too.
>>>
>>> When I tried the latest mvebu for-next tree
>>> (git://git.infradead.org/users/jcooper/linux.git mvebu/for-next),
>>> I got below warning at bootup time and mvneta didn't work (link was never up).
>>> I ensured that "ifconfig ethX up" always caused that.
>>>
>>> Does anyone succeed to boot openblocks-ax3 recently or hit same
>>> trouble?
>
>Hi Masami,
>
>You can try this patch if you want.
>I don't have the hardware today so I didn't test it.
>If you (and also Florian and Ezequiel) can test it and if it fixed
>the bug, then I will be able send a proper email for it,

Thanks for this!  I've been trying to build 3.9-rc1 on my Mirabox, and
I had the same problem as Masami.  The patch allows mvneta to be
built-in to the kernel, but built as a module it gives the linker
error below:

ERROR: "request_percpu_irq" [drivers/net/ethernet/marvell/mvneta.ko] undefined!
ERROR: "free_percpu_irq" [drivers/net/ethernet/marvell/mvneta.ko] undefined!

Linking it into the kernel and installing allows the network
interfaces to come up, and they can receive traffic, but oddly enough
even though tcpdump shows that traffic is transmitting and the link
lights blink, the other side does not see any traffic.  I've tested
this with different computers and different link speeds to no avail.
The fact that the link lights blink when transmitting makes me think
it's not a firewall problem (and that this rootfs works with another
arm box), but I'm not sure where to look next.  Any idea?

Thanks,
Ryan
