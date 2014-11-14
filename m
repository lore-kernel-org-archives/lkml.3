Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbaKNJa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 04:30:59 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:50622 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaKNJa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 04:30:56 -0500
MIME-Version: 1.0
In-Reply-To: <20141103184247.GD1618@lahna.fi.intel.com>
References: <20141028144249.GD8123@saruman>
	<CACRpkdaN5hNWFUOFbHLm8HgZEKVSETUgVF4Cn4UbMQxNEg46Vw@mail.gmail.com>
	<20141031132005.GB1273@saruman>
	<20141031162339.GA7136@psi-dev26.jf.intel.com>
	<20141031184509.GA2224@psi-dev26.jf.intel.com>
	<20141103092402.GA1304@lahna.fi.intel.com>
	<20141103150048.GB27425@saruman>
	<20141103152743.GB1618@lahna.fi.intel.com>
	<20141103154207.GC1618@lahna.fi.intel.com>
	<20141103155011.GH27425@saruman>
	<20141103184247.GD1618@lahna.fi.intel.com>
Date: Fri, 14 Nov 2014 10:30:55 +0100
Message-ID: <CACRpkda8eRp5tzvUppVvAfh0djR6q=3kYuec-nvJvnd+aCHC=A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, David Cohen <david.a.cohen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 7:42 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Mon, Nov 03, 2014 at 09:50:11AM -0600, Felipe Balbi wrote:

>> that's an issue that needs solving, but forcing every x86 kernel to ship
>> with this driver, is not a proper solution.
>
> I would rather have the driver build in to the kernel now (and btw it
> has been already in mainline quite some time so I suspect many distros
> have already enabled it), than turning it module and render some devices
> that have been working previously, fail suddenly.

We have an analogous problem with large device tree kernels for ARM
(supporting a multitude of ARM subarchitectures): a lot of statically
compiled-in drivers that just idle around after boot.

What would be nice was for the kernel to have a way of marking some
platform drivers such that if it has not been probed by init_late(),
the entire driver would be discarded, like a module that gets unloaded.

When I posed this idea in some forum it was considered "pretty hard
to achieve" (plus I guess it runs into the dilemma that we can never
discard strings) but I still think it'd be the right thing to do. It'd be very
straight-forward for driver authors to annotate their on-chip platform
drivers with some MODULE_LATE_DISCARD() or whatever.

Yours,
Linus Walleij
