Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbbAPQgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:36:13 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:54436 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545AbbAPQgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:36:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Al Stone <al.stone@linaro.org>
Cc: linaro-acpi@lists.linaro.org, Rob Herring <robh@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Jon Masters <jcm@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
Date: Fri, 16 Jan 2015 17:35:24 +0100
Message-ID: <3666560.Yq8BxWCZ3E@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54B7F767.6060808@linaro.org>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <2277974.2klgILPa2Q@wuerfel> <54B7F767.6060808@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:0eCXve5G5DCs58CsvFywiPhGNgW9ZatQf5LpotrpN58A3bSCZPw
 d5sxUFfETqzihHXxFc+A+Kooj66uhJGtm/CWdZ+UJn/AfoysU6WBr9pCcIwG6PR0Ko81N/5
 nQqC8s2XucuNiJbmn7Y9eEaB9JK3+pvUr6P505earJonLDoyvsNZKbRC0RKn7kjP3PuYtS8
 LTo6hpI4psny8wbMHAYsg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2015 10:22:47 Al Stone wrote:
> 
> Can I restate the position as I hear it, then?  I want to make sure
> I'm understanding what's being said.
> 
> What I'm reading seems to say: if an ARMv8 vendor wants Linux support
> in the upstream kernel, regardless of whether or not it is a mobile or
> server product, they must submit DT-based patches until such time as
> ACPI on arm64 is deemed "mature."  Do I have that correct?

I was specifically referring to SoC specific device drivers here.
It's a bit unclear what a 'vendor' is in this context, but I'd hope
that as long as we have basic support for a SoC, other people can
build DT blobs for these machines and have them run Linux out of
the box.

> That implies to me that if I want to build an ACPI-only product, there
> is no way to predict when or if I can get Linux support.  And, that if
> I do want Linux support, and need ACPI for my end-users, I have to
> maintain both sets of firmware for some unknown time into the future.
> Is that what was meant?

The firmware is normally not written by the people that do the SoC,
and we have very little control over what someone puts in their
firmware. Shipping an ACPI-only firmware would still work, but has
the danger of breaking if we ever have to make incompatible changes
to the way we interpret the ACPI tables and we have to support users
that can't upgrade their firmware.

Hopefully we can quickly get to the point where we don't have to
make incompatible changes, but I don't think that is realistic
from the day we first merge ACPI support.

	Arnd
