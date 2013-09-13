Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab3IMBbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 21:31:19 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:52006 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309Ab3IMBbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 21:31:18 -0400
Message-ID: <52326ADC.8040703@elopez.com.ar>
Date: Thu, 12 Sep 2013 22:31:08 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?ISO-8859-1?Q?David_Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] memory: add a basic OF-based memory driver
References: <1378863781-4235-1-git-send-email-emilio@elopez.com.ar> <1379032225-6425-1-git-send-email-emilio@elopez.com.ar> <CAOesGMiUMniKRLRgGPsimR0bXWQFbx+SL5dUJXOb8t0JfEcHsg@mail.gmail.com>
In-Reply-To: <CAOesGMiUMniKRLRgGPsimR0bXWQFbx+SL5dUJXOb8t0JfEcHsg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

El 12/09/13 21:57, Olof Johansson escribió:
> On Thu, Sep 12, 2013 at 5:30 PM, Emilio López <emilio@elopez.com.ar> wrote:
>> This driver's only job is to claim and ensure the necessary clock
>> for memory operation on a DT-powered machine remains enabled.
>>
>> Signed-off-by: Emilio López <emilio@elopez.com.ar>
>> ---
>>
>> I believe this new patch should resolve all the concerns raised; as
>> always, all feedback is welcome :)
>
> I think you're going about this the wrong way.
>
> If you have a problem with a clock not staying on, shouldn't you just
> marking it appropriately in the clock table instead, making sure it's
> initialized with at least one reference to it?

If by "the clock table" you mean the tree as handled by the common clock 
framework, there is no such flag available as of today; see Mike's reply 
for more information.

Personally I feel that if the general case can solve our problems (in 
this case, having a consumer who prepares and enables the clock), we 
should avoid adding special cases to the framework.

> I believe that is how
> some of the other platforms handle this, and it's a lot cleaner than
> adding a fake binding and a fake driver just to grab a single clock.

The binding doesn't have to be fake; it is actually describing the 
memory controller hardware:

mc: mc@0123000 {
	compatible = "simple-memory-controller";
	reg = <0x0123000 0x400>;
	clocks = <&pll5 1>;
};

If one day we get docs and/or have any special features we may need from 
the controller, we can use something like

mc: mc@0123000 {
	compatible = "vendor,awesome-mc", "simple-memory-controller";
	reg = <0x0123000 0x400>;
	clocks = <&pll5 1>;
};

Cheers,

Emilio

