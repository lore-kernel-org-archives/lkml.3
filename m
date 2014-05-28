Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaE1IPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:15:47 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:64149 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbaE1IPo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:15:44 -0400
MIME-Version: 1.0
In-Reply-To: <2480893.UEqfxe8meR@phil>
References: <CACRpkdZyLxMTSygRP6pD-mxghQ_D6tQ821tvn8GYw0Rnh9hZoQ@mail.gmail.com>
	<1401172056-25743-1-git-send-email-iivanov@mm-sol.com>
	<2480893.UEqfxe8meR@phil>
Date: Wed, 28 May 2014 10:15:43 +0200
Message-ID: <CACRpkdbaWYgku0_n5CqGU8DAFnn-5jEJ64Mfh9fixB4mRPnfwg@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: Enable "power-source" to be extracted from DT files
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        James Hogan <james.hogan@imgtec.com>,
        Stephen Warren <swarren@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 3:09 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Dienstag, 27. Mai 2014, 09:27:36 schrieb Ivan T. Ivanov:
>> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>>
>> Add "power-source" property to generic options used for DT parsing files.
>> This  enables drivers, which use generic pin configurations, to get the
>> value passed to this property.
>
> I think the main problem here is, that pinconf-generic.h defines the power-
> source as having a "custom format". With DT as a hardware description,
> implementaton specific values do not work well - instead it should have a
> regular unit-value.
>
> For the power-source I think volts could work well - as this is the main use-
> case for pinctrl I know. The regulator-binding uses microvolts, maybe it would
> be good use a similar unit.
(...)
>         pcfg_1v8 {
>                 power-source = <1800000>;
>         };

I don't think this is what it's meant for actually. In this case the thing would
be modeled as a regulator rather than some pin control option I guess?

I think it's more like a selector, such as found on old amplifiers,
input source A, B or C? So it's just some discrete number.

Then we don't know which voltage comes from power source A, B, C.

Yours,
Linus Walleij
