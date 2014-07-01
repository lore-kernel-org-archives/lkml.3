Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbaGAJWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:22:21 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:21128 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757737AbaGAJWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:22:18 -0400
Date: Tue, 1 Jul 2014 10:22:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        "rric@kernel.org" <rric@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Al Stone <al.stone@linaro.org>
Subject: Re: [PATCH v4 13/13] ARM64 / ACPI: Enable ARM64 in Kconfig
Message-ID: <20140701092201.GF18313@arm.com>
References: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org>
 <1403840976-7456-14-git-send-email-hanjun.guo@linaro.org>
 <20140630104652.GG28951@arm.com>
 <53B2694F.7070501@linaro.org>
 <53B26F44.7050404@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B26F44.7050404@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 09:20:20AM +0100, Hanjun Guo wrote:
> >>>  	depends on PCI
> >>>  	select PNP
> >>> -	default y
> >>> +	default y if !ARM64
> >>
> >> For the benefit of single Image, I think you can default to y here.
> > 
> > It ok to me. if we default to y here, devicetree will not be unflattened
> > in default, is it ok to you? you can refer to "[PATCH 12/13] ARM64 / ACPI: if
> > we chose to boot from acpi then disable FDT".
> 
> Ah, sorry I didn't describe it clearly. since there is no shipping board
> with ACPI tables, so ACPI will disabled in the very early stage and FDT
> still have chance to be unflattened, so will not break DT booting in
> this patchset.

That's what I thought. So leaving it as a default y is fine by me. But I
would not merge this patch now until we get some useful functionality
for arm64.

The x86-related cleanup patches can be merged separately via the
corresponding trees (it's up to the ACPI and x86 maintainers).

-- 
Catalin
