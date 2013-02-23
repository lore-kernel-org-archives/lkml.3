Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab3BWJuQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 04:50:16 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49513 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab3BWJuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 04:50:11 -0500
MIME-Version: 1.0
X-Originating-IP: [109.186.70.35]
In-Reply-To: <CAJK669Yr=rkmBhUNZGSQAQzC46c3v2KVewnAaEJhKT1a0Ci8Pw@mail.gmail.com>
References: <1360669793-6921-1-git-send-email-sjur.brandeland@stericsson.com>
 <1360669793-6921-2-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=Wgbb0EeiCh504jsoX+izzi+ZogfEDttz2cHRd4pVXvQunQw@mail.gmail.com>
 <CAJK669bDu3SphxmEtA+h+v=btsN91t0S9Mn6ik-OKr=8gtducw@mail.gmail.com>
 <CAK=Wgba5XkK3c7qh1tYHMGEe7-Qima96uYO4E+uAPcaB8K6bmQ@mail.gmail.com>
 <CAJK669YHwR=nf2zSQR6buaA-x1JSowJfU16hkz1+N_WLL0qA+A@mail.gmail.com>
 <CAK=Wgbam=Y5GJQxg2DSt2yR6CdcDxjZ5k_Av_0H8+6m+scN+Yw@mail.gmail.com> <CAJK669Yr=rkmBhUNZGSQAQzC46c3v2KVewnAaEJhKT1a0Ci8Pw@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 23 Feb 2013 11:49:49 +0200
Message-ID: <CAK=Wgba5JamLr4ocFfkBPf5WTh-kAFEuxhgkoj=5rc9mten9eA@mail.gmail.com>
Subject: Re: [PATCHv2 vringh 1/3] remoteproc: Add support for vringh (Host vrings)
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>, netdev@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 9:36 PM, Sjur Brændeland <sjurbren@gmail.com> wrote:
> OK, We did carefully consider using the normal vrings, but concluded it was
> not doable. I'll try to give you some of the background that I can
> recall from top of my head.
> (I can dig out more if you're still not convinced :)
>
> The modem we're integrating with is a complex beast (multi mode modem
> LTE, HSPA+, etc).
> When a packet is received deep down in the radio stack, it allocates packet
> buffers using the internal slab allocator.The packet may contain
> anything from control, voice,
> or IP packets. If the packet contains IP-payload it will travel to a
> different asymmetric CPU that
> handles the IPC towards the modem. If the packet is not a IP-packet it will be
> processed internally and eventually freed.
>
> What we have done to integrate virtio is to inject the carveout into the
> the modem internal slab-allocator.
>
> Using the reversed ring allows us to introduce zero-copy for virtio
> with virtually no
> impact on the radio-stack, only a small change on the modem slab allocator.
> It supports dynamic size buffer allocation, and modem internal
> messaging using data
> allocated from the shared region. It also allows modem to manage it's
> own memory,
> without any dependency on host side allocators.

Thanks for the description, Sjur.

It sounds like this mostly simplifies your modem-side code, especially
if it talks to other cores as well. My impression is that persistently
sticking to guest vrings is also possible, but it makes things
cumbersome.

We will most probably adopt vringh in rpmsg too when a real multicore
use case shows up.

Ohad.
