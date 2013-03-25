Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019Ab3CYX3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 19:29:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50332 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab3CYX3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 19:29:47 -0400
Message-ID: <5150DDDD.9010904@wwwdotorg.org>
Date: Mon, 25 Mar 2013 17:29:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Mike Turquette <mturquette@linaro.org>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, git@xilinx.com,
        =?UTF-8?B?SmFuIEzDvA==?= =?UTF-8?B?YmJl?= <jlu@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: RFC v2: Zynq Clock Controller
References: <27dae808-1d3a-4001-8eb2-b0a6e2a34b8f@AM1EHSMHS013.ehs.local> <514B5254.50101@metafoo.de> <128fc723-ace7-4f4c-95d9-971b42a52080@CH1EHSMHS028.ehs.local>
In-Reply-To: <128fc723-ace7-4f4c-95d9-971b42a52080@CH1EHSMHS028.ehs.local>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 04:41 PM, Sören Brinkmann wrote:
> Hi Lars,
> 
> On Thu, Mar 21, 2013 at 07:32:52PM +0100, Lars-Peter Clausen wrote:
>> On 03/21/2013 12:56 AM, Sören Brinkmann wrote:
>>> Hi,
>>>
>>> I spent some time working on this and incorporating feedback. Here's an updated proposal for a clock controller for Zynq:
>>>
>>> Required properties:
>>>  - #clock-cells : Must be 1
>>>  - compatible : "xlnx,ps7-clkc"  (this may become 'xlnx,zynq-clkc' terminology differs a bit between Xilinx internal and mainline)
>>>  - ps-clk-frequency : Frequency of the oscillator providing ps_clk in HZ
>>>                      (usually 33 MHz oscillators are used for Zynq platforms)
>>>  - clock-output-names : List of strings used to name the clock outputs. Shall be a list of the outputs given below.
>>>
>>> Optional properties:
>>>  - clocks : as described in the clock bindings
>>>  - clock-names : as described in the clock bindings
>>>
>>> Clock inputs:
>>> The following strings are optional parameters to the 'clock-names' property in
>>> order to provide optional (E)MIO clock sources.
>>>  - swdt_ext_clk
>>>  - gem0_emio_clk
>>>  - gem1_emio_clk
>>>  - mio_clk_XX          # with XX = 00..53
>>>
>>> Example:
>>>         clkc: clkc {
>>>                 #clock-cells = <1>;
>>>                 compatible = "xlnx,ps7-clkc";
>>>                 ps-clk-frequency = <33333333>;
>>
>> The input frequency should be a clock as well.
>
> Again, monolithic vs split. I don't see a reason not to just internally
> call clk_register_fixed_rate(). That way its children do not have to
> cope with a variable name for the xtal.
> Also, with my proposal 'clocks' and 'clock-names' would be purely
> optional properties, only required if optional external inputs are
> present. Having the xtal defined externally would add mandatory entries for
> those props.

But isn't the clock source board-specific? It's a completely separate
object from Zynq's own clock controller HW, and as such should be
represented by a separate DT node, right?

The issue with parent clock names is simply a red herring. A solution is
needed to registered clock with a parent clock object, rather than a
parent clock name. Then, the parent names are completely irrelevant.
