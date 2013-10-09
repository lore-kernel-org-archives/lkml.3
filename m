Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab3JIGLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:11:10 -0400
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:40043 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3JIGLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:11:08 -0400
Message-ID: <5254F371.2020704@codethink.co.uk>
Date: Wed, 09 Oct 2013 08:10:57 +0200
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Magnus Damm <magnus.damm@gmail.com>, takasi-y@ops.dti.ne.jp,
        SH-Linux <linux-sh@vger.kernel.org>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Mike Turquette <mturquette@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] clk: emev2: Add support for emev2 SMU clocks with
 DT
References: <20131008143040.52f36df8edb7ab63224d8433@ops.dti.ne.jp> <20131008143217.0611fba0c0d27d9c622759f3@ops.dti.ne.jp> <CANqRtoRZM=5FYG7+fq5c+TQEuHtJRmcGP1CmMq5kO5Ayvg=W6w@mail.gmail.com> <20131009033807.GM15065@verge.net.au>
In-Reply-To: <20131009033807.GM15065@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/13 05:38, Simon Horman wrote:
> On Tue, Oct 08, 2013 at 02:58:08PM +0900, Magnus Damm wrote:
>> On Tue, Oct 8, 2013 at 2:32 PM,<takasi-y@ops.dti.ne.jp>  wrote:
>>> Device tree clock binding document for EMMA Mobile EV2 SMU,
>>> And Common clock framework based implementation of it.
>>> Following nodes are defined to describe clock tree.
>>> - renesas,emev2-smu
>>> - renesas,emev2-smu-clkdiv
>>> - renesas,emev2-smu-gclk
>>>
>>> These bindings are designed manually based on
>>>   19UH0037EJ1000_SMU : System Management Unit User's Manual
>>>
>>> So far, reparent is not implemented, and is fixed to index #0.
>>> Clock tree description is not included, and should be provided
>>> by device-tree.
>>>
>>> Signed-off-by: Takashi Yoshii<takasi-y@ops.dti.ne.jp>
>>> ---
>>>   .../devicetree/bindings/clock/emev2-clock.txt      |  98 +++++++++++++++++++
>>>   drivers/clk/Makefile                               |   1 +
>>>   drivers/clk/shmobile/Makefile                      |   3 +
>>>   drivers/clk/shmobile/clk-emev2.c                   | 104 +++++++++++++++++++++
>>>   4 files changed, 206 insertions(+)
>>
>> Thanks for cleaning up the Makefile bits, Yoshii-san.
>>
>> This patch and the bindings look fine to me from a SoC point of view.
>> Using these together with the topology information in emev2.dtsi makes
>> it possible for us to use CCF and multiplatform as expected on the
>> EMEV2 SoC.
>>
>> Acked-by: Magnus Damm<damm@opensource.se>
>
> Thanks. I will send a pull request for this change to Mike Turquette.

I was going to comment on the last set but forgot.

My set dealt with the following issues

This set does not have any of the module clocks, which I added
in mine. This is also an issue with the clock and serial drivers
which do not ensure the bus/module clocks have been enabled in
the driver.

Mine also dealt with the multiple parents that some of these
clocks have.

I can try and re-post tonight for discussion.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
