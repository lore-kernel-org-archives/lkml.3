Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaIIG2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:28:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbaIIG2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:28:40 -0400
Message-ID: <540E9DCC.4080903@redhat.com>
Date: Tue, 09 Sep 2014 02:27:24 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Tomasz Nowicki <tomasz.nowicki@linaro.org>
CC: Marc Zyngier <marc.zyngier@arm.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 13/17] ARM64 / ACPI: Add GICv2 specific ACPI boot support
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <5405BFE7.5060005@arm.com> <5406DEB6.1060705@linaro.org> <4895927.Zp4WL2AZAF@wuerfel>
In-Reply-To: <4895927.Zp4WL2AZAF@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 10:57 AM, Arnd Bergmann wrote:
> On Wednesday 03 September 2014 11:26:14 Tomasz Nowicki wrote:

> In particular, the ACPI tables describing the irqchip have no way to
> identify the GIC at all, if I read the spec correctly, you have to
> parse the tables, ioremap the registers and then read the ID to know
> if you have GICv1/v2/v2m/v3/v4. There doesn't seem to be any "device"
> for the GIC that a hypothetical probe function would be based on.

(aside) I have already noticed this and am separately raising a request
to have this dealt with in the specification at a later time. I believe
it's fairly contrived, since I don't think it'll be at all common to
have a GICv3/v4 IP implementation that has a CPU interface defined.

The problem (not now, but in later implementations that actually have
GICv3/v4 hardware is making assumptions since even a GICv3 or GICv4
system could implement a legacy compatibility mode in which the memory
register interface is defined and mappable so you would be valid in
having defined memory addresses in the MADT linked structures then.

Jon.

