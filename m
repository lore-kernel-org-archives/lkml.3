Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaBCXHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:07:51 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:50615 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaBCXHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:07:49 -0500
MIME-Version: 1.0
In-Reply-To: <3808209.DeG1VobanZ@wuerfel>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com>
	<21596846.kVTqp7roW4@wuerfel>
	<20140203191837.GC4889@e106497-lin.cambridge.arm.com>
	<3808209.DeG1VobanZ@wuerfel>
Date: Mon, 3 Feb 2014 17:07:48 -0600
Message-ID: <CAL_JsqL+3S8w=_Fb-t0rVcq0sDiPSDM6nqn3mR2DHKw=VTffsg@mail.gmail.com>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 2:05 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 03 February 2014 19:18:38 Liviu Dudau wrote:
>> On Mon, Feb 03, 2014 at 06:58:56PM +0000, Arnd Bergmann wrote:
>> > On Monday 03 February 2014 18:43:48 Liviu Dudau wrote:

[snip]

>> Agree. This is the RFC version. I didn't dare to post a patch with fixes
>> for all architectures. :)
>
> No need to change the other architectures. You can make it opt-in for
> now and just put the code into a common location.
>
> An interesting question however is what the transition plan is to
> have the code shared between arm32 and arm64: We will certainly need
> to share at least the dw-pcie and the generic SBSA compliant pci
> implementation.

You might want to re-read the SBSA. Unless ARM provides an IP block or
there is some other standard such as EHCI or AHCI, there is no generic
implementation. You only have to go look at the Linux EHCI or AHCI
drivers and see how meaningless and inadequate "use EHCI" is. For PCI,
the text is so brief in the SBSA there will be no way PCI is going to
just work given all the variations of root complexes, bridges, address
windows, etc. we typically see on ARM platforms. I could be wrong and
some AML magic will solve all the problems. :)

Rob
