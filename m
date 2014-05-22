Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbaEVJ3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:29:54 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:55998 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbaEVJ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:29:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWyCN7UJ89xjpAj-X7rTHo_r0U6XJJwMOxGnXAeeYZXHQ@mail.gmail.com>
References: <20140522085339.26279.83340.sendpatchset@w520>
	<20140522085409.26279.64965.sendpatchset@w520>
	<CAMuHMdWyCN7UJ89xjpAj-X7rTHo_r0U6XJJwMOxGnXAeeYZXHQ@mail.gmail.com>
Date: Thu, 22 May 2014 18:29:50 +0900
Message-ID: <CANqRtoTeGe_fGjGQ_3NJA=rSbjzY4G+Mv=ekdtAx4FEyTd=U7w@mail.gmail.com>
Subject: Re: [PATCH 03/03] staging: board: kzm9d: Board staging support for emxx_udc
From: Magnus Damm <magnus.damm@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Thu, May 22, 2014 at 6:19 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Magnus,
>
> On Thu, May 22, 2014 at 10:54 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
>> Add staging board support for the KZM9D board and add
>> an emxx_udc platform device to allow in-tree continous
>> development of the driver on the KZM9D board.
>>
>> When DT bindings are ready for the emxx_udc driver then
>> the platform device in the KZM9D staging board code can
>> easily be removed. Until then we use platform devices
>> to continously improve the driver and integration code.
>
> Nice!

Thanks, I hope it can turn into something useful!

>>  drivers/staging/Kconfig        |    2 ++
>>  drivers/staging/Makefile       |    1 +
>>  drivers/staging/board/Kconfig  |    7 +++++++
>>  drivers/staging/board/Makefile |    1 +
>>  drivers/staging/board/board.h  |   17 +++++++++++++++++
>>  drivers/staging/board/kzm9d.c  |   18 ++++++++++++++++++
>>  6 files changed, 46 insertions(+)
>
> As you're adding infrastructure and a first user, I think this should
> be split in two patches:
>   - Introduction of drivers/staging/board infrastructure,
>   - Addition of kzm9d board support.

I agree!

>> --- /dev/null
>> +++ work/drivers/staging/board/Kconfig  2014-05-22 15:31:58.000000000 +0900
>> @@ -0,0 +1,7 @@
>> +config STAGING_BOARD
>> +       boolean "Staging Board Support"
>> +       help
>> +         Select to enable per-board staging support code.
>> +
>> +         If in doubt, say N here.
>> +
>
> No board-specific Kconfig symbols, so the actual individual board
> support itself is
> always compiled-in (but see below)?

Yes, the user has a single switch to flip at this point.

>> --- /dev/null
>> +++ work/drivers/staging/board/Makefile 2014-05-22 15:31:58.000000000 +0900
>> @@ -0,0 +1 @@
>> +obj-$(CONFIG_ARCH_SHMOBILE_MULTI)      += kzm9d.o
>
> Ah, it's included in all shmobile multi-platform kernels.

Correct!

> What about testing for CONFIG_ARCH_EMEV2 instead of
> CONFIG_ARCH_SHMOBILE_MULTI?

That is quite fine with me.

> Or adding a KZM9D-specific Kconfig symbol to .../board/Kconfig?

Yeah, we could do that but my gut feeling is that it is better and
easier to just keep it simple. I'm happy to adjust in any direction
here though, so whatever makes people happy...!

Thanks for your feedback!

/ magnus
