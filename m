Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbbAENNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:13:22 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55327 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbbAENNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:13:20 -0500
Date: Mon, 5 Jan 2015 13:13:02 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
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
        "Kangkang.Shen@huawei.com" <Kangkang.Shen@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Al Stone <al.stone@linaro.org>
Subject: Re: [PATCH v5 18/18] Documentation: ACPI for ARM64
Message-ID: <20150105131302.GB14967@e104818-lin.cambridge.arm.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
 <1413553034-20956-19-git-send-email-hanjun.guo@linaro.org>
 <20141224171815.GD13399@e104818-lin.cambridge.arm.com>
 <54A28B22.7090305@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54A28B22.7090305@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2014 at 11:23:14AM +0000, Hanjun Guo wrote:
> On 2014年12月25日 01:18, Catalin Marinas wrote:
> > On Fri, Oct 17, 2014 at 02:37:14PM +0100, Hanjun Guo wrote:
> >> +Booting using ACPI tables
> >> +-------------------------
> >> +The only defined method for passing ACPI tables to the kernel on ARMv8
> >> +is via the UEFI system configuration table.
> >> +
> >> +Processing of ACPI tables may be disabled by passing acpi=off on the kernel
> >> +command line; this is the default behavior.  If acpi=force is used, the kernel
> >> +will ONLY use device configuration information contained in the ACPI tables.
> >
> > See my comments to Al around the defaults. I think if only ACPI tables
> > are present, we shouldn't panic the kernel if acpi=force is missing but
> > continue with ACPI.
> 
> I think we need another patch to implement it, for this patch set,kernel
> will panic if no dtb and acpi=off.

If no dtb and acpi=off on the kernel command line, I agree that the
kernel should panic as it doesn't have any way to get the platform
description.

> since passing no DT tables to OS but
> acpi=force is missing is a corner case, we can do a follow up patch to
> fix that, does it make sense?

Not entirely. Why would no dtb and no acpi=force be a corner case? I
thought this should be the default when only ACPI tables are passed, no
need for an additional acpi=force argument.

-- 
Catalin
