Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab3A3AxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 19:53:10 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:61548 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3A3AxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 19:53:07 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZw_Bvz86PeNyoSjFR=O0_KkM6uJBYZ-ZhVy_g0SKun7w@mail.gmail.com>
References: <CAOAMb1AsetjcNa_K6g=6K_s=0+tTH1aGLuX8emYrfgJOcx54cw@mail.gmail.com>
	<CACRpkdaECZ5qtUVS=28eDyzLWvxx=mP6dWML5mYs9kwqnhEoJQ@mail.gmail.com>
	<CAOAMb1CCoOWgab7NYYYRVjoQBoBx4XDeeLOBjJ4RzsBwRpXv6Q@mail.gmail.com>
	<CACRpkdZw_Bvz86PeNyoSjFR=O0_KkM6uJBYZ-ZhVy_g0SKun7w@mail.gmail.com>
Date: Wed, 30 Jan 2013 09:53:03 +0900
X-Google-Sender-Auth: vxQhVP-KZQ2ShUNMug6VAlkJL6I
Message-ID: <CAOAMb1Bf-kB1=HkgMd_w-5v6Wh0XVX4knotiOu5CLKqQg+3X9g@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: PL011: Add support for Rx DMA buffer polling
From: Chanho Min <chanho.min@lge.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Then it can use DMA polling post-wakeup?
Yes, It will be switched back to DMA polling on UART IRQ.

> What do you mean by "user" here? Userspace? Or
> "platform data parameter"?
platform data parameter

> Not platform I think. Per usecase.
> Are you not actually thinking about things like the above?
> These are usecase requirements, not platform requirements.
I mean that:
Platform knows the requirement of it's ports (It can be usecase above)
and can set the poll rate with platform data parameter. Some port is
enough to do with slow poll rate, some need fast poll rate for the fast
response. Of course some port don't need rx dma and polling, in this case
we can set the poll rate to 0. If we fix the poll rate to the scale
of baud rate, we don't have such flexibility.

Anyway I just want to know we still need auto scale of poll rate.
If this become clear, I will prepare v3 of this patch.

Thanks
Chanho
