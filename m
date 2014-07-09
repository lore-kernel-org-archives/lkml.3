Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbaGILoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:44:04 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:53758 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbaGILoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:44:00 -0400
MIME-Version: 1.0
In-Reply-To: <1404904380.16296.17.camel@iivanov-dev>
References: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
	<CACRpkdYcoA-nifxojO5tZUy6dL6P2PTSGW0mVLUfqG20rOg-Nw@mail.gmail.com>
	<1404904380.16296.17.camel@iivanov-dev>
Date: Wed, 9 Jul 2014 13:43:58 +0200
Message-ID: <CACRpkdb25foEcNroqLyZbX93FxqAZ7=2pGo6GPWP8YdrjUS8gg@mail.gmail.com>
Subject: Re: [PATCH 0/4] New Qualcomm PMIC pin controller drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 1:13 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> On Wed, 2014-07-09 at 11:43 +0200, Linus Walleij wrote:
>> On Mon, Jul 7, 2014 at 5:11 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
>>
>> > This set of patches adds pin control drivers for Multi-purpose
>> > pin (MPP) and General-purpose pin (GPIO) controllers found
>> > in Qualcomm PMIC chips.
>> >
>> > MPP's are enhanced GPIO's with analog circuits, which support
>> > following functions in addition to digital input/output: analog
>> > input/output and current sinks.
>> >
>> > PMIC PM8941 have 8 MPP's and 36 GPIO's. PMIC PM8841 have 4 MPP's.
>> >
>> > Ivan T. Ivanov (4):
>> >   pinctrl: qpnp: Qualcomm PMIC pin controller driver
>> >   pinctrl: qcom: Add documentation for pinctrl-qpnp binding
>> >   pinctrl: qcom: Add PM8941 and PM8941 pinctrl drivers
>> >   ARM: dts: qcom: Add PM8941 and PM8841 pinctrl nodes
>>
>> Oh, I just spent some 45 minutes reviewing an 8xxx pinctrl driver from
>> Björn Andersson
>> that *seems* to be doing exactly the same thing.
>>
>> Now I have two drivers from people outside Qualcomm :-)
>>
>> Some of my review comments on Björn's driver (like using SI units with the pin
>> config) are actually adressed in this patch set. The idea to split in subdrivers
>> per-ASIC may be good? I don't really know.
>>
>> Can you two guys *PLEASE* join efforts and combine your drivers into one?
>
> Not sure. Björn patches cover older PMIC chips, if not mistaken, mine
> cover PMIC's used with APQ8074 and onward [1]. Main difference is
> the bus which connects them to SoC, interrupts handling, runtime
> pin type detection and register map.

Oh OK... then atleast there is something wrong with the naming of
Björns patches as they are 8xxx and your chips are also named
8xxx ...

Anyway I will create a patch to move the current msm driver down
to a folder named "qcom" and we can atleast collect these drivers
in a single place since the chipsets are related, OK?

Then I guess even if the chips are totally unrelated it'd be interesting
to have you two guys cross-review each other's drivers so the behaviour
is consistent across qualcomm platforms.

Yours,
Linus Walleij
