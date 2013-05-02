Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab3EBEhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 00:37:42 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:62060 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3EBEhj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 00:37:39 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzsvyQLLKbuETBqfhpgkSaXH9cvT0O-cQ-mTTXXxcMqwg@mail.gmail.com>
References: <20130501.164755.1859264969403837546.davem@davemloft.net>
	<CA+55aFzsvyQLLKbuETBqfhpgkSaXH9cvT0O-cQ-mTTXXxcMqwg@mail.gmail.com>
Date: Wed, 1 May 2013 21:37:38 -0700
X-Google-Sender-Auth: Mtw6blBY6nOnzLuak3qz3nMxFUo
Message-ID: <CA+55aFzinZSQAS6GW6vYOyQ06+GSMqkCGb8Fu829s_MxY0L0QA@mail.gmail.com>
Subject: Re: [GIT] Networking
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>, hayeswang <hayeswang@realtek.com>,
        Patrick McHardy <kaber@trash.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 6:28 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Lowlight: it completely breaks my machine with r8169 ethernet.  In the
> networkmanager applet, it claims no cable connection, which is a bit
> odd, because (a) it works with an older kernel and (b) the kernel
> messages actually say
>
>   r8169 0000:01:00.0 eth0: link up
>
> but nothing actually works.
>
>  r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
>  r8169 0000:01:00.0 eth0: RTL8168d/8111d at 0xffffc90010ece000,
> e0:cb:4e:95:1a:d7, XID 083000c0 IRQ 53
>  r8169 0000:01:00.0 eth0: jumbo features [frames: 9200 bytes, tx
> checksumming: ko]
>
> Any ideas?

Hmm. I bisected it.

And my machine is broken by commit 8ad227ff89a7 ("net: vlan: add
802.1ad support"). I booted several times just to make sure, and it's
consistent. The previous commit (86a9bad3ab6b) works fine, and
8ad227ff89a7 is broken.

I don't see what could be broken in that commit, and I'd *like* to
just revert it on top of current -git, but that causes problems
("error: ‘NETIF_F_HW_VLAN_STAG_TX_BIT’ undeclared"), so I can't just
do a straight revert to double-check with the current tree state. But
the bisection was very straightforward, and as mentioned, I checked
that boundary several times just because it looked so odd.

Maybe somebody who knows the code better just goes "Duh!". Anybody?

                Linus
