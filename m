Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaIBNnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:43:19 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:63911 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaIBNnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:43:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-acpi@lists.linaro.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Lv Zheng <lv.zheng@intel.com>, Rob Herring <robh@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [RFC PATCH for Juno 1/2] net: smsc911x add support for probing from ACPI
Date: Tue, 02 Sep 2014 15:42:53 +0200
Message-ID: <4816592.tj3on6vUaC@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140902132651.GF27056@arm.com>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org> <20140901173245.GM2953@xora-haswell.xora.org.uk> <20140902132651.GF27056@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bVNrzbMTpB09YF7CxG5pSXrm9d52O3I+1Lae2y7YIBT
 ZF4AMEOEfwkMEYDSU+OI7eUF2svG63AzPcopCdYK8HXC7g6JdV
 5EHH/EA3wRZou4NvnBEP/THGfClI+C7Y2lSwrjVIaAn1hFKcNa
 7mv5RP/YPcuCVQT0CjDz6zDMNrKgyLxP0LnP/ThMFRkeXqZDj8
 hSWmZr1uPMJY6L9FH3f4z/aTasl/NDKW1AMEtwqBlruRYzAKpV
 bRfGWffyA26wFC7mVl5Re6OlqVh43d8VCXoI/NNB7xTtraRdmc
 X4Ja3o30jGPrCLBdAyqgOvAhEI+quibuYBZJcDXepX4uNl1Gjz
 86KUN90JOVHLd9ovdhlY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 September 2014 14:26:52 Catalin Marinas wrote:
> 
> Not much at the KS, I think it will need to be followed up on lkml
> (https://lkml.org/lkml/2014/8/17/10 is the last I'm aware of, not sure
> about any updates in the meantime).
> 
> While the above gets sorted, what's the position from an ARM
> perspective (and covered by Documentation/arm64/arm-acpi.txt)? I think
> the "Device Enumeration" section in this document is fine, it's just the
> kernel infrastructure missing.
> 
> Alternatively, you can say _DSD is not allowed (yet?) but I don't
> particularly like basing the configuration on acpi_device_id like in
> this patch. Which would leave us with ignoring any SoC containing
> devices that require such specific configuration.

The way I recall the discussion, most people were on one extreme
side of the discussion or the other:

a) We should use _DSD for ARM64 servers to maximize code reuse with
DT-enabled drivers, work around the slow UEFI standardization process,
remain in control of the actual bindings, and avoid the need for
endless per-ID platform-data definitions in drivers.

b) We should never use _DSD at all, since doing that would have no
advantage over using DT directly, and we should force every device
manufacturer to specify their bindings in an official ACPI document
to prevent random incompatible bindings from being established.
Any device that shows up in servers should not need arbitrary detailed
properties anyway, as the details are supposed to be hidden in AML.

I can understand the reasons for both approaches, and I find it hard
to say either one is invalid. However, the worst possible outcome in
my opinion would be having to support a mix of the two.

	Arnd
