Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbbAOOKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:10:47 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:52169 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbbAOOKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:10:43 -0500
MIME-Version: 1.0
In-Reply-To: <3538097.dWBy3R9lty@wuerfel>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
 <1797489.PjmKzBFdQA@wuerfel> <20150106112000.GA8829@e104818-lin.cambridge.arm.com>
 <3538097.dWBy3R9lty@wuerfel>
From: Grant Likely <grant.likely@linaro.org>
Date: Thu, 15 Jan 2015 14:10:22 +0000
X-Google-Sender-Auth: GHKEaulzfYfUAdeG8IuOWnPw0Go
Message-ID: <CACxGe6tjiE6u8i-1PHYzX2cOhxJkYN3cV9mqhCHRSMRdOQRfzg@mail.gmail.com>
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-acpi <linaro-acpi@lists.linaro.org>, Rob Herring <robh@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Robert Moore <robert.moore@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        "jcm@redhat.com" <jcm@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 1:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 06 January 2015 11:20:01 Catalin Marinas wrote:
>> On Mon, Jan 05, 2015 at 08:16:30PM +0000, Arnd Bergmann wrote:
>> > On Monday 05 January 2015 13:13:02 Catalin Marinas wrote:
>> > > > since passing no DT tables to OS but
>> > > > acpi=force is missing is a corner case, we can do a follow up patch to
>> > > > fix that, does it make sense?
>> > >
>> > > Not entirely. Why would no dtb and no acpi=force be a corner case? I
>> > > thought this should be the default when only ACPI tables are passed, no
>> > > need for an additional acpi=force argument.
>> >
>> > We don't really support the case of only ACPI tables for now. The expectation
>> > is that you always have working DT support, at least for the next few years
>> > as ACPI features are ramping up, and without acpi=force it should not try
>> > to use ACPI at all.
>>
>> So if both DT and ACPI are present, just use DT unless acpi=force is
>> passed. So far I think we agree but what I want to avoid is always
>> mandating acpi=force even when the DT tables are missing (in the long
>> run).
>>
>> Now, what's preventing a vendor firmware from providing only ACPI
>> tables? Do we enforce it in some way (arm-acpi.txt, kernel warning etc.)
>> that both DT and ACPI are supported, or at least that dts files are
>> merged in the kernel first?
>
> We have no way of enforcing what a board vendor ships, so if they want
> to have ACPI-only machines for MS Windows, they just won't work by
> default on Linux. Once ACPI support is mature enough, we can also
> have a whitelist or a different default for using it automatically
> when no DT is present.
>
> For drivers merged upstream, I would insist that every driver merged
> for an ARM64 platform has a documented DT binding that is used in the
> driver.

That's a dumb rule. It will result in untested DT code paths being
thrown into drivers just too meet the rules rather than on whether or
not they will actually be used. It's fine to allow driver authors to
only implement the ACPI code path if that is what they are working
with. We can *always* add a DT path to the driver when it is needed.

As you say, wecannot insist that vendors implement DT as well as ACPI.
The most we can do is offer the recommendation that DT works now, but
ACPI is immature for ARM. If they choose to do ACPI only, that is
absolutely fine and they do so with the understanding that it will
take time to stabilize to the point that we're comfortable
guaranteeing support in mainline. However, that doesn't even remotely
block getting each of their drivers merged as they become ready.

g.
