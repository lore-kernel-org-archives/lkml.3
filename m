Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab3JIXpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 19:45:44 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:49740 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab3JIXpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 19:45:42 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <5253BF8E.4050802@monstr.eu>
References: <1380904635-18113-1-git-send-email-acourbot@nvidia.com>
	<1380904635-18113-2-git-send-email-acourbot@nvidia.com>
	<5253BF8E.4050802@monstr.eu>
Date: Wed, 9 Oct 2013 16:45:41 -0700
Message-ID: <CAOesGMjtHBft71nJUEc7K+2UA_LiWBOVWpbYvJDOnF=NLepLLw@mail.gmail.com>
Subject: Re: [PATCH v7 1/5] ARM: add basic support for Trusted Foundations
From: Olof Johansson <olof@lixom.net>
To: Michal Simek <monstr@monstr.eu>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 1:17 AM, Michal Simek <monstr@monstr.eu> wrote:
> Hi,
>
> On 10/04/2013 06:37 PM, Alexandre Courbot wrote:
>> Trusted Foundations is a TrustZone-based secure monitor for ARM that
>> can be invoked using the same SMC-based API on all supported
>> platforms. This patch adds initial basic support for Trusted
>> Foundations using the ARM firmware API. Current features are limited
>> to the ability to boot secondary processors.
>>
>> Note: The API followed by Trusted Foundations does *not* follow the SMC
>> calling conventions. It has nothing to do with PSCI neither and is only
>> relevant to devices that use Trusted Foundations (like most Tegra-based
>> retail devices).
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>> Reviewed-by: Stephen Warren <swarren@nvidia.com>
>> ---
>>  .../arm/firmware/tl,trusted-foundations.txt        | 17 +++++
>>  .../devicetree/bindings/vendor-prefixes.txt        |  1 +
>>  arch/arm/Kconfig                                   |  2 +
>>  arch/arm/Makefile                                  |  1 +
>>  arch/arm/firmware/Kconfig                          | 28 ++++++++
>>  arch/arm/firmware/Makefile                         |  1 +
>>  arch/arm/firmware/trusted_foundations.c            | 77 ++++++++++++++++++++++
>>  arch/arm/include/asm/trusted_foundations.h         | 64 ++++++++++++++++++
>>  8 files changed, 191 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
>>  create mode 100644 arch/arm/firmware/Kconfig
>>  create mode 100644 arch/arm/firmware/Makefile
>>  create mode 100644 arch/arm/firmware/trusted_foundations.c
>>  create mode 100644 arch/arm/include/asm/trusted_foundations.h
>>
>> diff --git a/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
>> new file mode 100644
>> index 0000000..3954bbd
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
>> @@ -0,0 +1,17 @@
>> +Trusted Foundations
>> +
>> +Boards that use the Trusted Foundations secure monitor can signal its
>> +presence by declaring a node compatible with "tl,trusted-foundations"
>> +under the root node.
>> +
>> +Required properties:
>> +- compatible : "tl,trusted-foundations"
>> +- version-major : major version number of Trusted Foundations firmware
>> +- version-minor: minor version number of Trusted Foundations firmware
>> +
>> +Example:
>> +     firmware {
>> +             compatible = "tl,trusted-foundations";
>> +             version-major = <2>;
>> +             version-minor = <8>;
>> +     };
>
> This is just another example how to add sw description to dts.
> I have briefly looked at tegra20.dtsi and there are IPs like timer, intc, etc
> which are in the DTS without any bus.
>
> Add this firmware node to the root is just +1 case to this mess
> but IMHO will be good to have specific DT part which will be used for
> this sw setting which are coming to DTS all the time.
>
> Grant, Rob: Where is the proper location for these type of description?

Usually we've been using the /firmware hierarchy for these kind of things.

Chrome OS uses /firmware/chromeos for some of the information passing
from FW to the OS.

You might want a separate node under /firmware for this, since this is
"just" the secure runtime portion of things, there might be need to
add things for/from the bootloader too.


-Olof
