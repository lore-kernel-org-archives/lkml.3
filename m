Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaH2LFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:05:44 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:63934 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaH2LFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:05:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=Xri1gVdBvmEmxzsyf3z=+Qpuzj4afJ-A2NJfPY0in00A@mail.gmail.com>
References: <1408003293-27375-1-git-send-email-addy.ke@rock-chips.com>
	<1408422974-22301-1-git-send-email-addy.ke@rock-chips.com>
	<CAD=FV=Xri1gVdBvmEmxzsyf3z=+Qpuzj4afJ-A2NJfPY0in00A@mail.gmail.com>
Date: Fri, 29 Aug 2014 13:05:39 +0200
Message-ID: <CAPDyKFqAx=WVk2T6FwsSZ0hHsC5ARZF4KhHnn9MCbT6DkAAXkg@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: dw_mmc: move rockchip related code to a separate file
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Doug Anderson <dianders@chromium.org>, Addy Ke <addy.ke@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Dinh Nguyen <dinguyen@altera.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "zhenfu.fang" <zhenfu.fang@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, lintao <lintao@rock-chips.com>,
        chenfen <chenfen@rock-chips.com>, zyf <zyf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Lin Huang <hl@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 August 2014 19:28, Doug Anderson <dianders@chromium.org> wrote:
> Hi,
>
> On Mon, Aug 18, 2014 at 9:36 PM, Addy Ke <addy.ke@rock-chips.com> wrote:
>> To support HS200 and UHS-1, we need add a big hunk of code,
>> as shown in the following patches. So a separate file for
>> rockchip SOCs is suitable.
>>
>> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
>> ---
>> Changes in v2:
>> - Kconfig: depend on ARCH_ROCKCHIP, suggested by Bartlomiej Zolnierkiewicz
>> - Kconfig: depend on OF, suggested by Doug Anderson
>> - Not change suspend/resume code, suggested by Doug Anderson
>> - If pdev->dev.of_node is NULL, then return -ENODEV, suggested by Heiko Stübner
>>
>>  drivers/mmc/host/Kconfig           |   9 +++
>>  drivers/mmc/host/Makefile          |   1 +
>>  drivers/mmc/host/dw_mmc-pltfm.c    |  57 ----------------
>>  drivers/mmc/host/dw_mmc-rockchip.c | 136 +++++++++++++++++++++++++++++++++++++
>>  4 files changed, 146 insertions(+), 57 deletions(-)
>>  create mode 100644 drivers/mmc/host/dw_mmc-rockchip.c
>>
>> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
>> index a565254..f6095f6 100644
>> --- a/drivers/mmc/host/Kconfig
>> +++ b/drivers/mmc/host/Kconfig
>> @@ -621,6 +621,15 @@ config MMC_DW_PCI
>>
>>           If unsure, say N.
>>
>> +config MMC_DW_ROCKCHIP
>> +       tristate "Rockchip specific extensions for Synopsys DW Memory Card Interface"
>> +       depends on MMC_DW && ARCH_ROCKCHIP && OF
>
> Actually, Heiko's change to check if pdev->dev.of_node is NULL means
> that you don't need to depend on OF anymore.
>
> Ulf: do you want Addy to spin again, or do you want to just remove
> this "&& OF" when applying the patch?
>
> ...I've tested this both with and without the "&& OF", and the "&& OF"
> won't really hurt anything, so:
>
> Tested-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Doug Anderson <dianders@chromium.org>

Thanks! Applied for next and by removing the dependency to "OF".

Kind regards
Uffe
