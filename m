Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaKGNEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:04:00 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44250 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaKGND5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:03:57 -0500
Message-ID: <545CC337.4020409@collabora.com>
Date: Fri, 07 Nov 2014 14:03:51 +0100
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Rob Herring <robherring2@gmail.com>
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
References: <1414599796-30597-1-git-send-email-tomeu.vizoso@collabora.com> <1414599796-30597-5-git-send-email-tomeu.vizoso@collabora.com> <545B172C.4060105@nvidia.com> <CAL_JsqKYSF3JVrXH_dkqRXQrgUU3igzvoK1C2k1Caz-4UuHX6Q@mail.gmail.com> <545C5927.3010001@nvidia.com>
In-Reply-To: <545C5927.3010001@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 06:31 AM, Alexandre Courbot wrote:
> On 11/07/2014 12:12 AM, Rob Herring wrote:
>> On Thu, Nov 6, 2014 at 12:37 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>>> On 10/30/2014 01:22 AM, Tomeu Vizoso wrote:
>>>>
>>>> The EMC clock needs some extra information for changing its rate.
>>>>
>>>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>>>> ---
>>>>    .../bindings/clock/nvidia,tegra124-car.txt         | 46
>>>> +++++++++++++++++++++-
>>>>    1 file changed, 44 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git
>>>> a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
>>>> b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
>>>> index ded5d62..42e0588 100644
>>>> --- a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
>>>> +++ b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
>>>> @@ -19,12 +19,35 @@ Required properties :
>>>>      In clock consumers, this cell represents the bit number in the CAR's
>>>>      array of CLK_RST_CONTROLLER_RST_DEVICES_* registers.
>>>>
>>>> +The node should contain a "emc-timings" subnode for each supported RAM
>>>> type (see
>>>> +field RAM_CODE in register PMC_STRAPPING_OPT_A), with its unit address
>>>> being its
>>>> +RAM_CODE.
>>>> +
>>>> +Required properties for "emc-timings" nodes :
>>>> +- nvidia,ram-code : Should contain the value of RAM_CODE this timing set
>>>> +  is used for.
>>>> +
>>>> +Each "emc-timings" node should contain a "timing" subnode for every
>>>> supported
>>>> +EMC clock rate. The "timing" subnodes should have the clock rate in Hz as
>>>> their
>>>> +unit address.
>>>
>>>
>>> This seems to be a quite liberal use of unit addresses (same in the next
>>> patch) - is this allowed by DT?
>>
>> No, unit address should match a reg property.
> 
> Mmm, would you have any suggestion as to how this can be fixed? Right 
> now what I can think of is either to replace the "clock-frequency" 
> property by "reg" (which would be confusing), or to use a different 
> naming scheme, e.g. timing-12750000. IIUC the naming is not essential 
> for properly parsing these nodes, so maybe the second solution is the 
> way to go?

Yeah, there seems to be a precedent for embedding the frequency in the
node name in the TI DTs, e.g.: virt_12000000_ck.

Thanks,

Tomeu
