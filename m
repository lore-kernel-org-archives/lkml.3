Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbaIIWQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 18:16:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbaIIWQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 18:16:08 -0400
Message-ID: <540F7BE2.8060403@redhat.com>
Date: Tue, 09 Sep 2014 18:14:58 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Hanjun Guo <hanjun.guo@linaro.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 04/17] ARM64 / ACPI: Introduce early_param for "acpi"
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <1409583475-6978-5-git-send-email-hanjun.guo@linaro.org> <CAErSpo6G89mkPgas8Wk3ofq__dUo5MKvBjob5D_w5_GaBJWH0w@mail.gmail.com>
In-Reply-To: <CAErSpo6G89mkPgas8Wk3ofq__dUo5MKvBjob5D_w5_GaBJWH0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 01:17 PM, Bjorn Helgaas wrote:
> On Mon, Sep 1, 2014 at 8:57 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>> From: Al Stone <al.stone@linaro.org>
>>
>> Introduce one early parameters "off" for "acpi" to disable ACPI on
>> ARM64.
> 
> It might be worth mentioning the purpose of this in the changelog (and
> maybe the documentation).  I don't think this parameter is supported
> on ia64, and on x86 it seems like it's mostly used as a "fix" by
> Ubuntu users who consider the problem resolved when they find this
> parameter.  That just means we don't get a chance to fix the real
> underlying problem, so I'm not sure it's a real benefit to have the
> parameter.

>> -       acpi=           [HW,ACPI,X86]
>> +       acpi=           [HW,ACPI,X86,ARM]
>>                         Advanced Configuration and Power Interface
>>                         Format: { force | off | strict | noirq | rsdt }
>>                         force -- enable ACPI if default was off
>> @@ -175,6 +175,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>                                 strictly ACPI specification compliant.
>>                         rsdt -- prefer RSDT over (default) XSDT
>>                         copy_dsdt -- copy DSDT to memory
>> +                       For ARM64, ONLY "acpi=off" is available.

Something along the lines of:

"The purpose of disabling ACPI on 64-bit ARM server platforms is to
allow for an orderly adoption of ACPI on early systems that may also
provide a DeviceTree based boot option initially. The acpi= option
disables both parsing of any tables passed in through the EFI System
Table RSDP and also disables the runtime ACPI interpreter on arm64".

On our internal systems, we've both ACPI and DeviceTree working with a
simple switch (acpi=) to determine the behavior, which is facilitating
an orderly total migration to ACPI that is in currently in flight.

Jon.

