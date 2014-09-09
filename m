Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaIIFMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 01:12:17 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:59344 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaIIFMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 01:12:15 -0400
Message-ID: <540E8C1F.5060802@linaro.org>
Date: Tue, 09 Sep 2014 13:11:59 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jon Masters <jcm@redhat.com>
CC: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/17] ARM64 / ACPI: Parse MADT for SMP initialization
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <1409583475-6978-10-git-send-email-hanjun.guo@linaro.org> <20140903172138.GG1824@e102568-lin.cambridge.arm.com> <5408854B.9010703@linaro.org> <540E8212.8090304@redhat.com>
In-Reply-To: <540E8212.8090304@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年09月09日 12:29, Jon Masters wrote:
> Hi Hanjun, Lorenzo,

Hi Jon,

>
> Resending due to my mail client removing list CCs...sorry about that.
>
> On 09/04/2014 11:29 AM, Hanjun Guo wrote:
>
>>>> +	} else {
>>>> +		/* Fist GICC entry must be BSP as ACPI spec said */
>>> s/Fist/First/
>>>
>>>> +		if  (cpu_logical_map(0) != mpidr) {
>>>> +			pr_err("First GICC entry is not BSP for MPIDR 0x%llx\n",
>>>> +			       mpidr);
>>>> +			return -EINVAL;
>>>> +		}
>>> Interesting, this means that if I want to change the boot CPU I have to
>>> recompile the ACPI tables. Is that really true ?
> Well, the ACPI5.1 specification does require that the PEs (cores) be
> listed in a very specific order, with the boot CPU first, and then a
> precisely defined sequence of interleaving of any possible SMT threads
> with other cores. So I think you would in practice update your tables.

Thanks for the clarify.

>
>>>> +	/*
>>>> +	 * ACPI 5.1 only has two explicit methods to boot up SMP,
>>>> +	 * PSCI and Parking protocol, but the Parking protocol is
>>>> +	 * only specified for ARMv7 now, so make PSCI as the only
>>>> +	 * way for the SMP boot protocol before some updates for
>>>> +	 * the ACPI spec or the Parking protocol spec.
>>>> +	 */
> The Parking Protocol may be updated for a (limited) number of platforms
> that may use it in the early days. The preferred option (as described in
> the SBBR) is to use PSCI when at all possible. Some implementations of
> the architecture may not be able to use PSCI for MP-Boot. Thus while
> there may be some limited early use of the parking protocol (including
> while PSCI firmware is being finalized during bringup activities), it
> will ultimately be completely replaced by PSCI based boot over time.

Thank you for the clarify again :)

Will Parking Protocol be upstreamed? If yes, I think we can update the
comments when Parking Protocol driver upstreamed.

Thanks
Hanjun 

