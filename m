Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3EQGyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 02:54:00 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:64615 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3EQGx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 02:53:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130517011523.GA9555@kroah.com>
References: <1367508195-2420-1-git-send-email-a13xp0p0v88@gmail.com>
	<20130517011523.GA9555@kroah.com>
Date: Fri, 17 May 2013 10:53:58 +0400
Message-ID: <CAF0T0X5RuT-7Zg9HG=tAG8CE+BLfYDv=m8vPEi2j9en5KqRkWg@mail.gmail.com>
Subject: Re: [PATCH 2/2] powerpc/512x: DMA via LocalPlus Bus testing driver
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Timur Tabi <timur@tabi.org>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/17 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Thu, May 02, 2013 at 07:23:15PM +0400, Alexander Popov wrote:
>> This module tests Direct Memory Access to some device on LocalPlus Bus
>> for Freescale MPC512x. In other words it tests the bundle
>> of mpc512x_lpbfifo and mpc512x_dma drivers.
>>
>> This testing driver was multiply used with static RAM (CY62167EV30LL-45ZXI)
>> which lives on LocalPlus Bus on our board. This testing driver was used
>> instead of the original static RAM driver and it is an abnormal hack.
>> That is why I just provide the driver code and don't modify any environment.
>>
>
> You obviously didn't test your testing driver to see if it would build
> in the kernel source tree :(
>
> Care to try again?

Hello Greg,
thanks for your comment.

You are right, this testing driver will not be built in the kernel source tree,
because I intentionally didn't send patches for the corresponding
Makefile, Kconfig and dts.

I would try to explain the reason once again:

I multiply used this testing driver with static RAM (CY62167EV30LL-45ZXI)
to test mpc512x_lpbfifo driver (which is [PATCH 1/2]:
https://patchwork.kernel.org/patch/2511941/ ).
I used this testing driver _instead_ of the original static RAM driver
and it is an abnormal hack.
Because it breaks the usual work of static RAM.
That's why I just provided the code of this testing driver and didn't
modify Makefile, Kconfig and dts.

I hoped that the code of this testing driver will help to review
mpc512x_lpbfifo in the first part of this patch.
Thanks.

Best regards,
Alexander.
