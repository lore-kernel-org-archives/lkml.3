Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab3BJSpY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 13:45:24 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:52101 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab3BJSpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 13:45:22 -0500
MIME-Version: 1.0
In-Reply-To: <20130210004740.GH16278@quad.lixom.net>
References: <cover.1360340791.git.nicolas.ferre@atmel.com>
	<20130210004740.GH16278@quad.lixom.net>
Date: Sun, 10 Feb 2013 19:45:21 +0100
Message-ID: <CAMgPeKV4=C_msvZixVS-o3-QHaJxZP7T4EwLa9vnmYgVheXHgQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] at91: atmel_lcdfb: regression fixes and cpu_is removal
From: Johan Hovold <jhovold@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        FlorianSchandinat@gmx.de,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, jacmet@sunsite.dk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 1:47 AM, Olof Johansson <olof@lixom.net> wrote:
> On Fri, Feb 08, 2013 at 05:35:13PM +0100, Nicolas Ferre wrote:
>> These patches fix a regression in 16-bpp support for older SOCs which
>> use IBGR:555 rather than BGR:565 pixel layout. Use SOC-type to
>> determine if the controller uses the intensity-bit and restore the
>> old layout in that case.
>>
>> The last patch is a removal of uses of cpu_is_xxxx() macros in
>> atmel_lcdfb with a platform-device-id table and static
>> configurations.
>>
>>
>> Patches from Johan Hovold taken from: "[PATCH 0/3] atmel_lcdfb: fix
>> 16-bpp regression" and "[PATCH v2 0/3] ARM: at91/avr32/atmel_lcdfb:
>> remove cpu_is macros" patch series to form a clean patch series with
>> my signature.
>>
>> Arnd, Olof, as it seems that old fbdev drivers are not so much
>> reviewed those days, can we take the decision to queue this material
>> through arm-soc with other AT91 drivers updates?
>
> It would be beneficial to get an ack from Florian. Was he involved in
> the review of the code that regressed 16-bpp support in the first
> place? When was the regression introduced?

In v3.4 by commit 787f9fd2328 ("atmel_lcdfb: support 16bit BGR:565 mode,
remove unsupported 15bit modes").

Johan
