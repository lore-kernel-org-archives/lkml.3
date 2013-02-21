Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab3BUVZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:25:57 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:62388 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3BUVZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:25:55 -0500
MIME-Version: 1.0
In-Reply-To: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com>
Date: Thu, 21 Feb 2013 15:25:53 -0600
Message-ID: <CANk1AXQ7ajnwTaHwwbyrri2YkX_60uC9xrQYWuR8u4eT2EQsew@mail.gmail.com>
Subject: Re: [PATCH 0/6] Introducing Device Tree Overlays
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: linux-doc@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Russ Dill <Russ.Dill@ti.com>, Matt Porter <mporter@ti.com>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>, linux-omap@vger.kernel.org,
        Matt Ranostay <mranostay@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Joel A Fernandes <agnel.joel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like where this is heading.  I'm interested in a use case where IP
can be loaded into a FPGA, then add a blob to the device tree and load
some drivers.

I see your github tree.  If I wanted to cherry-pick your code and play
around with it, which branch should I use?  not-capebus-21?

Thanks,
Alan Tull
Altera Corp

On Fri, Jan 4, 2013 at 1:31 PM, Pantelis Antoniou
<panto@antoniou-consulting.com> wrote:
> The following patchset introduces Device Tree overlays, a method
> of dynamically altering the kernel's live Device Tree.
>
> This patchset is against mainline as of Friday Jan 4 2013.
> (4956964 Merge tag 'driver-core-3.8-rc2' of \
>         git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core)
>
> Note that a separate patch for the DTC compiler has been posted and
> is required to compile the DTS files according to the documentation.
> The patch is "dtc: Dynamic symbols & fixup support"
>
> An implementation patchset for a beaglebone cape loader will follow,
> but if you want to check out a working kernel for the beaglebone please
> pull from:
>
> git://github.com/pantoniou/linux-bbxm.git branch not-capebus-v8
>
> Pantelis Antoniou (6):
>   OF: Introduce device tree node flag helpers.
>   OF: export of_property_notify
>   OF: Export all DT proc update functions
>   OF: Introduce utility helper functions
>   OF: Introduce Device Tree resolve support.
>   OF: Introduce DT overlay support.
>
>  .../devicetree/dynamic-resolution-notes.txt        |  25 +
>  Documentation/devicetree/overlay-notes.txt         | 179 +++++
>  drivers/of/Kconfig                                 |  19 +
>  drivers/of/Makefile                                |   4 +-
>  drivers/of/base.c                                  | 114 +--
>  drivers/of/overlay.c                               | 831 +++++++++++++++++++++
>  drivers/of/resolver.c                              | 394 ++++++++++
>  drivers/of/util.c                                  | 253 +++++++
>  include/linux/of.h                                 | 243 ++++++
>  9 files changed, 2005 insertions(+), 57 deletions(-)
>  create mode 100644 Documentation/devicetree/dynamic-resolution-notes.txt
>  create mode 100644 Documentation/devicetree/overlay-notes.txt
>  create mode 100644 drivers/of/overlay.c
>  create mode 100644 drivers/of/resolver.c
>  create mode 100644 drivers/of/util.c
>
> --
> 1.7.12
>
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
