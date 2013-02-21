Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3BUG4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 01:56:05 -0500
Received: from ozlabs.org ([203.10.76.45]:40175 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab3BUG4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 01:56:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ohad Ben-Cohen <ohad@wizery.com>,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Sjur =?utf-8?Q?Br=C3=A6ndelan?= =?utf-8?Q?d?= 
	<sjur@brendeland.net>,
        netdev@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, Ido Yariv <ido@wizery.com>
Subject: Re: [PATCHv2 vringh 1/3] remoteproc: Add support for vringh (Host vrings)
In-Reply-To: <CAK=Wgbb0EeiCh504jsoX+izzi+ZogfEDttz2cHRd4pVXvQunQw@mail.gmail.com>
References: <1360669793-6921-1-git-send-email-sjur.brandeland@stericsson.com> <1360669793-6921-2-git-send-email-sjur.brandeland@stericsson.com> <CAK=Wgbb0EeiCh504jsoX+izzi+ZogfEDttz2cHRd4pVXvQunQw@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 21 Feb 2013 17:07:29 +1030
Message-ID: <8738wqgok6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohad Ben-Cohen <ohad@wizery.com> writes:
> Hi Sjur,
>
> On Tue, Feb 12, 2013 at 1:49 PM,  <sjur.brandeland@stericsson.com> wrote:
>> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>>
>> Add functions for creating, deleting and kicking host-side virtio rings.
>>
>> The host ring is not integrated with virtiqueues and cannot be managed
>> through virtio-config.
>
> Is that an inherent design/issue of vringh or just a description of
> the current vringh code ?

It's by design.  The producer (virtqueue) and consumer (vringh) are two
sides of the same coin, but they do different things.

virtqueue is a slightly higher level abstraction which assumes a
virtio_device, because every user so far has had one.  vringh doesn't,
because it's also aimed to underlie vhost.c which doesn't really have
one.

> This is possible of course thanks to the abstraction provided by
> virtio: remoteproc only implements a set of callbacks which virtio
> invokes when needed.
>
> Do we not want to follow a similar design scheme with vringh ?

Hmm... I clearly jumped the gun, assuming consensus was already reached.
I have put these patches *back* into pending-rebases, and they will not
be merged this merge window.

Cheers,
Rusty.
