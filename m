Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab3LIPcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:32:05 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53703 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab3LIPcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:32:01 -0500
Message-ID: <1386603119.30495.331.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] net: sk == 0xffffffff fix - not for commit
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Date: Mon, 09 Dec 2013 07:31:59 -0800
In-Reply-To: <1386589672-5830-1-git-send-email-andrzej.p@samsung.com>
References: <1386589672-5830-1-git-send-email-andrzej.p@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-09 at 12:47 +0100, Andrzej Pietrasiewicz wrote:
> NOT FOR COMMITTING TO MAINLINE.
> 
> With g_ether loaded the sk occasionally becomes 0xffffffff.
> It happens usually after transferring few hundreds of kilobytes to few
> tens of megabytes. If sk is 0xffffffff then dereferencing it causes
> kernel panic.
> 
> This is a *workaround*. I don't know enough net code to understand the core
> of the problem. However, with this patch applied the problems are gone,
> or at least pushed farther away.

Is it happening on SMP or UP ?

Crash should happen earlier in __inet_lookup_established()


