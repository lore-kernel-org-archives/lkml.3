Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbaGILtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:49:18 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7377 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbaGILtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:49:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 09 Jul 2014 04:42:16 -0700
Date: Wed, 9 Jul 2014 14:49:07 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Stephen Warren <swarren@nvidia.com>, "Arnd Bergmann" <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: a case for a common efuse API?
Message-ID: <20140709114907.GI23218@tbergstrom-lnx.Nvidia.com>
References: <53BC4DD7.20906@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53BC4DD7.20906@codeaurora.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 10:00:23PM +0200, Stephen Boyd wrote:
> 
> I added Tegra folks because I see that on Tegra this hardware is exposed
> via an SoC specific API, tegra_fuse_readl(), and an associated driver in
> drivers/misc/fuse/tegra/. Unfortunately I don't see any users of the API
> outside of the speedo code in the same directory and the sysfs bin
> attribute that may or may not be in use by some userspace code.
> 

The SATA driver by Mikko Perttunen uses it. The driver hasn't been merged
though. There's some more upcoming work which makes use of it.
I don't think we can standardize much of an API for this. The data is
SoC specific, so the user will always need to have some SoC specific
knowledge on how to use it. In some cases we need it very early (eg. to
determine the correct Tegra20 revision). On Tegra20 we can't use the CPU
to read the fuses due to a hw bug, we have to use DMA, which means the
transaction becomes blocking and could fail due to lack of resources.

Cheers,

Peter.
