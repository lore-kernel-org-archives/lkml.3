Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab3AOSo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:44:59 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53515 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab3AOSo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:44:58 -0500
Message-ID: <50F5A3A6.7000801@wwwdotorg.org>
Date: Tue, 15 Jan 2013 11:44:54 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Terje Bergstrom <tbergstrom@nvidia.com>
CC: amerilainen@nvidia.com, airlied@linux.ie, thierry.reding@avionic-design.de,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 7/8] ARM: tegra: Add board data and 2D clocks
References: <1358249182-17486-1-git-send-email-tbergstrom@nvidia.com> <1358249182-17486-8-git-send-email-tbergstrom@nvidia.com>
In-Reply-To: <1358249182-17486-8-git-send-email-tbergstrom@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 04:26 AM, Terje Bergstrom wrote:
> Add a driver alias gr2d for Tegra 2D device, and assign a duplicate
> of 2D clock to that driver alias.

FYI on this one patch - it won't be applied to the Tegra tree until
after Prashant's common clock framework changes are applied. As such, it
will need some rework once those patches are applied, or perhaps won't
even be relevant any more; see below.

> diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c

> +	OF_DEV_AUXDATA("nvidia,tegra20-gr2d", 0x54140000, "gr2d", NULL),

I assume the only reason to add AUXDATA is to give the device a specific
name, which will then match the driver name in the clock driver:

> -	CLK_DUPLICATE("2d",	"tegra_grhost",	"gr2d"),
> +	CLK_DUPLICATE("2d",	"gr2d",	"gr2d"),

If so, this shouldn't be needed once the common clock framework patches
are applied, since all device clocks will be retrieved from device tree,
and hence the device name will be irrelevant; the phandle in device tree
is all that will matter.
