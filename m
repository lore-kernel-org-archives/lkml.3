Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaGNDKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 23:10:06 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:58350 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaGNDJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 23:09:59 -0400
MIME-Version: 1.0
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825EF2E84@P3PWEX4MB008.ex4.secureserver.net>
References: <1405204956-1559-1-git-send-email-chase.southwood@gmail.com>
	<1405205049-1828-1-git-send-email-chase.southwood@gmail.com>
	<DC148C5AA1CEBA4E87973D432B1C2D8825EF2E84@P3PWEX4MB008.ex4.secureserver.net>
Date: Sun, 13 Jul 2014 22:09:58 -0500
Message-ID: <CA+jnaaUuq_+wTJFZe+oA44Y=w7xzMjS97xfySE1GS+Atwa5NLA@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: comedi: addi_apci_1564: use addi_watchdog
 module to init watchdog subdevice
From: Chase Southwood <chase.southwood@gmail.com>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 2:17 PM, Hartley Sweeten
<HartleyS@visionengravers.com> wrote:
> On Saturday, July 12, 2014 3:44 PM, Chase Southwood wrote:
>> Use the addi_watchdog module to provide support for the watchdog
>> subdevice.
>>
>> Also, rearrange the subdevice init blocks so that the order makes sense.
>> Digital input/output subdevices and subdevices for DI/DO interrupt
>> support, followed by timer/counter/watchdog subdevices is the new order.
>>
>> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
>> ---
>>  drivers/staging/comedi/drivers/addi_apci_1564.c | 34 +++++++++++++++----------
>>  1 file changed, 20 insertions(+), 14 deletions(-)
>
> Chase,
>
> You should also add the dependency for the addi watchdog module
> to the Kconfig.
>

Hello, Hartley!

The select statement for COMEDI_ADDI_WATCHDOG was added to Kconfig for
the addi_apci_1564 driver in commit
8851362:

From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 3 Jun 2014 12:29:29 +0200
Subject: [PATCH] staging: comedi: addi_apci_1564: add addi_watchdog dependency

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is because the driver has already been using
addi_watchdog_reset() and I had forgotten to add the select to the
Kconfig when I added that function call, so Arnd added it when a
randconfig build error turned up later.  Sorry for the
confusion.

Thanks,
Chase

> Regards,
> Hartley
