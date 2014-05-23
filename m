Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaEWWwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:52:06 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:52255 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaEWWwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:52:03 -0400
MIME-Version: 1.0
In-Reply-To: <537FBB61.6070201@gmail.com>
References: <1400841343-6016-1-git-send-email-t.dakhran@samsung.com>
	<1400841343-6016-3-git-send-email-t.dakhran@samsung.com>
	<537FBB61.6070201@gmail.com>
Date: Sat, 24 May 2014 02:52:01 +0400
Message-ID: <CANhyOUfvnBj6H3CX5wPjm7HMXe4dOmQamCx3ODo4W0=K7oOJ2A@mail.gmail.com>
Subject: Re: [PATCH v10 2/3] clk: exynos5410: register clocks using common
 clock framework
From: Tarek Dakhran <t.dakhran@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Tarek Dakhran <t.dakhran@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just my inattention.
Will be corrected until Monday.

On Sat, May 24, 2014 at 1:19 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi Tarek,
>
> Thanks for keeping up with addressing my comments. See below.
>
> On 23.05.2014 12:35, Tarek Dakhran wrote:
>> The EXYNOS5410 clocks are statically listed and registered
>> using the Samsung specific common clock helper functions.
>>
>> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
>> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
>> ---
>>  .../devicetree/bindings/clock/exynos5410-clock.txt |   51 +++++
>>  drivers/clk/samsung/Makefile                       |    1 +
>>  drivers/clk/samsung/clk-exynos5410.c               |  209 ++++++++++++++++++++
>>  include/dt-bindings/clock/exynos5410.h             |   33 ++++
>>  4 files changed, 294 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>>  create mode 100644 drivers/clk/samsung/clk-exynos5410.c
>>  create mode 100644 include/dt-bindings/clock/exynos5410.h
>>
>
> The driver itself looks good, but binding documentation seems to be
> outdated. The part about external clocks, more specifically.
>
>> diff --git a/Documentation/devicetree/bindings/clock/exynos5410-clock.txt b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>> new file mode 100644
>> index 0000000..82337c4
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>> @@ -0,0 +1,51 @@
>> +* Samsung Exynos5410 Clock Controller
>> +
>> +The Exynos5410 clock controller generates and supplies clock to various
>> +controllers within the Exynos5410 SoC.
>> +
>> +Required Properties:
>> +
>> +- compatible: should be "samsung,exynos5410-clock"
>> +
>> +- reg: physical base address of the controller and length of memory mapped
>> +  region.
>> +
>> +- #clock-cells: should be 1.
>> +
>> +All available clocks are defined as preprocessor macros in
>> +dt-bindings/clock/exynos5410.h header and can be used in device
>> +tree sources.
>> +
>> +External clock:
>> +There is clock that is generated outside the SoC. It is expected
>> +that it is defined using standard clock bindings with following
>> + - compatible: should be "samsung,exynos5410-oscclk"
>
> ^^^^^

Best regards,
     Tarek
