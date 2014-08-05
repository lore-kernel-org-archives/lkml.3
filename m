Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbaHESV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:21:59 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:63163 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbaHESVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:21:55 -0400
Subject: Re: [PATCH 2/3] fpga bus driver
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <1406932118-13885-3-git-send-email-atull@opensource.altera.com>
Date: Tue, 5 Aug 2014 21:21:46 +0300
Cc: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>, <pavel@denx.de>,
        <broonie@kernel.org>, <philip@balister.org>, <rubini@gnudd.com>,
        <s.trumtrar@pengutronix.de>, <jason@lakedaemon.net>,
        <kyle.teske@ni.com>, <nico@linaro.org>, <balbi@ti.com>,
        <m.chehab@samsung.com>, <davidb@codeaurora.org>, <rob@landley.net>,
        <davem@davemloft.net>, <cesarb@cesarb.net>, <sameo@linux.intel.com>,
        <akpm@linux-foundation.org>, <linus.walleij@linaro.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Content-Transfer-Encoding: 7bit
Message-Id: <8FA28B3D-823F-48B1-83F6-0905F8004CE2@konsulko.com>
References: <1406932118-13885-1-git-send-email-atull@opensource.altera.com> <1406932118-13885-3-git-send-email-atull@opensource.altera.com>
To: <atull@opensource.altera.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Aug 2, 2014, at 1:28 AM, <atull@opensource.altera.com> wrote:

> From: Alan Tull <atull@opensource.altera.com>
> 
> This driver allows programming the fpga from
> device tree overlays.
> 
> This code is dependent on Pantelis Antoniou's current
> work on Device Tree overlays, a method of dynamically
> altering the kerel's live Device Tree.  This patchset
> was tested with Pantelis's and Grant Likely's stuff
> that is in git plus some dtc fixups for compiling
> overlays.
> 
> Resume is handled by re-requesting the firmware and
> reprogramming the FPGA.
> 
> Here's a simple example. Start with:
>  * the altera-gpio driver built in to the kernel but not in the
>    device tree.
>  * raw fpga image at /lib/firmware/soc_system.rbf
>  * Load appropriate device tree overlay in configfs by doing
>    $ mkdir /config/device-tree/overlays/1
>    $ echo socfpga_overlay.dtbo > /config/device-tree/overlays/1/path

FWIW, there's now an updated configfs interface. You can just 
# cp socfpga_overlay.dtbo /config/device-tree/overlays/1/dtbo

That's namespace safe, if you care about those things.

Regards

-- Pantelis

