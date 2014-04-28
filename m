Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbaD1XNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:13:24 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:40413 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaD1XNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:13:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAGm_ybhTEN9QxFBd1Su8NGP32KeYTF8d_Z8gXKo7cYpapZrA9w@mail.gmail.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
	<1398584283-22846-31-git-send-email-shaik.ameer@samsung.com>
	<CAGm_ybhTEN9QxFBd1Su8NGP32KeYTF8d_Z8gXKo7cYpapZrA9w@mail.gmail.com>
Date: Mon, 28 Apr 2014 16:13:19 -0700
X-Google-Sender-Auth: R2a5KBZdcbGxXttmouPBPx89APs
Message-ID: <CAD=FV=UCpQRg9nWu5EfuzWmBpee9N3X6yCmtpRaNQxitfFZkMQ@mail.gmail.com>
Subject: Re: [PATCH v12 30/31] ARM: dts: add System MMU nodes of exynos5250
From: Doug Anderson <dianders@chromium.org>
To: Vikas Sajjan <sajjan.linux@gmail.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        iommu@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Grant Grundler <grundler@chromium.org>, joro@8bytes.org,
        supash.ramaswamy@linaro.org, Tomasz Figa <tomasz.figa@gmail.com>,
        sunil joshi <joshi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>, Varun.Sethi@freescale.com,
        a.motakis@virtualopensystems.com, pullip.cho@samsung.com,
        Tomasz Figa <t.figa@samsung.com>,
        RAHUL SHARMA <rahul.sharma@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vikas,


On Sun, Apr 27, 2014 at 10:39 AM, Vikas Sajjan <sajjan.linux@gmail.com> wrote:
> Hi shaik,
>
> +Doug, Abhilash,
>
> On Sun, Apr 27, 2014 at 1:08 PM, Shaik Ameer Basha
> <shaik.ameer@samsung.com> wrote:
>> From: Cho KyongHo <pullip.cho@samsung.com>
>>
>> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
>> ---
>>  arch/arm/boot/dts/exynos5250.dtsi |  270 ++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 267 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
>> index 3742331..eebd397 100644
>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>> @@ -82,6 +82,16 @@
>>                 reg = <0x10044040 0x20>;
>>         };
>>
>> +       pd_isp: isp-power-domain@0x10044020 {
>> +               compatible = "samsung,exynos4210-pd";
>> +               reg = <0x10044020 0x20>;
>> +       };
>> +
>> +       pd_disp1: disp1-power-domain@0x100440A0 {
>> +               compatible = "samsung,exynos4210-pd";
>> +               reg = <0x100440A0 0x20>;
>> +       };
>> +
>
> As per subject "add System MMU nodes of exynos5250", it should only
> add SysMMU node.
> So, I think adding power domain nodes should go in a separate patch.
>
> Adding power domain nodes can break the system, if powering ON/OFF of
> the given power domain is NOT taken care well.
> I can see ISP is one such case. With this series I can see S2R breaks
> [1] on 5250 chromebook with current mainline kernel (same applies for
> arndale and smdk5250, but I have tested on these boards yet)

Thanks for catching that!  Let's make sure not to break suspend/resume.

Given that these power domains are actually used as the domains for
some of the System MMU nodes I don't totally object to adding them in
the same patch, but if they're breaking things then I agree that we
could leave them out and add them in a later patch (once issues are
sorted out).

-Doug
