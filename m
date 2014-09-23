Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbaIWSMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:12:54 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:32846 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343AbaIWSMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:12:52 -0400
MIME-Version: 1.0
In-Reply-To: <1411360807-7750-1-git-send-email-pankaj.dubey@samsung.com>
References: <1411360807-7750-1-git-send-email-pankaj.dubey@samsung.com>
Date: Tue, 23 Sep 2014 20:12:50 +0200
Message-ID: <CAGhQ9VzZ8LadDT5RWUSX89q0WP3fGiQ8f=bWbRVfEz5Vy_zZKw@mail.gmail.com>
Subject: Re: [PATCH v5] mfd: syscon: Decouple syscon interface from platform devices
From: Joachim Eastwood <manabian@gmail.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kgene.kim@samsung.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, naushad@samsung.com,
        b29396@freescale.com, tomasz.figa@gmail.com, joshi@samsung.com,
        thomas.ab@samsung.com, Li.Xiubo@freescale.com,
        vikas.sajjan@samsung.com, chow.kim@samsung.com, lee.jones@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 September 2014 06:40, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> Currently a syscon entity can be only registered directly through a
> platform device that binds to a dedicated syscon driver. However in
> certain use cases it is desirable to make a device used with another
> driver a syscon interface provider.
>
> For example, certain SoCs (e.g. Exynos) contain system controller
> blocks which perform various functions such as power domain control,
> CPU power management, low power mode control, but in addition contain
> certain IP integration glue, such as various signal masks,
> coprocessor power control, etc. In such case, there is a need to have
> a dedicated driver for such system controller but also share registers
> with other drivers. The latter is where the syscon interface is helpful.
>
> In case of DT based platforms, this patch decouples syscon object from
> syscon platform driver, and allows to create syscon objects first time
> when it is required by calling of syscon_regmap_lookup_by APIs and keep
> a list of such syscon objects along with syscon provider device_nodes
> and regmap handles.
>
> For non-DT based platforms, this patch keeps syscon platform driver
> structure where is can be probed and such non-DT based drivers can use
> syscon_regmap_lookup_by_pdev API and get access to regmap handles.
> Once all users of "syscon_regmap_lookup_by_pdev" migrated to DT based,
> we can completly remove platform driver of syscon, and keep only helper
> functions to get regmap handles.
>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
> Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>

Hi Pankaj,

I wrote a clk driver using syscon and your patch. clk driver uses
CLK_OF_DECLARE, btw.

It works but I get a '(null): Failed to create debugfs directory'
message in the boot log.

Tested-by: Joachim Eastwood <manabian@gmail.com>

regards,
Joachim Eastwood
