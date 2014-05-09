Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbaEIKHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:07:31 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:36174 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbaEIKH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:07:29 -0400
Message-ID: <536CA8DE.9080505@atmel.com>
Date: Fri, 9 May 2014 12:07:26 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Jean-Jacques Hiblot" <jjhiblot@traphandler.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 00/11] ARM: at91: rework main and slow clk implementation
References: <1398172360-7837-1-git-send-email-boris.brezillon@free-electrons.com> <53613D23.3020503@atmel.com> <20140430190742.5718.938@quantum>
In-Reply-To: <20140430190742.5718.938@quantum>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/04/2014 21:07, Mike Turquette :
> Quoting Nicolas Ferre (2014-04-30 11:12:51)
>> On 22/04/2014 06:12, Boris BREZILLON :
>>> Hello,
>>>
>>> This series introduce the real clock model (as described in atmel datasheets)
>>> for slow and main clocks.
>>>
>>> The modifications introduced by this series break the DT compat, but, as the
>>> at91 CCF based implementation is pretty new (introduced in 3.14 only for sama5
>>> eval boards) I think it won't impact a lot of users.
>>>
>>> Nicolas, Mike, if this series is accepted, I'd like to get it merged as soon as
>>> possible to prevent other developpers from using a deprecated DT binding.
>>> Moreover, I think this series should go through the same path for both clk
>>> and DT changes (whatever path is chosen: either at91 or clk tree) because the
>>> changes are tightly coupled.
>>
>> Boris,
>>
>> First of all, well...
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>
>> I didn't find something to add but the little comment about the
>> documentation that you already fixed in this v3 version.
>>
>> Mike,
>>
>> I would like to merge this whole series through my tree and then the
>> arm-soc tree. If it is okay for you, can you give your acknowledgement
>> before that I build a pull-request for the arm-soc guys?
> 
> Patches #1-4:
> 
> Acked-by: Mike Turquette <mturquette@linaro.org>

Whole series stacked on top of at91-3.16-cleanup branch (with v4
corrections from Boris).

Thanks, bye,

>>> Changes since v2:
>>>  - add missing compatible in pmc.c
>>>  - fix sam9261 slow clock definition
>>>  - move xtal nodes out of /clocks node
>>>  - fix DT bindings documentation
>>>  - fix main RC oscillator initilization
>>>
>>> Changes since v1:
>>> - fix sam9rl main clk definition
>>> Boris BREZILLON (11):
>>>   clk: at91: rework main clk implementation
>>>   clk: at91: update main clk documentation
>>>   clk: at91: add slow clks driver
>>>   clk: at91: add slow clk documentation
>>>   ARM: at91/dt: move sama5d3 SoC to the new main/slow clk model
>>>   ARM: at91/dt: add xtal frequencies to sama5d3xcm boards
>>>   ARM: at91/dt: add xtal frequencies to sama5d3 xplained board
>>>   ARM: at91/dt: move at91sam9261 SoC to the new main clock model
>>>   ARM: at91/dt: define main xtal frequency of the at91sam9261ek board
>>>   ARM: at91/dt: move at91sam9rl SoC to the new slow/main clock models
>>>   ARM: at91/dt: define sam9rlek crystal frequencies
>>>
>>>  .../devicetree/bindings/clock/at91-clock.txt       | 128 ++++-
>>>  arch/arm/boot/dts/at91-sama5d3_xplained.dts        |   8 +
>>>  arch/arm/boot/dts/at91sam9261.dtsi                 |  23 +-
>>>  arch/arm/boot/dts/at91sam9261ek.dts                |   4 +
>>>  arch/arm/boot/dts/at91sam9rl.dtsi                  |  46 +-
>>>  arch/arm/boot/dts/at91sam9rlek.dts                 |   9 +
>>>  arch/arm/boot/dts/sama5d3.dtsi                     |  61 ++-
>>>  arch/arm/boot/dts/sama5d3xcm.dtsi                  |   8 +
>>>  drivers/clk/at91/Makefile                          |   4 +-
>>>  drivers/clk/at91/clk-main.c                        | 577 ++++++++++++++++++---
>>>  drivers/clk/at91/clk-slow.c                        | 467 +++++++++++++++++
>>>  drivers/clk/at91/pmc.c                             |  17 +
>>>  drivers/clk/at91/pmc.h                             |   9 +
>>>  drivers/clk/at91/sckc.c                            |  57 ++
>>>  drivers/clk/at91/sckc.h                            |  22 +
>>>  include/linux/clk/at91_pmc.h                       |   1 +
>>>  16 files changed, 1352 insertions(+), 89 deletions(-)
>>>  create mode 100644 drivers/clk/at91/clk-slow.c
>>>  create mode 100644 drivers/clk/at91/sckc.c
>>>  create mode 100644 drivers/clk/at91/sckc.h
>>>
>>
>>
>> -- 
>> Nicolas Ferre
> 


-- 
Nicolas Ferre
