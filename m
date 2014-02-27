Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaB0Ij5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:39:57 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64412 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaB0Ijy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:39:54 -0500
MIME-Version: 1.0
In-Reply-To: <38730952.JbtPf2mapG@avalon>
References: <1393323673-2751-1-git-send-email-geert@linux-m68k.org>
	<1393323673-2751-4-git-send-email-geert@linux-m68k.org>
	<38730952.JbtPf2mapG@avalon>
Date: Thu, 27 Feb 2014 09:39:54 +0100
X-Google-Sender-Auth: -2arIu7B7MNu1xgCUIlRzit7gY4
Message-ID: <CAMuHMdU_ej9cE=qmRL2WqvEW+fNA_5bj7OC2=7B7ZR33FaFUTA@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] spi: sh-msiof: Add support for R-Car H2 and M2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mark Brown <broonie@kernel.org>, Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 11:16 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>> diff --git a/Documentation/devicetree/bindings/spi/sh-msiof.txt
>> b/Documentation/devicetree/bindings/spi/sh-msiof.txt index
>> eae3c8c9300e..1f0cb33763a1 100644
>> --- a/Documentation/devicetree/bindings/spi/sh-msiof.txt
>> +++ b/Documentation/devicetree/bindings/spi/sh-msiof.txt
>> @@ -1,8 +1,13 @@
>>  Renesas MSIOF spi controller
>>
>>  Required properties:
>> -- compatible           : "renesas,sh-msiof" for SuperH, or
>> +- compatible           : "renesas,msiof-<soctype>" for SoCs,
>> +                      "renesas,sh-msiof" for SuperH, or
>>                        "renesas,sh-mobile-msiof" for SH Mobile series.
>> +                      Examples with soctypes are:
>> +                      "renesas,msiof-sh7724" (SH)
>
> Given that the driver doesn't handle the "renesas,msiof-sh7724" compatible
> string this might not be a good example. Furthermore SuperH doesn't have DT
> support. I would thus drop the "renesas,sh-msiof" compatible string from patch
> 1/6 and wouldn't mention sh7724 here. I very much doubt that someone would
> have developed DT support for SuperH on the side and shipped products that
> would be broken by this change :-)

Upon reading your comment again: do you suggest to also remove the plain
"renesas,sh-msiof"? That one was present before, since DT support was added
to the driver in

commit cf9c86efecf9510e62388fd174cf607671c59fa3
Author: Bastian Hecht <hechtb@gmail.com>
Date:   Wed Dec 12 12:54:48 2012 +0100

    spi/sh-msiof: Add device tree parsing to driver

    This adds the capability to retrieve setup data from the device tree
    node. The usage of platform data is still available.

    Signed-off-by: Bastian Hecht <hechtb+renesas@gmail.com>
    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

So I prefer not to remove any pre-existing compatible values.
Do you agree?

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
