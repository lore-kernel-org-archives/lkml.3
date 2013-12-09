Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078Ab3LIQfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:35:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62161 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989Ab3LIQfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:35:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core running without PCI on ARM64
Date: Mon, 9 Dec 2013 17:35:04 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <20131209115050.GA19163@arm.com> <52A5C024.5050702@linaro.org>
In-Reply-To: <52A5C024.5050702@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312091735.05014.arnd@arndb.de>
X-Provags-ID: V02:K0:uhIRpu5nVFDoS9tC3DVAHt04fIfUVSOb319IXTjDonu
 A+sTaMGPQ3vRXHn7RcfpDovRjYPhPJ60vjKb+lMQh+rZL/bkBF
 WcHv1jBDIU5pryxkoI3d1bm2ZAVtOY7mpKoHSUeHuXa7WbVNI+
 J3ffU9uKXQbegPIXbdYLqZ8XGctzOW/eD9bRT6eBy2x7g52GL0
 /yl2sXJ0wura1nDKqhMu5JMaiJTLxA4j0GKYUvIhmebGzDneuA
 t/B4zjrmvwrZI5il5VXN9MBat91r1NmzkGreUpAAGRSMwCJiwG
 WIBg9vyrULaB5SrpOXe9C/3gl67W2+92azVJrLlcYgrtDptE7d
 9cwAKSVuH9N7gPveS1+w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 December 2013, Hanjun Guo wrote:
> On 2013-12-9 19:50, Catalin Marinas wrote:
> > On Mon, Dec 09, 2013 at 04:12:24AM +0000, Hanjun Guo wrote:
> >>
> >> I think the concern here is that ACPI is only for server platform or not.
> >>
> >> Since ACPI has lots of content related to power management, I think ACPI
> >> can be used for mobile devices and other platform too, not only for ARM
> >> servers, and with this patch, we can support both requirement.
> > 
> > 'Can be used' is one thing, will it really be used is another? I don't
> > think so, it was (well, is) difficult enough to make the transition to
> > FDT, I don't see how ACPI would solve the current issues.

Exactly. In particular we don't want people to get the wrong idea about
where we are heading, so making it possible to use this code on embedded
systems for me is a reason *not* to take the patch.

> > I see ACPI as a server distro requirement and there are indeed benefits
> > in abstracting the hardware behind standard description, AML. Of course,
> > this would work even better with probe-able buses like PCIe and I'm
> > pretty sure this would be the case on high-end servers. But even if a
> > server distro like RHEL supports a SoC without PCIe, I would expect them
> > to only provide a single binary Image with CONFIG_PCI enabled.
> > 
> > This patch is small enough and allows ACPI build with !CONFIG_PCI for
> > the time being but longer term I would expect such SoCs without PCI to
> > be able to run on a kernel with CONFIG_PCI enabled.
> 
> Yes, we will support PCI in ACPI in the long run, and we just make PCI
> optional for ACPI in this patch.

Do you mean there is a problem running your code with PCI /enabled/ at the
moment? If so, I'd suggest fixing that instead since you will have to fix
it anyway.

	Arnd
