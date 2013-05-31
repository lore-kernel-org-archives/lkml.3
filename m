Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab3EaPhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:37:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58761 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3EaPhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:37:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, srinidhi.kasagar@stericsson.com,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com
Subject: Re: [PATCH 2/2] ARM: ux500: Enable HIGHMEM in the u8540 defconfig
Date: Fri, 31 May 2013 17:36:44 +0200
Message-ID: <1902994.0Kq6C7Rx1R@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <20130531151850.GC12488@gmail.com>
References: <1370010272-25520-1-git-send-email-lee.jones@linaro.org> <38058740.G1EqTG95pA@wuerfel> <20130531151850.GC12488@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BAmwOP2kV9seu9ugLlRTqxzWz5Wl1XsjOfr5xV1kY8f
 nZ6GP+f20mexMco0KyMmXVglM03ik3eKStnx7iGCRcsCYmQDhH
 8p5bsLCQDa1DSZ6Vw/5pO/RjI+m2eBK0l+6LFhHgR09kP53JEc
 FD7HnSaMIaM7qaiXAdhZ++MlUdudbyUA26nzA/m9EbkLiYg9ni
 y+8q7GY+gRINGouiVRrqC5ngzep5roNXGnF4w6aYVg0yr7j5Yi
 l05ZpyzU8xqcnJLRBdaB8QKFhreurXJ1SQt86tylpf6rE30Gcn
 85BgZEy2z52KhNZmxfPNVWVeE9EcZ4f689P0T2zFFkJmuMk+OS
 uocAXLY0b0jjlA7I8xZU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 May 2013 16:18:50 Lee Jones wrote:
> On Fri, 31 May 2013, Arnd Bergmann wrote:
> 
> > On Friday 31 May 2013 15:24:32 Lee Jones wrote:
> > > In order to utilise all of the memory located on ux500 based devices
> > > we have to enable HIGHMEM. Without it the kernel truncates memory down
> > > to what's left after the PAGE_OFFSET has been applied, which doesn't
> > > leave an awful lot, especially if we're running large rootfs' such
> > > as full Linux desktop distributions or Android.
> > > 
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > How much memory do those devices have? Enabling HIGHMEM is quite expensive.
> 
> Another 1GB.

You mean you have 2GB total or 1.75GB?  You could just use
CONFIG_VMSPLIT_2G to an extra GB compared to the default, which
is what vexpress, imx and s5p already do, but you still have to
put the vmalloc area in the low 2GB then.

	Arnd
