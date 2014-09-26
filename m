Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaIZFeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 01:34:16 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:64577 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaIZFeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 01:34:14 -0400
MIME-Version: 1.0
In-Reply-To: <000d01cfd946$521304f0$f6390ed0$@samsung.com>
References: <1411360807-7750-1-git-send-email-pankaj.dubey@samsung.com>
	<CAGhQ9VzZ8LadDT5RWUSX89q0WP3fGiQ8f=bWbRVfEz5Vy_zZKw@mail.gmail.com>
	<13449286.k3JCbR2ABy@phil>
	<4389453.TP96FZcCbx@phil>
	<000d01cfd946$521304f0$f6390ed0$@samsung.com>
Date: Fri, 26 Sep 2014 07:34:12 +0200
Message-ID: <CAGhQ9VxwTS9=biwp0nCKu2bVU2aNe679aKR=HU5rd_Uaw99sUw@mail.gmail.com>
Subject: Re: [PATCH v5] mfd: syscon: Decouple syscon interface from platform devices
From: Joachim Eastwood <manabian@gmail.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kgene.kim@samsung.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, naushad@samsung.com,
        b29396@freescale.com, Tomasz Figa <tomasz.figa@gmail.com>,
        sunil joshi <joshi@samsung.com>, thomas.ab@samsung.com,
        Li.Xiubo@freescale.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        Lee Jones <lee.jones@linaro.org>, dianders@chromium.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2014 06:56, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> Hi Heiko and Joachim,
>
>> -----Original Message-----
>> From: Heiko Stübner [mailto:heiko@sntech.de]
>> Sent: Thursday, September 25, 2014 5:52 PM
>> To: Pankaj Dubey
>> Cc: Joachim Eastwood; linux-arm-kernel@lists.infradead.org; linux-samsung-
>> soc@vger.kernel.org; linux-kernel@vger.kernel.org; kgene.kim@samsung.com;
>> Russell King - ARM Linux; Arnd Bergmann; naushad@samsung.com;
>> b29396@freescale.com; tomasz.figa@gmail.com; joshi@samsung.com;
>> thomas.ab@samsung.com; Li.Xiubo@freescale.com; vikas.sajjan@samsung.com;
>> chow.kim@samsung.com; lee.jones@linaro.org; dianders@chromium.org
>> Subject: Re: [PATCH v5] mfd: syscon: Decouple syscon interface from
> platform
>> devices
>>
>> Am Mittwoch, 24. September 2014, 20:35:10 schrieb Heiko Stübner:
>> > Hi Pankaj, Joachim,
>> >
>> > Am Dienstag, 23. September 2014, 20:12:50 schrieb Joachim Eastwood:
>> > > On 22 September 2014 06:40, Pankaj Dubey <pankaj.dubey@samsung.com>
>> wrote:
>> > > > Currently a syscon entity can be only registered directly through
>> > > > a platform device that binds to a dedicated syscon driver. However
>> > > > in certain use cases it is desirable to make a device used with
>> > > > another driver a syscon interface provider.
>> > > >
>> > > > For example, certain SoCs (e.g. Exynos) contain system controller
>> > > > blocks which perform various functions such as power domain
>> > > > control, CPU power management, low power mode control, but in
>> > > > addition contain certain IP integration glue, such as various
>> > > > signal masks, coprocessor power control, etc. In such case, there
>> > > > is a need to have a dedicated driver for such system controller
>> > > > but also share registers with other drivers. The latter is where the
> syscon
>> interface is helpful.
>> > > >
>> > > > In case of DT based platforms, this patch decouples syscon object
>> > > > from syscon platform driver, and allows to create syscon objects
>> > > > first time when it is required by calling of
>> > > > syscon_regmap_lookup_by APIs and keep a list of such syscon
>> > > > objects along with syscon provider device_nodes and regmap handles.
>> > > >
>> > > > For non-DT based platforms, this patch keeps syscon platform
>> > > > driver structure where is can be probed and such non-DT based
>> > > > drivers can use syscon_regmap_lookup_by_pdev API and get access to
>> regmap handles.
>> > > > Once all users of "syscon_regmap_lookup_by_pdev" migrated to DT
>> > > > based, we can completly remove platform driver of syscon, and keep
>> > > > only helper functions to get regmap handles.
>> > > >
>> > > > Suggested-by: Arnd Bergmann <arnd@arndb.de>
>> > > > Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
>> > > > Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
>> > > > Tested-by: Javier Martinez Canillas
>> > > > <javier.martinez@collabora.co.uk>
>> > > > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> > >
>> > > I wrote a clk driver using syscon and your patch. clk driver uses
>> > > CLK_OF_DECLARE, btw.
>> > >
>> > > It works but I get a '(null): Failed to create debugfs directory'
>> > > message in the boot log.
>> > >
>> > > Tested-by: Joachim Eastwood <manabian@gmail.com>
>> >
>> > on Rockchip platforms this syscon support also helps quite a bit, as
>> > the pll lock-status is sitting in an external syscon register, so
>> > setting target pll-rates through assigned-clocks is not easily doable
> without it.
>> > Therefore I'm very much looking forward to this.
>> >
>> >
>> > Similar to Joachim I get an error about debugfs from regmap, which
>> > seems to be caused by
>> >     name = dev_name(map->dev);
>> > returning NULL in regmap_debugfs_init in regmap-debugfs.c for such an
>> > "early" syscon.
>>
>> It looks like of_device_make_bus_id would be able to do the necessary
> steps to
>> populate the dev_name seemingly correctly.
>>
>> With the diff below I now get a syscon that can init clocks and also a
> sane regmap
>> debugfs init:
>>
>> /debug/regmap # ls -la
>> total 0
>> drwxr-xr-x    5 0        0                0 Jan  1  1970 .
>> drwx------   19 0        0                0 Jan  1  1970 ..
>> drwxr-xr-x    2 0        0                0 Jan  1  1970 0-001b
>> drwxr-xr-x    2 0        0                0 Jan  1  1970
> ff730000.power-management
>> drwxr-xr-x    2 0        0                0 Jan  1  1970 ff770000.syscon
>>
>>
>> But of course I don't know enough about device-internals to determine if
> this is an
>> insane solution or not :-)
>>
>
> Thanks Heiko for figuring out issue and proposed solution.
>
> As you and Joachim pointed out that current patch failed to create regmap
> debugfs entry,
> I also investigated and found that it fails to create regmap debugfs entry
> either you call it
> early (from init_irq or clk_init function) or you call it in later stage
> before actual device is
> populated (from init_machine before of_platform_populate_device).
>
> One point is regmap debugfs code should have handled it gracefully instead
> of kernel panic,
> so looks like it needs some fix in that part of code.

Just for the records. My kernel didn't panic.
Don't know why it behaves different from Heiko's kernel but I was able
to boot into user space with your patch.

I wouldn't have given my 'Tested-by' if didn't boot properly.

I am working on Cortex-M4 no-MMU platform that isn't upstream yet, btw.

regards
Joachim Eastwood
