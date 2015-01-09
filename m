Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbbAIK5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:57:03 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:58871 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434AbbAIK47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:56:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Rob Herring <robh@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lv Zheng <lv.zheng@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
Date: Fri, 09 Jan 2015 11:55:51 +0100
Message-ID: <3341506.a2BFqPNg3k@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150109103307.GC24408@e104818-lin.cambridge.arm.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <1610983.9vqJdsL27R@wuerfel> <20150109103307.GC24408@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:ZINQG/hLZJqTq134mM/ZYMmGmX+v4Gg3RTwEGc4X85nlYd6kSpD
 y1tvSES+B7WSFoLxuf5js44fcWKPWUSfQhVfFuZ/crkr+HI5KkiwBuj4cpehB2u8zqDhdoB
 DzQ1/aGkNVgNCEQ+X1tsnj8No06UrctXIbl/4S/b01gjhCQdvHvzoyViqs3ifRvtMA4Rry6
 0uJCZUs+CXtpHc5r5EnHQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 January 2015 10:33:07 Catalin Marinas wrote:
> On Wed, Jan 07, 2015 at 07:48:48PM +0000, Arnd Bergmann wrote:

> > In other cases that's actually a good thing. One such example is the
> > "Principles of ARM Memory Maps" document that tells hardware implementers
> > to do a rather complex mapping "To support 36-bit x86 PAE compatible operating
> > systems, such as Linux." but makes life much harder in the process than
> > any of the random mappings we have seen in the wild.
> 
> Unfortunately, with any significant amount of RAM (say 16GB), this
> document becomes pretty useless. It basically forces you to have a very
> sparse physical address map from 0 to over 40-bit. I wouldn't apply the
> ARM memory maps doc to server systems.

Are you sure? I was under the impression that this document was targetted
specifically at servers.

> >   It's also not just the CPU core, other components also get easily
> >   replaced, like a GICv3 that is not a strict superset of GICv2.
> 
> That's not a problem for Linux, we can describe them in DT or ACPI and
> have drivers. GICv3 has an optional GICv2 compatible mode, though
> vendors may decide not to implement it.

I'm aware that we can deal with it after we have the drivers. My point
was that we are unable to deal with this problem in general if we want
to run existing kernels on new hardware that contains e.g. a GICv4/5/6
that requires a new driver which has to first be written and then
backported into distro kernels.

	Arnd
