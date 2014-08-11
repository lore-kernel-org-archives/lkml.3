Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaHKJQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 05:16:00 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:32009 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751464AbaHKJP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 05:15:59 -0400
Message-ID: <1407748550.3680.10.camel@hornet>
Subject: Re: [PATCH 3/5] mmc: sdhci-pltfm: Do not use parent as the host's
 device
From: Pawel Moll <pawel.moll@arm.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>, Anton Vorontsov <anton@enomsg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "paul@pwsan.com" <paul@pwsan.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Date: Mon, 11 Aug 2014 10:15:50 +0100
In-Reply-To: <CAPDyKFoLU6pnJFmKe7CB0q-hKfwv4uCPSr0cE4aoYMvfhjMteQ@mail.gmail.com>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
	 <1406298233-27876-3-git-send-email-pawel.moll@arm.com>
	 <1407515785.31897.28.camel@hornet>
	 <CAPDyKFoLU6pnJFmKe7CB0q-hKfwv4uCPSr0cE4aoYMvfhjMteQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-11 at 10:07 +0100, Ulf Hansson wrote:
> On 8 August 2014 18:36, Pawel Moll <pawel.moll@arm.com> wrote:
> > On Fri, 2014-07-25 at 15:23 +0100, Pawel Moll wrote:
> >> The code selecting a device for the sdhci host has been
> >> continuously tweaked (4b711cb13843f5082e82970dd1e8031383134a65
> >> "mmc: sdhci-pltfm: Add structure for host-specific data" and
> >> a4d2177f00a5252d825236c5124bc1e9918bdb41 "mmc: sdhci-pltfm: dt
> >> device does not pass parent to sdhci_alloc_host") while there
> >> does not seem to be any reason to use platform device's parent
> >> in the first place.
> >>
> >> The comment saying "Some PCI-based MFD need the parent here"
> >> seem to refer to Timberdale FPGA driver (the only MFD driver
> >> registering SDHCI cell, drivers/mfd/timberdale.c) but again,
> >> the only situation when parent device matter is runtime PM,
> >> which is not implemented for Timberdale.
> >>
> >> Cc: Chris Ball <chris@printf.net>
> >> Cc: Anton Vorontsov <anton@enomsg.org>
> >> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> >> Cc: linux-mmc@vger.kernel.org
> >> Cc: linuxppc-dev@lists.ozlabs.org
> >> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> >> ---
> >>
> >> This patch is a part of effort to remove references to platform_bus
> >> and make it static.
> >>
> >> Chris, Anton, Ulf - could you please advise if the assumptions
> >> above are correct or if I'm completely wrong? Do you know what
> >> where the real reasons to use parent originally? The PCI comment
> >> seems like a red herring to me...
> >
> > Can I take the silence as a suggestion that the change looks ok-ish for
> > you?
> 
> Sorry for the delay. I suppose this make sense, but I really don't
> know for sure.
> 
> I guess we need some testing in linux-next, to get some confidence.

Would you take it into -next then? Unless I'm completely wrong there
should be no impact on any in-tree driver...

Cheers!

Pawel

