Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab3JXQh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 12:37:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59809 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab3JXQhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 12:37:54 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 08/10] of/platform: Resolve interrupt references at probe time
To: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20131015232436.19F61C40099@trevor.secretlab.ca>
References: <1379510692-32435-1-git-send-email-treding@nvidia.com> <1379510692-32435-9-git-send-email-treding@nvidia.com> <20131015232436.19F61C40099@trevor.secretlab.ca>
Date: Thu, 24 Oct 2013 17:37:49 +0100
Message-Id: <20131024163749.68D01C403B6@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013 00:24:36 +0100, Grant Likely <grant.likely@linaro.org> wrote:
> On Wed, 18 Sep 2013 15:24:50 +0200, Thierry Reding <thierry.reding@gmail.com> wrote:
> > Interrupt references are currently resolved very early (when a device is
> > created). This has the disadvantage that it will fail in cases where the
> > interrupt parent hasn't been probed and no IRQ domain for it has been
> > registered yet. To work around that various drivers use explicit
> > initcall ordering to force interrupt parents to be probed before devices
> > that need them are created. That's error prone and doesn't always work.
> > If a platform device uses an interrupt line connected to a different
> > platform device (such as a GPIO controller), both will be created in the
> > same batch, and the GPIO controller won't have been probed by its driver
> > when the depending platform device is created. Interrupt resolution will
> > fail in that case.
> 
> What is the reason for all the rework on the irq parsing return values?
> A return value of '0' is always an error on irq parsing, regardless of
> architecture even if NO_IRQ is defined as -1. I may have missed it, but
> I don't see any checking for specific error values in the return paths
> of the functions.
> 
> If the specific return value isn't required (and I don't think it is),
> then you can simplify the whole series by getting rid of the rework
> patches.

I've not heard back about the above, but I've just had a conversation
with Rob about what to do here. The problem that I have is that it makes
a specific return code need to traverse several levels of function calls
and have a meaning come out the other end. It becomes difficult to
figure out where that code actually comes from when reading the code.
That's more of a gut-feel reaction rather than pointing out specifics
though.

The other thing that makes me nervous how invasive the series is.

However, even with saying all of the above, I'm not saying outright no.
I want to get this feature in. It is obviously needed and I'll even
merge the patches piecemeal as the look ready (I've already merged 2).
Regardless, the current series needs to be reworked. It conflicts with
the other IRQ rework that I've already put into my tree. The best thing
to do would probably be respin it against my current tree and repost.
I'll take a fresh look then.... In the mean time, anything you can do to
/sanely/ reduce the impact will probably help.  :-)

g.
