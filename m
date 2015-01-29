Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbbA2PUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:20:24 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:46008 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbbA2PUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:20:21 -0500
Date: Thu, 29 Jan 2015 15:19:56 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Timur Tabi <timur@codeaurora.org>
Cc: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        Rob Herring <robh@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Linaro-acpi] [PATCH v7 04/17] ARM64 / ACPI: Introduce
 early_param for "acpi" and pass acpi=force to enable ACPI
Message-ID: <20150129151956.GF8951@e104818-lin.cambridge.arm.com>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <1421247905-3749-5-git-send-email-hanjun.guo@linaro.org>
 <CAOZdJXU2bFR1T4ZnGavvnrUXAp5e=vNt9g6WKX46H8qs1wz-TQ@mail.gmail.com>
 <CAOZdJXXe+29rux1L3QYBX0yHLy3kdi+ZJrXVd=XfgYN=R6DtKA@mail.gmail.com>
 <20150128181453.GG31752@e104818-lin.cambridge.arm.com>
 <54C92804.5090806@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C92804.5090806@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 06:18:44PM +0000, Timur Tabi wrote:
> On 01/28/2015 12:14 PM, Catalin Marinas wrote:
> >> >So it looks like there's a whole conversation about this already in
> >> >this thread that I didn't notice.  However, reading through all of it,
> >> >I still don't understand sure why the presence of ACPI tables is
> >> >insufficient to enable ACPI.
> 
> > Because ACPI on arm64 is still experimental, no matter how many people
> > claim that it is production ready in their private setups.
> 
> Fair enough.  Does this mean that passing "acpi=force" on the kernel 
> command line is a requirement for ARM64 servers?

Please read my other email and ideally the whole sub-thread. The
acpi=force should only be required if the SoC is described (from
firmware) by both DT and ACPI.

> >> >In what situation would we want to ignore ACPI tables that are
> >> >present?
> 
> > When DT tables are also present (and for the first platforms, that's
> > highly recommended, though not easily enforceable at the kernel level).
> 
> My understanding is that the EFI stub creates a device tree (and it 
> contains some important information), so I don't understand how we can 
> ever have an ACPI-only platform on ARM64 servers.

If EFI stub creates the DT itself (not passed by firmware), it will
write some information in the chosen node that the rest of the kernel
can make use of and take the appropriate decision on whether to use ACPI
or not. That's something that will be used by kexec and Xen as well
which may want to boot with ACPI tables outside an EFI environment.

-- 
Catalin
