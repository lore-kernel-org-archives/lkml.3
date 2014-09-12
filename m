Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaILVMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:12:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbaILVL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:11:58 -0400
Message-ID: <54136148.40106@redhat.com>
Date: Fri, 12 Sep 2014 17:10:32 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Graeme Gregory <gg@slimlogic.co.uk>
CC: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>, Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, linaro-acpi@lists.linaro.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Robert Moore <robert.moore@intel.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Lv Zheng <lv.zheng@intel.com>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Charles.Garcia-Tobin@arm.com
Subject: Re: [PATCH v4 05/18] ARM64 / ACPI: Introduce sleep-arm.c
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <1410530416-30200-6-git-send-email-hanjun.guo@linaro.org> <54134CE8.8070506@redhat.com> <20140912200355.GD9234@xora-haswell.xora.org.uk>
In-Reply-To: <20140912200355.GD9234@xora-haswell.xora.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 04:03 PM, Graeme Gregory wrote:
> On Fri, Sep 12, 2014 at 03:43:36PM -0400, Jon Masters wrote:
>> On 09/12/2014 10:00 AM, Hanjun Guo wrote:
>>> From: Graeme Gregory <graeme.gregory@linaro.org>
>>>
>>> ACPI 5.1 does not currently support S states for ARM64 hardware but
>>> ACPI code will call acpi_target_system_state() for device power
>>> managment, so introduce sleep-arm.c to allow other drivers to function
>>> until S states are defined.
>>
>> Aside: ACPI5.1 does define the Platform Communication Channel and CPC
>> (Collaborative Processor Performance Control). Some details need to be
>> fleshed out there for practical 64-bit ARMv8 server systems, but the
>> underpinnings and mechanisms are in place in the 5.1 specification that
>> can be built upon over time to achieve practical S-State equivalence.
                                                    ^ meant C/P sorry

> Disagree, S-States are about going to sleep or hibernating, that is
> nothing to do with CPU Performance.

Correct. In replying to the above, I was thinking about power and
performance management of components  - CPU (C/P), and device (D)
specific power/performance states - not the overall system (S) state,
and I went off on a tangent. That was off-topic. For the actual topic at
hand, that of global sleep, you are correct that only G0 (S0) and S5 are
really defined today. Though I do think that the PCC might be used to
actually implement overall system sleep state transitions later.

Jon.

