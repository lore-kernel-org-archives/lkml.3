Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbaGAML5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:11:57 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:56741 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaGAMLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:11:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140630092658.GR7262@leverpostej>
References: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
	<1403875511-7710-5-git-send-email-gabriel.fernandez@linaro.org>
	<20140630092658.GR7262@leverpostej>
Date: Tue, 1 Jul 2014 14:11:53 +0200
Message-ID: <CAG374jAAQw9Zr=hzrwdh7X3o5QkfQ81ZBtG00_gq2Uuh62V9eg@mail.gmail.com>
Subject: Re: [PATCH v2 04/14] clk: st: Adds Flexgen clock binding
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review Mark,

I'll rework this documentation to answer all these questions

Thanks

Gabriel

On 30 June 2014 11:26, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, Jun 27, 2014 at 02:25:01PM +0100, Gabriel FERNANDEZ wrote:
>> A Flexgen structure is composed by:
>> - a clock cross bar (represented by a mux element)
>> - a pre and final dividers (represented by a divider and gate elements)
>>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>> Acked-by: Peter Griffin <peter.griffin@linaro.org>
>> ---
>>  .../devicetree/bindings/clock/st/st,clkgen.txt     |  5 +++
>>  .../devicetree/bindings/clock/st/st,flexgen.txt    | 48 ++++++++++++++++++++++
>>  2 files changed, 53 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/clock/st/st,flexgen.txt
>>
>> diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
>> index 427bad8..78978f1 100644
>> --- a/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
>> +++ b/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
>> @@ -32,6 +32,10 @@ address is common of all subnode.
>>               vcc_node {
>>                       ...
>>               };
>> +
>> +             flexgen_node {
>> +                     ...
>> +             };
>>               ...
>>       };
>>
>> @@ -45,6 +49,7 @@ Each subnode should use the binding discribe in [2]..[7]
>>  [5] Documentation/devicetree/bindings/clock/st,clkgen-prediv.txt
>>  [6] Documentation/devicetree/bindings/clock/st,vcc.txt
>>  [7] Documentation/devicetree/bindings/clock/st,quadfs.txt
>> +[8] Documentation/devicetree/bindings/clock/st,flexgen.txt
>>
>>
>>  Required properties:
>> diff --git a/Documentation/devicetree/bindings/clock/st/st,flexgen.txt b/Documentation/devicetree/bindings/clock/st/st,flexgen.txt
>> new file mode 100644
>> index 0000000..f2d4333
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/clock/st/st,flexgen.txt
>> @@ -0,0 +1,48 @@
>> +Binding for a type of flexgen structure found on certain
>> +STMicroelectronics consumer electronics SoC devices
>> +
>> +This structure includes:
>> +- a clock cross bar (represented by a mux element)
>> +- a pre and final dividers (represented by a divider and gate elements)
>> +
>> +This binding uses the common clock binding[1].
>> +
>> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
>> +
>> +Required properties:
>> +- compatible : shall be:
>> +  "st,flexgen"
>
> That looks very vague. Is this a sub-node of a larger block?
>
> Might there be a future flexgen revision that looks different?
>
>> +- #clock-cells : from common clock binding; shall be set to 1.
>
> what does the clock cell represent? Is it just a linear index from 0?
>
>> +- clocks : from common clock binding
>
> This is a completely useless description.
>
> Which clock inputs do you expect clocks for? How many? Are they named?
>
>> +
>> +- clock-output-names : From common clock binding. The block has 4
>> +                       clock outputs but not all of them in a specific instance
>> +                       have to be used in the SoC. If a clock name is left as
>> +                       an empty string then no clock will be created for the
>> +                       output associated with that string index. If fewer than
>> +                       4 strings are provided then no clocks will be created
>> +                       for the remaining outputs.
>
> That's a Linux-internal detail, surely?
>
> Why do we even do that?
>
> Mark.
>
>> +
>> +Example:
>> +
>> +     clockgen-d2@x9106000 {
>> +             compatible = "st,clkgen-c32";
>> +             reg = <0x9106000 0x1000>;
>> +
>> +             clk_s_d2_flexgen: clk-s-d2-flexgen {
>> +                     compatible = "st,flexgen";
>> +
>> +                     #clock-cells = <1>;
>> +                     clocks = <&clk_s_d2_quadfs 0>,
>> +                              <&clk_s_d2_quadfs 1>,
>> +                              <&clk_s_d2_quadfs 2>,
>> +                              <&clk_s_d2_quadfs 3>;
>> +
>> +                     clock-output-names = "clk-pix-main-disp",
>> +                                          "clk-pix-pip",
>> +                                          "clk-pix-gdp1",
>> +                                          "clk-pix-gdp2";
>> +             };
>> +     };
>> --
>> 1.9.1
>>
>>
