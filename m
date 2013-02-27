Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258Ab3B0BB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:01:57 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:61592 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760252Ab3B0BBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 20:01:53 -0500
MIME-Version: 1.0
In-Reply-To: <1360630085-26874-1-git-send-email-dianders@chromium.org>
References: <1360630085-26874-1-git-send-email-dianders@chromium.org>
Date: Tue, 26 Feb 2013 17:01:51 -0800
X-Google-Sender-Auth: PAKLqZp-7agZNUPoB8AB5pOMl04
Message-ID: <CAD=FV=WS5Vj74d-FNXCVpNsx6Nf-8+RC-WO29Z1XNmkEOYLxfQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Add automatic bus number support for i2c busses
 with device tree
From: Doug Anderson <dianders@chromium.org>
To: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram,

On Mon, Feb 11, 2013 at 4:48 PM, Doug Anderson <dianders@chromium.org> wrote:
> This was suggested by Mark Brown in response to a patch for adding
> this functionality only for the s3c2410 bus:
>   https://lkml.org/lkml/2012/11/20/681
>
> I have also modified the i2c-pxa driver to use this new functionality.
> The i2c-pxa driver changes have only been compile-tested and are just
> for cleanup purposes.
>
> Changes in v3:
> - Addressed Wolfram's feedback; rebased atop idr-cleanup series.
>
> Changes in v2:
> - No longer tweak pdev->id as per Sylwester Nawrocki.
> - No longer add the dev ID to the adap.name.  Other drivers don't
>   include the device ID here and it doesn't make sense with
>   dynamically (or automatically) allocated IDs.
> - Use dev_name(&dev->dev) to register for the IRQ; this matches what
>   the i2c-s3c2410.c does and handles dynamically allocated IDs.
> - This change was only compile-tested (corgi_defconfig), since I don't
>   have access to a board that uses this driver.
>
> Doug Anderson (2):
>   i2c-core: dt: Pick i2c bus number from i2c alias if present
>   i2c: pxa: Use i2c-core to get bus number now
>
>  drivers/i2c/busses/i2c-pxa.c | 20 ++++++++--------
>  drivers/i2c/i2c-core.c       | 54 ++++++++++++++++++++++++++++++++------------
>  2 files changed, 49 insertions(+), 25 deletions(-)

Is there anything else needed for this patch series?  It's been
hanging around for quite a while and it would be nice to see it land.
If you're waiting for additional acks or reviews I'll ask around and
see if I can get them...

Thanks!  :)

-Doug
