Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbbAFODV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:03:21 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55901 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbbAFODS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:03:18 -0500
Date: Tue, 6 Jan 2015 14:03:06 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: G Gregory <graeme.gregory@linaro.org>
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
Subject: Re: [PATCH v5 18/18] Documentation: ACPI for ARM64
Message-ID: <20150106140305.GE8829@e104818-lin.cambridge.arm.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
 <54A28B22.7090305@linaro.org>
 <20150105131302.GB14967@e104818-lin.cambridge.arm.com>
 <1797489.PjmKzBFdQA@wuerfel>
 <20150106112000.GA8829@e104818-lin.cambridge.arm.com>
 <CAGCh1+kYRPg8QJ57bamH7Ctb1vJKmn2rirMUpbXcrU=Qw_VF2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGCh1+kYRPg8QJ57bamH7Ctb1vJKmn2rirMUpbXcrU=Qw_VF2A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 01:51:27PM +0000, G Gregory wrote:
> On 6 January 2015 at 11:20, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Mon, Jan 05, 2015 at 08:16:30PM +0000, Arnd Bergmann wrote:
> >> On Monday 05 January 2015 13:13:02 Catalin Marinas wrote:
> >> > > since passing no DT tables to OS but
> >> > > acpi=force is missing is a corner case, we can do a follow up patch to
> >> > > fix that, does it make sense?
> >> >
> >> > Not entirely. Why would no dtb and no acpi=force be a corner case? I
> >> > thought this should be the default when only ACPI tables are passed, no
> >> > need for an additional acpi=force argument.
> >>
> >> We don't really support the case of only ACPI tables for now. The expectation
> >> is that you always have working DT support, at least for the next few years
> >> as ACPI features are ramping up, and without acpi=force it should not try
> >> to use ACPI at all.
> >
> > So if both DT and ACPI are present, just use DT unless acpi=force is
> > passed. So far I think we agree but what I want to avoid is always
> > mandating acpi=force even when the DT tables are missing (in the long
> > run).
> >
> > Now, what's preventing a vendor firmware from providing only ACPI
> > tables? Do we enforce it in some way (arm-acpi.txt, kernel warning etc.)
> > that both DT and ACPI are supported, or at least that dts files are
> > merged in the kernel first?
>
> How do we tell the difference between a DT passed purely for booting purposes
> ie a skeleton DT. And one which actually has hardware description as this needs
> to be done before unpacking the DT.

You do the check in EFI_STUB (part of the kernel). An ACPI-only firmware
should never pass a DT to the kernel, not even for booting purposes
(EFI_STUB builds one on the fly to pass parameters to the kernel but
that's purely an internal kernel decision).

There are other ways as well, but if we decide to enforce this, I think
EFI_STUB is the best option.

-- 
Catalin
