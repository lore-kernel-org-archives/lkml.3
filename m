Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3J2IMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:12:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35948 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3J2IMI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:12:08 -0400
Subject: Re: [PATCH v9 1/5] ARM: add basic support for Trusted Foundations
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20131029002543.GF4763@kartoffel>
Date: Tue, 29 Oct 2013 03:12:05 -0500
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <Pawel.Moll@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <0232E02C-5F41-4EC6-9011-86D67005433D@codeaurora.org>
References: <1382956118-12495-1-git-send-email-acourbot@nvidia.com> <D49A3E92-54FD-4275-82F5-DBB476086B03@codeaurora.org> <20131028215649.GB10833@quad.lixom.net> <2702565.PHk13m6fVo@flatron> <20131029002543.GF4763@kartoffel>
To: Mark Rutland <mark.rutland@arm.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 28, 2013, at 7:25 PM, Mark Rutland wrote:

> On Mon, Oct 28, 2013 at 11:31:36PM +0000, Tomasz Figa wrote:
>> On Monday 28 of October 2013 14:56:49 Olof Johansson wrote:
>>> On Mon, Oct 28, 2013 at 05:57:04AM -0500, Kumar Gala wrote:
>>>> On Oct 28, 2013, at 5:28 AM, Alexandre Courbot wrote:
>>>>> Trusted Foundations is a TrustZone-based secure monitor for ARM that
>>>>> can be invoked using the same SMC-based API on all supported
>>>>> platforms. This patch adds initial basic support for Trusted
>>>>> Foundations using the ARM firmware API. Current features are limited
>>>>> to the ability to boot secondary processors.
>>>>> 
>>>>> Note: The API followed by Trusted Foundations does *not* follow the
>>>>> SMC
>>>>> calling conventions. It has nothing to do with PSCI neither and is
>>>>> only
>>>>> relevant to devices that use Trusted Foundations (like most
>>>>> Tegra-based
>>>>> retail devices).
>>>>> 
>>>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>>>>> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>>>>> Reviewed-by: Stephen Warren <swarren@nvidia.com>
>>>>> ---
>>>>> .../arm/firmware/tl,trusted-foundations.txt        | 20 ++++++
>>>>> .../devicetree/bindings/vendor-prefixes.txt        |  1 +
>>>>> arch/arm/Kconfig                                   |  2 +
>>>>> arch/arm/Makefile                                  |  1 +
>>>>> arch/arm/firmware/Kconfig                          | 28 ++++++++
>>>>> arch/arm/firmware/Makefile                         |  1 +
>>>>> arch/arm/firmware/trusted_foundations.c            | 79
>>>>> ++++++++++++++++++++++ arch/arm/include/asm/trusted_foundations.h  
>>>>>      | 67 ++++++++++++++++++ 8 files changed, 199 insertions(+)
>>>>> create mode 100644
>>>>> Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundatio
>>>>> ns.txt create mode 100644 arch/arm/firmware/Kconfig
>>>>> create mode 100644 arch/arm/firmware/Makefile
>>>>> create mode 100644 arch/arm/firmware/trusted_foundations.c
>>>>> create mode 100644 arch/arm/include/asm/trusted_foundations.h
>>>>> 
>>>>> diff --git
>>>>> a/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundat
>>>>> ions.txt
>>>>> b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundat
>>>>> ions.txt new file mode 100644
>>>>> index 0000000..2ec75c9
>>>>> --- /dev/null
>>>>> +++
>>>>> b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundat
>>>>> ions.txt @@ -0,0 +1,20 @@
>>>>> +Trusted Foundations
>>>>> +-------------------
>>>>> +
>>>>> +Boards that use the Trusted Foundations secure monitor can signal
>>>>> its
>>>>> +presence by declaring a node compatible with
>>>>> "tl,trusted-foundations"
>>>>> +under the /firmware/ node
>>>>> +
>>>>> +Required properties:
>>>>> +- compatible : "tl,trusted-foundations"
>>>>> +- version-major : major version number of Trusted Foundations
>>>>> firmware
>>>>> +- version-minor: minor version number of Trusted Foundations
>>>>> firmware
>>>> 
>>>> vendor prefix version.
>>> 
>>> Are you saying he should use tl,version-major tl,version-minor? For
>>> bindings that are already vendor-specific we haven't (on ARM) asked for
>>> vendor prefix on properties. It doesn't mean that we should keep going
>>> down that route though, so I'm just asking for clarification for my own
>>> edification. :)
>> 
>> This is a good question. We should decide what the right thing (TM) is and 
>> write it down. I, on the contrary, was convinced that it's the way Kumar 
>> says.
> 
> The impression I got was that properties should be prefixed when they're
> extremely vendor-specific and could clash with a more generic property. I'm not
> sure that firmware will ever have a generic binding given the variation even in
> the set of implemented functionality.
> 
> I would imagine that there are many ways different firmwares might be
> versioned, and I can't see version-major or version-minor clashing with a
> generic property we might add later. However prefixing would not be harmful, so
> I'm not opposed to it if others want that.
> 
> Another option would be to support a fallback compatible list (e.g.
> "tl,trusted-foundations-${MAJOR}-${MINOR}", "tl,trusted-foundations"), and get
> versioning information from there. Given that could be painful to handle I
> don't want to force it if not required.
> 
> Thanks,
> Mark.

I'm of the opinion that making all vendor specific properties vendor prefixed is the easiest rule of thumb and leaves no gray area to have to argue about.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

