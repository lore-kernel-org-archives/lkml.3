Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbbAFNvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:51:31 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:43079 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbbAFNv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:51:29 -0500
MIME-Version: 1.0
In-Reply-To: <20150106112000.GA8829@e104818-lin.cambridge.arm.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
	<54A28B22.7090305@linaro.org>
	<20150105131302.GB14967@e104818-lin.cambridge.arm.com>
	<1797489.PjmKzBFdQA@wuerfel>
	<20150106112000.GA8829@e104818-lin.cambridge.arm.com>
Date: Tue, 6 Jan 2015 13:51:27 +0000
Message-ID: <CAGCh1+kYRPg8QJ57bamH7Ctb1vJKmn2rirMUpbXcrU=Qw_VF2A@mail.gmail.com>
Subject: Re: [PATCH v5 18/18] Documentation: ACPI for ARM64
From: G Gregory <graeme.gregory@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Al Stone <al.stone@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "jcm@redhat.com" <jcm@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "Kangkang.Shen@huawei.com" <Kangkang.Shen@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 January 2015 at 11:20, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Mon, Jan 05, 2015 at 08:16:30PM +0000, Arnd Bergmann wrote:
>> On Monday 05 January 2015 13:13:02 Catalin Marinas wrote:
>> > > since passing no DT tables to OS but
>> > > acpi=force is missing is a corner case, we can do a follow up patch to
>> > > fix that, does it make sense?
>> >
>> > Not entirely. Why would no dtb and no acpi=force be a corner case? I
>> > thought this should be the default when only ACPI tables are passed, no
>> > need for an additional acpi=force argument.
>>
>> We don't really support the case of only ACPI tables for now. The expectation
>> is that you always have working DT support, at least for the next few years
>> as ACPI features are ramping up, and without acpi=force it should not try
>> to use ACPI at all.
>
> So if both DT and ACPI are present, just use DT unless acpi=force is
> passed. So far I think we agree but what I want to avoid is always
> mandating acpi=force even when the DT tables are missing (in the long
> run).
>
> Now, what's preventing a vendor firmware from providing only ACPI
> tables? Do we enforce it in some way (arm-acpi.txt, kernel warning etc.)
> that both DT and ACPI are supported, or at least that dts files are
> merged in the kernel first?
>
How do we tell the difference between a DT passed purely for booting purposes
ie a skeleton DT. And one which actually has hardware description as this needs
to be done before unpacking the DT.

Graeme
