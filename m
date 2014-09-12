Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaILTsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:48:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbaILTsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:48:12 -0400
Message-ID: <54134DB4.6010705@redhat.com>
Date: Fri, 12 Sep 2014 15:47:00 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
CC: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v4 11/18] ARM64 / ACPI: Parse MADT for SMP initialization
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <1410530416-30200-12-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1410530416-30200-12-git-send-email-hanjun.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 10:00 AM, Hanjun Guo wrote:
> MADT contains the information for MPIDR which is essential for
> SMP initialization, parse the GIC cpu interface structures to
> get the MPIDR value and map it to cpu_logical_map(), and add
> enabled cpu with valid MPIDR into cpu_possible_map.
> 
> ACPI 5.1 only has two explicit methods to boot up SMP, PSCI and
> Parking protocol, but the Parking protocol is only specified for
> ARMv7 now, so make PSCI as the only way for the SMP boot protocol
> before some updates for the ACPI spec or the Parking protocol spec.

As an aside, initial support for the Parking Protocol is working on test
systems within Red Hat at this time. Additional patches for that will be
posted separately, however Parking Protocol is not the preferred option
on ARMv8 (PSCI should be the default). Consequently, support for those
limited number of systems doing Parking Protocol can follow after the
initial support for longer term PSCI is enabled.

Jon.


