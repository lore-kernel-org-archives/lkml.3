Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbaGVRWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 13:22:30 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:56525 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbaGVRW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 13:22:29 -0400
MIME-Version: 1.0
In-Reply-To: <53CE9514.1050903@wwwdotorg.org>
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
	<1405088313-20048-6-git-send-email-mperttunen@nvidia.com>
	<CAL1qeaGHfjQhLHvgzt85hmbuY4FOG5-k=f80=CNvzPDEgi9_6w@mail.gmail.com>
	<53CD860B.7030800@wwwdotorg.org>
	<CAL1qeaHtGQxCO3cGdeCRUYuk6mxei6z1B63-iZdBECEbFqGhHw@mail.gmail.com>
	<53CE9514.1050903@wwwdotorg.org>
Date: Tue, 22 Jul 2014 10:22:27 -0700
X-Google-Sender-Auth: tVuoUy1GYl7tDH8s12uiM9JgpEc
Message-ID: <CAL1qeaEkL+mxb0S4JhQbXBjyNyKJndffTSjMaAFQD6ooDJPd+Q@mail.gmail.com>
Subject: Re: [PATCH 5/8] of: Add Tegra124 EMC bindings
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mikko Perttunen <mperttunen@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 9:45 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>
> Does the bootloader adjust the DT that's passed to the kernel so that
> only the relevant single set of EMC timings is contained in the DT?

No, the DT contains all possible EMC timings for that board.

> On a system where the boot ROM initializes RAM, and where the HW design
> might have multiple SDRAM configuration, here's what usually happens:
>
> a) The BCT contains N sets of SDRAM configurations.
>
> b) The boot ROM reads the SDRAM strapping bits, and uses them to pick
> the correct SDRAM configuration from the N sets in the BCT.
>
> c) The kernel DT has N sets of SDRAM configurations.
>
> d) The kernel reads the SDRAM strapping bits, and uses them to pick the
> correct SDRAM configuration from the N sets in the DT.
>
> On the ChromeOS boards (so (a) and (b) above are irrelevant) where N is
> too large to fit into APBDEV_PMC_STRAPPING_OPT_A_0[7:4], (c) and (d)
> won't work. I assume the kernel DT therefore must be adjusted to only
> contain the single SDRAM configuration that is relevant for the current HW?
>
> (isn't STRAPPING_OPT_A split into 2 2-bit fields; 2 bits for SDRAM index
> and 2 bits for boot flash index, so max N is quite small?)

Right, there are normally only 2 SDRAM strapping bits available.
ChromeOS gets around this by having 4 identical boot device entries in
the BCT, so all possible values of STRAPPING_OPT_A[7:6] map to the
same boot device.  This allows us to use all 4 strapping bits in
coreboot to pick the SDRAM configuration.
