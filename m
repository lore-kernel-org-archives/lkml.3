Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaJORgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 13:36:49 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:62688 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaJORgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 13:36:48 -0400
MIME-Version: 1.0
In-Reply-To: <20141015170624.4063.24678.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
	<20141015170624.4063.24678.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Date: Wed, 15 Oct 2014 10:36:47 -0700
Message-ID: <CALAqxLX4Sf8fbDWVfGoQApdzR64k7ZM2o66=pCk9Sf=GceVo5Q@mail.gmail.com>
Subject: Re: [PATCH v1 06/10] clocksource: Remove "weak" from
 clocksource_default_clock() declaration
From: John Stultz <john.stultz@linaro.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        Eric Paris <eparis@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 10:06 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> kernel/time/jiffies.c provides a default clocksource_default_clock()
> definition explicitly marked "weak".  arch/s390 provides its own definition
> intended to override the default, but the "weak" attribute on the
> declaration applied to the s390 definition as well, so the linker chose one
> based on link order (see 10629d711ed7 ("PCI: Remove __weak annotation from
> pcibios_get_phb_of_node decl")).
>
> Remove the "weak" attribute from the clocksource_default_clock()
> declaration so we always prefer a non-weak definition over the weak one,
> independent of link order.
>
> Fixes: f1b82746c1e9 ("clocksource: Cleanup clocksource selection")
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: Daniel Lezcano <daniel.lezcano@linaro.org>
> CC: Martin Schwidefsky <schwidefsky@de.ibm.com>

Acked-by: John Stultz <john.stultz@linaro.org>
