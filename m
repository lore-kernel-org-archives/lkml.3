Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaILVoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:44:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbaILVod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:44:33 -0400
Message-ID: <541368EE.30002@redhat.com>
Date: Fri, 12 Sep 2014 17:43:10 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, Grant Likely <grant.likely@linaro.org>
CC: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        linux-acpi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <20140911132935.068DCC408F6@trevor.secretlab.ca> <20140911134922.GG6158@arm.com> <541367E0.8060903@redhat.com>
In-Reply-To: <541367E0.8060903@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 05:38 PM, Jon Masters wrote:
> On 09/11/2014 09:49 AM, Will Deacon wrote:
>> Hi Grant,
>>
>> On Thu, Sep 11, 2014 at 02:29:34PM +0100, Grant Likely wrote:
>>> On Mon,  1 Sep 2014 22:57:38 +0800, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>>>> ACPI 5.1 has been released and now be freely available for
>>>> download [1]. It fixed some major gaps to run ACPI on ARM,
>>>> this patch just follow the ACPI 5.1 spec and prepare the
>>>> code to run ACPI on ARM64.
>>>>
>>>> ACPI 5.1 has some major changes for the following tables and
>>>> method which are essential for ARM platforms:
>>>> 1) MADT table updates.
>>>> 2) FADT updates for PSCI
>>>> 3) GTDT
>>>>
>>>> This patch set is the ARM64 ACPI core patches covered MADT, FADT
>>>> and GTDT, platform board specific drivers are not covered by this
>>>> patch set, but we provide drivers for Juno to boot with ACPI only
>>>> in the follwing patch set for review purpose.
>>
>> [...]
>>
>>> I've read through this entire series now. In my mind, aside from a few
>>> comments that I know you're addressing, this is ready.  The hooks into
>>> arm64 core code are not terribly invasive, it is nicely organized and
>>> manageable. Get the next version out ASAP, but I would also like to see
>>> the diffs from this version to the next so I don't need to review the
>>> entire series again.
>>>
>>> Regarding the requests to refactor ACPICA to work better for ARM. I
>>> completely agree that it should be done, but I do not think it should be
>>> a prerequisite to getting this core support merged. That kind of
>>> refactoring is far easier to justify when it has immediate improvement
>>> on the mainline codebase, and it gives us a working baseline to test
>>> against. Doing it the other way around just makes things harder.
>>>
>>> I would really like to see the next version of this series go into
>>> linux-next. I think this is ready for some wider exposure. Have you got
>>> a branch being pulled into Fengguang's autobuilder yet?
>>
>> Apart from build testing, what does this wider exposure achieve? Is there a
>> platform available that would be able to boot Linux (to a meaingful state)
>> with this patch series alone?
> 
> With this patch series, plus a couple of minor device patches (to add
> the necessary OF->ACPI probe conversion, which is needed in any case) it
> is possible to boot both an AMD Seattle and an APM Mustang system[0] to
> a prompt. Both sets of hardware should be represented at Connect next
> week. In addition, AMD will be following up with an example (similar to
> the Juno one) for booting Seattle with the current patchset.

If anyone would like to set aside some time early next week (ahead of
the Friday and possible other sessions discussing ACPI status) to go
over specifics of certain hardware such as Seattle, I am happy to assist
setting that up. Suravee from AMD will be there, and we will both have
Seattle hardware able to run these patches with us.

Jon.


