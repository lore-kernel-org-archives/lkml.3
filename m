Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab3KQEC4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 23:02:56 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:42930 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3KQECo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 23:02:44 -0500
MIME-Version: 1.0
In-Reply-To: <20131116134445.GI11014@S2101-09.ap.freescale.net>
References: <1384568535-26611-1-git-send-email-nm@ti.com>
	<20131116134445.GI11014@S2101-09.ap.freescale.net>
Date: Sun, 17 Nov 2013 09:32:42 +0530
Message-ID: <CAKohponU-WFnG8Gx6ba=k3eJmWV_0eWtpsy9kDP8yA2KrdoKtg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: Use a sane boot frequency when
 booting with a mismatched bootloader configuration
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Nishanth Menon <nm@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Carlos Hernandez <ceh@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 November 2013 19:14, Shawn Guo <shawn.guo@linaro.org> wrote:
> No, it's not a kernel bug.
>
> OPP is not a definition that belongs to kernel.  Instead, it's
> characteristics of hardware, and that's why we can naturally put the
> definition into device tree.  Bear it in mind that device tree is a
> hardware description and should be OS agnostic.  So it shouldn't be
> treated as part of Linux kernel in any case, even though the device
> tree source is currently maintained in kernel tree.
>
> Device tree is designed as a way for firmware/bootloader to describe
> hardware to kernel.  That said, device tree is more part of bootloader
> than kernel.  If bootloader runs at a frequency that does not match the
> OPP in device tree, the one should be fixed is either bootloader or
> device tree but never kernel.

I agree for all that..

> However, I agree we should at least have a check in cpufreq-cpu0 driver
> and fail out in case that a mismatch is detected.

But not here.. We aren't in a non-workable state here.. and so creating
panic isn't the right approach.

At max we can print an warning but then it doesn't lie in cpufreq-cpu0's
domain. It should be done in core if required..

Though for Shawn's information we have another thread in parallel for
this issue. You might like to check that too..

https://lkml.org/lkml/2013/11/15/503
