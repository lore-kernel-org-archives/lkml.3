Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab3FDTIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 15:08:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54996 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3FDTIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 15:08:13 -0400
Message-ID: <51AE3B18.9010604@wwwdotorg.org>
Date: Tue, 04 Jun 2013 13:08:08 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jay Agarwal <jagarwal@nvidia.com>
CC: linux@arm.linux.org.uk, thierry.reding@avionic-design.de,
        bhelgaas@google.com, ldewangan@nvidia.com, olof@lixom.net,
        hdoyu@nvidia.com, pgaikwad@nvidia.com, mturquette@linaro.org,
        pdeschrijver@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, jtukkinen@nvidia.com, kthota@nvidia.com
Subject: Re: [PATCH V3 1/4] ARM: tegra30: clocks: Fix pciex clock registration
References: <1370372252-4332-1-git-send-email-jagarwal@nvidia.com>
In-Reply-To: <1370372252-4332-1-git-send-email-jagarwal@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 12:57 PM, Jay Agarwal wrote:
> Registering pciex as peripheral clock instead of fixed clock
> as tegra_perih_reset_assert(deassert) api of this clock api
> gives warning and ultimately does not succeed to assert(deassert).
> 
> Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
> ---
> Patch is based on remotes/gitorious_thierryreding_linux/tegra/next and should be applied on top of this.

For this change, Mike may as well apply it directly to the clock tree.
Thierry can then pick it up when he rebases his tegra/next tree.

That said, I don't think you should need any of the
TEGRA_CLK_DUPLICATE() entries; the PCIe driver should get its clocks
from device tree now, and hence the driver name in the clock
registration shouldn't be necessary. All of these TEGRA_CLK_DUPLICATE()
entries should be removed en mass sometime soon with luck. So, can you
simply leave the two TEGRA_CLK_DUPLICATE() entries untouched, rather
than changing them?
