Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbaJVXJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 19:09:42 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:54121 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666AbaJVXJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 19:09:39 -0400
Date: Wed, 22 Oct 2014 17:09:36 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Vidya Sagar <vidyas@nvidia.com>
Cc: thierry.reding@gmail.com, swarren@wwwdotorg.org, kthota@nvidia.com,
        linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] PCI: tegra: add PM-ops support
Message-ID: <20141022230936.GB4795@google.com>
References: <1413193803-21718-1-git-send-email-vidyas@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413193803-21718-1-git-send-email-vidyas@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 03:20:03PM +0530, Vidya Sagar wrote:
> adds support for suspend_noirq and resume_noirq hooks
> of PM framework. Enables powergating of PCIe partition during
> suspend.
> It also separates allocation part from
> tegra_pcie_enable_msi() to make a new API tegra_pcie_alloc_msi()
> to avoid passing extra param in the original API

This sounds like it should be two separate patches (a changelog that says
"It also ..." is a good clue).

Maybe even three patches -- the additions in tegra_pcie_power_off() look
like they are separable from the dev_pm_ops addition, because
tegra_pcie_power_off() is already present and used even before you add
dev_pm_ops.

Generally, my advice is that if you *can* separate it, you should do so.
It's very easy to squash things back together, and separating things makes
errors more obvious and bisection more useful.

> -static int tegra_pcie_enable(struct tegra_pcie *pcie)
> +static int tegra_pcie_check_ports(struct tegra_pcie *pcie)

"check_ports" is a not really a very good function name because it doesn't
give any clues about what we're checking or what return value to expect.

Bjorn
