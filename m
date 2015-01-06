Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbbAFTXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:23:14 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:51561 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbbAFTXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:23:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-acpi@lists.linaro.org
Cc: Jon Masters <jcm@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
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
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
Date: Tue, 06 Jan 2015 20:21:35 +0100
Message-ID: <1596791.jNp4rCPpnN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54AC0C4B.1000907@redhat.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <20150106112000.GA8829@e104818-lin.cambridge.arm.com> <54AC0C4B.1000907@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:zOdFSCn9galJfVoyab5YqdkiRqJbDuamvIGmGzoxZyh8HNC4yp2
 Xe8MO9GuvMx5gKlH7IL2IAyimG+ASenIAQrOy9tPp8xIcaFEtsJXsktn35R8Z2uId2DuSeQ
 dzWqLzRpyBuYmIiScZYuiMlKjj26WBbxtocsxyRbTf35t7g9/TqjGBpeXZrZiUXgb/j1h0q
 oI4RUdBXXoF3dLYAD1vPw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2015 11:24:43 Jon Masters wrote:
> On 01/06/2015 06:20 AM, Catalin Marinas wrote:
> 
> > Now, what's preventing a vendor firmware from providing only ACPI
> > tables? Do we enforce it in some way (arm-acpi.txt, kernel warning etc.)
> > that both DT and ACPI are supported, or at least that dts files are
> > merged in the kernel first?
> 
> I know of some (server) firmware that will only provide ACPI in the
> medium term, so this is coming.

Medium term is fine, as long as they are not expecting their hardware
to be supported by Linux before ACPI support is stable enough for
general consumption. I have no idea how long that will take, but my
guess is that we shouldn't plan on supporting ACPI-only platforms in
Linux for the next couple of years and just demand that all drivers
have DT support to let users add a valid DTB that can describe the
hardware.

That should always be possible using something like grub2 as an
intermediate that boots using the UEFI interfaces and loads the
kernel and DT from disk.

	Arnd
