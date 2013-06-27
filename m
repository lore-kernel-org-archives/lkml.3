Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab3F0I03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:26:29 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:41837 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3F0I01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:26:27 -0400
MIME-Version: 1.0
In-Reply-To: <51C9D645.6030609@codeaurora.org>
References: <1371851554-4492-1-git-send-email-hanumant@codeaurora.org>
	<CACRpkdbcscJYRgTQv_4SdR3i3PJwWfYQu=OonABz3xyLO+3Ubg@mail.gmail.com>
	<51C9D645.6030609@codeaurora.org>
Date: Thu, 27 Jun 2013 10:26:26 +0200
Message-ID: <CACRpkdZjwLdUE2=Wu1ySU5mFf7Kt7_LS88-bJM6zv5=p_OMYHA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: msm: Add support for MSM TLMM pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: hanumant <hanumant@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 7:41 PM, hanumant <hanumant@codeaurora.org> wrote:
> On 06/24/2013 05:18 AM, Linus Walleij wrote:

>>> +  The following pin configurations are properties are supported by SDC pins
>>> +  - qcom,sdc1-clk-pull: Pull up/down configuration SDC1 clock pin.
>>> +  - qcom,sdc1-clk-drv: Drive strength configuration for SDC1 clock pin.
>>> +  - qcom,sdc1-cmd-pull: Pull up/down configuration for SDC1 command pin.
>>> +  - qcom,sdc1-cmd-drv: Drive strength configuration for SDC1 command pin.
>>> +  - qcom,sdc1-data-pull: Pull up/down configuration for SDC1 data pin.
>>> +  - qcom,sdc1-data-drv: Drive strength configuration for SDC1 data pin.
>>> +  - qcom,sdc2-clk-pull: Pull up/down configuration SDC2 clock pin.
>>> +  - qcom,sdc2-clk-drv: Drive strength configuration for SDC2 clock pin.
>>> +  - qcom,sdc2-cmd-pull: Pull up/down configuration for SDC2 command pin.
>>> +  - qcom,sdc2-cmd-drv: Drive strength configuration for SDC2 command pin.
>>> +  - qcom,sdc2-data-pull: Pull up/down configuration for SDC2 data pin.
>>> +  - qcom,sdc2-data-drv: Drive strength configuration for SDC2 data pin.
>>
>> I don't understand why each sdc thing needs its own definition
>> for everything. Please use the generic pin config bindings, call the
>> generic parser function and then reject if someone tries to config
>> something that is not supported.
>
> The register semantics of SDC1 clk, command, and data lines, pull up and
> drive strength attributes differ from SDC2 clk, command and data lines.

The register semantics does not have anything to do with the
representation in the device tree. The register semantics is a matter
for the driver, the device tree tells how to configure that driver,
the idea is not to name all species of config registers in the device
tree but to configure them, logically.

> In general the TLMM v3 has more pin types then just the general/multi
> purpose(gp) and SDC pin types above.
> There are some pin types on the TLMM, whose config attributes do not
> fall under the cattegories supported by generic pin config.

One does not exclude the other. Some aspect of a pin
may be configured using the generic bindings, some aspect
need vendor-specific extensions.

> These attributes in some cases happen to be protocol specific.
> Hence I would prefer to go with a custom config pack and unpack
> implementation rather then the generic one.

I disagree, but I'm open to negotiations :-)

Yours,
Linus Walleij
