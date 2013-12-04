Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab3LDNTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:19:24 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:50365 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab3LDNTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:19:23 -0500
Message-ID: <529F2BD9.5080808@linaro.org>
Date: Wed, 04 Dec 2013 07:19:21 -0600
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Christian Daudt <bcm@fixthebug.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mike Turquette <mturquette@linaro.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: dts: bcm281xx: define real clocks
References: <529EA78E.7060904@linaro.org> <529EA813.2070208@linaro.org> <20131204111906.GG16025@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131204111906.GG16025@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 05:19 AM, Mark Rutland wrote:
> On Wed, Dec 04, 2013 at 03:57:07AM +0000, Alex Elder wrote:
>> Replace the "fake" clocks defined in the "bcm11351.dtsi" device tree
>> file with real definitions backed by the new BCM281xx clock driver..
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> Reviewed-by: Matt Porter <matt.porter@linaro.org>
>> Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
>> ---
>>  arch/arm/boot/dts/bcm11351.dtsi |  222
>> ++++++++++++++++++++++++++++-----------
>>  1 file changed, 161 insertions(+), 61 deletions(-)
> 
> [...]
> 
>> +		/*
>> +		    * This is a place-holder clock for peripheral
>> +		    * clocks that set their parent clock to an
>> +		    * out-of-range value to explicitly select
>> +		    * "no clock" as a parent.
>> +		    */
>> +		not_selected_clk: not_selected {
>>  			#clock-cells = <0>;
>> -		};
> 
> Huh? This doesn't seem to be used at all in this series. Why is this
> here?

This has been the source of confusion before.

You're right, it's not used in the current patch.  And
because of this, I'll delete it, and add it back once
we have a clock supported that requires it.

But while we're on the subject, here's what it's for.

Each clock has a defined set of parent clocks, and
each has a small integer value that represents it in
a register that controls their selection.  In some
cases the reset value of that register field is a
(specific) value that has no defined clock associated
with it.

Here's an example.  There's a clock "hub_clk_ssp3_audio",
which has three parent clocks:  "ref_crystal" (selector
value 0),  "ref_312m" (selector value 1), and "cx40"
(selector value 2).  But on reset, the value in that
selector field is 3.

This clock is used to represent that "none selected" value.

> Thanks,
> Mark.
> 

Thank you.  I really appreciate the reviews Mark.

					-Alex
