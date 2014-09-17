Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaIQBbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 21:31:40 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43607 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbaIQBbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 21:31:38 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2014 21:31:37 EDT
Date: Wed, 17 Sep 2014 02:31:14 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>, Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v4 05/18] ARM64 / ACPI: Introduce sleep-arm.c
Message-ID: <20140917013114.GB31214@srcf.ucam.org>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <1410530416-30200-6-git-send-email-hanjun.guo@linaro.org>
 <20140912145102.GB5532@arm.com>
 <20140912151850.GB9234@xora-haswell.xora.org.uk>
 <20140912154903.GE5532@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140912154903.GE5532@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 04:49:03PM +0100, Catalin Marinas wrote:

> Now, for x86, do we need acpi_sleep_init() when CONFIG_ACPI_SLEEP is
> off? If not, we could simply add a dummy acpi_sleep_init() function when
> !ACPI_SLEEP and don't enable the config option for arm64.

The !ACPI_SLEEP case still uses the ACPI code for powering the system 
down. I'd recommend adding a new CONFIG_ACPI_POWER_OFF option, wrapping 
the remaining code in sleep.c and disabling that on ARM.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
