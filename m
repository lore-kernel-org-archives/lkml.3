Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751035AbaHOMQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 08:16:01 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37698 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaHOMP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 08:15:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140815105615.GI17528@sirena.org.uk>
References: <1407976814-21882-1-git-send-email-cw00.choi@samsung.com>
	<1407976814-21882-3-git-send-email-cw00.choi@samsung.com>
	<20140815105615.GI17528@sirena.org.uk>
Date: Fri, 15 Aug 2014 21:15:58 +0900
Message-ID: <CAGTfZH2u-7LpdV99qpj_pLFo9kQ7WCfFSPg2X-et--7MZntebw@mail.gmail.com>
Subject: Re: [PATCHv3 2/2] dt-bindings: regulator: Add regulator suspend state
 for PM state
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        =?UTF-8?Q?Krzysztof_Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mark,

On Fri, Aug 15, 2014 at 7:56 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Aug 14, 2014 at 09:40:14AM +0900, Chanwoo Choi wrote:
>
>> +- regulator-initial-state: initial state for suspend state, cnd set initial
>> +  state among following defined suspend states:
>> +  <2>: PM_SUSPEND_STANDBY - Setup regulator according to regulator-state-standby
>> +  <3>: PM_SUSPEND_MEM - Setup regulator according to regulator-state-mem
>> +  <4>: PM_SUSPEND_MAX - Setup regulator according to regulator-state-disk
>> +- regulator-state-standby sub-root node for Standby mode
>> +  : the device is in a power-saving state, but can also receive certain events,
>> +  specific behavior depends on the specific device.
>
> These are all Linux internal descriptions of the states but the device
> tree is supposed to be OS neutral.  For suspend to memory and suspend to
> disk that's probably adequately clear but _STANDBY is really unclear.
> I would suggest just dropping this without a clearer defintion, it's
> something that I'd expect to emerge organically from low power modes
> rather than having a specific definition anyway.

OK, I'll drop PM_SUSPEND_STANDBY mode on next patchset.

>
>> +- regulator-state-[standby/mem/disk] node has following common properties:
>> +     - regulator-volt: voltage consumers may set in suspend state.
>> +     - regulator-mode: voltage mode in suspend state, can set mode among
>> +     following defined regulator modes:
>> +     0x1: REGULATOR_MODE_FAST, Regulator can handle fast changes.
>> +     0x2: REGULATOR_MODE_NORMAL, Normal regulator power supply mode.
>> +     0x4: REGULATOR_MODE_IDLE, Regulator runs in a more efficient mode.
>> +     0x8: REGULATOR_MODE_STANDBY, Regulator runs in the most efficient mode.
>> +     - regulator-on-in-suspend: regulator should be on in suspend state.
>> +     - regulator-off-in-suspend: regulator should be off in suspend state.
>> +     If node don't include regulator-[on/off]-in-suspend, can't change
>> +     regulator state in suspend mode and only should sustain the regulator
>> +     state of normal state.
>
> Modes are a similarly problematic thing - their definition is really
> unclear even within Linux and we don't support them at all at present.
> I'd just drop them initially and then add them in as a part of adding
> mode support in general.

OK, I'll drop 'regulator-mode' property on next patchset.

Thanks for your review.

Best Regards,
Chanwoo Choi
