Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab3BUR2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:28:55 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:57090 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab3BUR2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:28:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAK=Wgba5XkK3c7qh1tYHMGEe7-Qima96uYO4E+uAPcaB8K6bmQ@mail.gmail.com>
References: <1360669793-6921-1-git-send-email-sjur.brandeland@stericsson.com>
	<1360669793-6921-2-git-send-email-sjur.brandeland@stericsson.com>
	<CAK=Wgbb0EeiCh504jsoX+izzi+ZogfEDttz2cHRd4pVXvQunQw@mail.gmail.com>
	<CAJK669bDu3SphxmEtA+h+v=btsN91t0S9Mn6ik-OKr=8gtducw@mail.gmail.com>
	<CAK=Wgba5XkK3c7qh1tYHMGEe7-Qima96uYO4E+uAPcaB8K6bmQ@mail.gmail.com>
Date: Thu, 21 Feb 2013 18:28:53 +0100
Message-ID: <CAJK669YHwR=nf2zSQR6buaA-x1JSowJfU16hkz1+N_WLL0qA+A@mail.gmail.com>
Subject: Re: [PATCHv2 vringh 1/3] remoteproc: Add support for vringh (Host vrings)
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>, netdev@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

> I was wondering - can you please explain your motivation for using
> vringh in caif ?
>
> We have internally discussed supporting multiple remote processors
> talking to each other using rpmsg, and in that scenario using vringh
> can considerably simplifies the solution (no need to decide in advance
> which side is the "guest" and which is the "host"). Was this the
> general incentive in using vringh in caif too or something else?

The motivation for using vringh was to avoid copying buffers
when sending data from the modem to the host. By using
vringh the modem can transfer datagrams to host only by
transfering buffer pointers via the rings.

We use a carveout to declare a memory area that is passed to the
modem internal memory allocator. This way we get both modem
and host to work on the shared memory region.

For TX traffic we use normal virtio queues for the same reason.
TX buffers can be handled without copying as well.

We are seeing a nice performance gain on the modem side after
implementing this.

Host size zero-copy is more tricky. It's hard to handle ownership of buffers,
if the modem crashes. But we might look into this in the future as well.

Regards,
Sjur
