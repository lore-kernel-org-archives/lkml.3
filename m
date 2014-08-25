Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbaHYOXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:23:14 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:63831 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbaHYOXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:23:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAHXqBFJ3bWW8NVYcjxLnkk=6qxcRv75iCuBLrHuF91wxcL=61g@mail.gmail.com>
References: <1408459784-9385-1-git-send-email-jonas.jensen@gmail.com>
	<1408459784-9385-2-git-send-email-jonas.jensen@gmail.com>
	<CAHXqBFJ3bWW8NVYcjxLnkk=6qxcRv75iCuBLrHuF91wxcL=61g@mail.gmail.com>
Date: Mon, 25 Aug 2014 16:23:09 +0200
Message-ID: <CACmBeS010Vbgx8wz9YkiQGi4gF6JNQqVRcgYtkCKGqvNs4sopA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] net: moxa: replace build_skb() with
 netdev_alloc_skb_ip_align() / memcpy()
From: Jonas Jensen <jonas.jensen@gmail.com>
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for giving feedback.

On 21 August 2014 23:43, Michał Mirosław <mirqus@gmail.com> wrote:
> This has implicit: if (!skb) BUG(); There should probably be a return
> or continue inside the if (!skb).

Fixed, see v6 update (broken out to separate patch) which now includes
increment to RX head counter

> dma_sync_single_for_device() is not needed here as CPU does not and
> should not write to the DMA_FROM_DEVICE mapping.

Fixed, this was also broken out, dma_sync_single_for_device() moved to TX path.
Maybe someone can verify this is the correct thing to do.


Regards,

   Jonas
