Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab3LEWZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 17:25:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52342 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3LEWZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 17:25:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC part1 PATCH 0/7] Make ACPI core running on ARM64
Date: Thu, 5 Dec 2013 23:25:02 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312052325.02603.arnd@arndb.de>
X-Provags-ID: V02:K0:RT3YNvS/ez2II07yqgA1ZHRVGEyDMH4ZW7Q4XC4GwiT
 BtZmx9Wo9MVaN9fiTr4GTBeLJq+uVDNSlsVof7Zp/qx6naCMsC
 zIYaG3pY0tfvABBA+xxWyY9VCJSvIZd01KRlyU53BjIpB1kYIO
 0KY4KjHmEu69aTofF86cW53wVB5NxFyGOxXc0FIZyLI80+TeP+
 ySep3qg5l8hO08X3tjSBrFkinZ77SrQbeDNgl+fmnZAoq4u7sF
 Y5O3TOCwiCCIkSu6MbS+xZwMwNIpFljLQUGpV1dRVpzLC+7iU1
 Wxplkl+TD2PI2ki1zy5p2Z4FoqWFWgAEUY5EiWtUt19iUyfMav
 M8Z2kXyx9Bes1O8wEsQE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 December 2013, Hanjun Guo wrote:
> This is the first part of making ACPI core running on ARM.
> 
> PCI is optional on ARM64 but ACPI is dependent on PCI now, so
> in the first patch we try to make ACPI can be running without
> PCI.
> 
> _PDC is requred for ACPI processor_core.c, but its related code
> is a little bit x86/ia64 dependent, so I rework _PDC related staff
> to make it more arch independent, and then introduce the skeleton
> of _PDC related for ARM64, it should be fully implemented after
> ACPI spec is ready for processor idle control.
> 
> After that, arm-core.c is introduced so we can get ACPI table from
> UEFI, then we can parsed for SMP initialisation, GIC initialisation
> and for ACPI drivers.
> 
> This patch set is based on:
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
> 
> origin/linux-next branch and plus Al Stone's v2 reduced hardware profile
> patch.

As a meta-comment, I looked over all your patches and none of this looks
scary. It's definitely good that you're doing this work to put the patches
out here for discussion and to get the get the details of this sorted out.
It already looks much better than the earlier snapshots I had looked at
in git trees in the past.

However, as I mentioned before I am much more worried about the parts that
are not done (or not posted) yet and that will be required to actually
have working support for a real server system. Until we know more about
where this is heading, I think we should not merge any of the ARM specific
parts of your patches. Any patches that are reasonable cleanups and bug
fixes for the ACPI subsystem should of course get merged once they are
reviewed.

	Arnd
