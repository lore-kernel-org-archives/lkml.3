Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaKGNLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:11:09 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44265 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaKGNLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:11:05 -0500
Message-ID: <545CC4E1.4010605@collabora.com>
Date: Fri, 07 Nov 2014 14:10:57 +0100
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 04/13] of: document new emc-timings subnode in nvidia,tegra124-car
References: <1414599796-30597-1-git-send-email-tomeu.vizoso@collabora.com> <1414599796-30597-5-git-send-email-tomeu.vizoso@collabora.com> <545B172C.4060105@nvidia.com> <CAL_JsqKYSF3JVrXH_dkqRXQrgUU3igzvoK1C2k1Caz-4UuHX6Q@mail.gmail.com>
In-Reply-To: <CAL_JsqKYSF3JVrXH_dkqRXQrgUU3igzvoK1C2k1Caz-4UuHX6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 04:12 PM, Rob Herring wrote:
> On Thu, Nov 6, 2014 at 12:37 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> On 10/30/2014 01:22 AM, Tomeu Vizoso wrote:
>>>                 #clock-cells = <1>;
>>>                 #reset-cells = <1>;
>>>         };
>>> @@ -60,4 +83,23 @@ Example board file:
>>>         &tegra_car {
>>>                 clocks = <&clk_32k> <&osc>;
>>>         };
>>> +
>>> +       clock@0,60006000 {
>>> +               emc-timings@3 {
>>> +                       nvidia,ram-code = <3>;
>>> +
>>> +                       timing@12750000 {
>>> +                               clock-frequency = <12750000>;
>>> +                               nvidia,parent-clock-frequency =
>>> <408000000>;
>>> +                               clocks = <&tegra_car TEGRA124_CLK_PLL_P>;
>>> +                               clock-names = "emc-parent";
> 
> Why do you need both clocks and hardcoded values? clock-frequency is
> the desired freq you want to set TEGRA124_CLK_PLL_P to?

For the EMC clock to run at 12.75 MHz, its parent should become
TEGRA124_CLK_PLL_P and it has to be running at 408 MHz.

> The clocks property really belongs as part of the memory controller
> node or a memory device node.

What would be the rationale for that? The clock provider needs to know
what clock should become the parent of the EMC clock when changing rates.

Thanks,

Tomeu
