Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3JRNLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:11:01 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:51211 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab3JRNLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:11:00 -0400
MIME-Version: 1.0
In-Reply-To: <001701ceb92b$dad5f3b0$9081db10$%debski@samsung.com>
References: <1378898858-30639-1-git-send-email-k.debski@samsung.com>
	<CAFp+6iGGSqVtCK+NBGB1ZUy_8yUgfUzpS7_xG56Dfx25tkLOuw@mail.gmail.com>
	<CAFp+6iGetST=SMkP5ETup6HY6_F=m6CgMGuw9a_iLwOR-Uyd=w@mail.gmail.com>
	<001701ceb92b$dad5f3b0$9081db10$%debski@samsung.com>
Date: Fri, 18 Oct 2013 18:40:58 +0530
Message-ID: <CAFp+6iF+8qb-E9Jb7m5ib41tsJyTX=1-q0pNJx6=R2f1ULtOMw@mail.gmail.com>
Subject: Re: [RFC] [PATCH] phy: Add new Exynos USB PHY driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Tue, Sep 24, 2013 at 7:12 PM, Kamil Debski <k.debski@samsung.com> wrote:
> Hi,
>
>> From: Vivek Gautam [mailto:gautamvivek1987@gmail.com]
>> Sent: Friday, September 20, 2013 1:44 PM
>>
>> On Fri, Sep 20, 2013 at 5:11 PM, Vivek Gautam
>> <gautamvivek1987@gmail.com> wrote:
>> > On Wed, Sep 11, 2013 at 4:57 PM, Kamil Debski <k.debski@samsung.com>
>> wrote:
>> >> Add a new driver for the Exynos USB PHY. The new driver uses the
>> >> generic PHY framework.
>> >>
>> >> Signed-off-by: Kamil Debski <k.debski@samsung.com>
>> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> >> Cc: Kishon Vijay Abraham I <kishon@ti.com>
>> >> Cc: Tomasz Figa <t.figa@samsung.com>
>> >> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> >> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
>> >> ---
>> >>
>> >> Hi,
>> >>
>> >> This patch adds a new drive for USB PHYs for Samsung SoCs. The
>> driver
>> >> is using the Generic PHY Framework created by Kishon Vijay Abrahan I.
>> >> It can be found here https://lkml.org/lkml/2013/8/21/29.
>> >> This patch adds support to Exynos4 family of SoCs. Support for
>> >> Exynos3 and
>> >> Exynos5 is planned to be added in the near future.
>> >>
>> >> I welcome your comments.
>> >
>> > How do you plan to put support for exynos5 series. I can see you have
>> > made separate files for exynos4210 and 4212.
>> > Now for exynos5250 and above, we should be able to re-use some of the
>> > functions like "4212_rate_to_clk()" and "4212_iso()".
>
> I see two options. One - moving the functions that could be reused to
> separate file.
> Two - exporting these functions in let's say 4212 and using them in 5250.
> What do you think?

Sorry for going dormant after replying to this patch. I think i missed
the mail (so adding the Samsung account also here).

I think, if there are quite a number of functions that need to be
reused among exynos5 and exynos5,
then it may make sense to have another file (like we had until now :
drivers/usb/phy/phy-samsung-usb.c)
But from what i could see there aren't many functions to reuse in the
current code structure, so it
may be good to export them in exynos4 only and let exynos5 use that.
I think Sylwester or Tomasz can better comment on the approach.

>
> I will also support for S5PC110 in the Exynos 4210 file, as they are very
> similar.
>
>> >
>> > Let me know if i can help with something for exynos5 stuff.
>
> Now, I am trying to run the USB device on Exynos5. The board I am using is
> the Arndale board. Unfortunately I am having trouble as the USB lines from
> SoC
> are connected both to the device port and the USB/Ethernet chip (AX88796).
> Did you use the Arndale board when working with Exynos 5?

I use smdk board for exynos5, but to get USB ports working on Arndale, you will
need to properly configure GPIOs for USB 3503 hub, since the AX88796
chip is connected
through this HSIC hub.
Please refer to Linaro's git for Arndale development. You can find the
solution there.

>
>> >
>>
>> Also please add linux-usb and linux-samsung mailing list too.
>
> I will.

Are you planning to send the updated patch series anytime soon ?
I can prepare necessary patches for exynos5 support based on your
patches. This may speed up the task.
Please let me know your opinion.

>
> [snip]
>
> Best wishes,
> --
> Kamil Debski
> Linux Kernel Developer
> Samsung R&D Institute Poland
>



-- 
Best Regards
Vivek
