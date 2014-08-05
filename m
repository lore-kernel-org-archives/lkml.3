Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbaHELCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:02:55 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:37256 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbaHELCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:02:53 -0400
MIME-Version: 1.0
In-Reply-To: <53E09467.8070905@denx.de>
References: <20140802135204.GA7635@himangi-Dell>
	<1406988450.383937334@f99.i.mail.ru>
	<53E09467.8070905@denx.de>
Date: Tue, 5 Aug 2014 13:02:52 +0200
X-Google-Sender-Auth: aseFjioGcdcV8InMBtDth2TV33s
Message-ID: <CAG9MbtLNoVhbFbnm25RSP02p60oF65Z-S80FhB=FVW7SrLu+Tg@mail.gmail.com>
Subject: Re: [PATCH] can: mcp251x: Use dmam_alloc_coherent
From: christian pellegrin <chripell@fsfe.org>
To: Stefano Babic <sbabic@denx.de>
Cc: Himangi Saraogi <himangi774@gmail.com>,
        Alexander Shiyan <shc_work@mail.ru>, julia.lawall@lip6.fr,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Jingoo Han <jg1.han@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

BTW the reason that use of DMA is selectable by a parameter is that on
some architectures (for example the venerable S3C24x0) the cost for
its setup is so high that it doesn't make sense for smaller transfers.
I absolutely agree with Stefano and Alexander, the SPI master driver
is in the best position to decide if DMA is worth or not.


On Tue, Aug 5, 2014 at 10:23 AM, Stefano Babic <sbabic@denx.de> wrote:
>> Just for information: On my opinion, all SPI DMA stuff should be going into SPI layer.
>> It is not a good idea to keep this into this driver.
>
> If I can add my two cents, I agree with Alexander. An underlying SPI
> (master) controller driver can or cannot support DMA transfer, and this
> should be transparent to the CAN layer. The mcp251x driver works with
> both of them, taking advantage when DMA is available.




-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
