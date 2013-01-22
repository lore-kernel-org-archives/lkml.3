Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab3AVSgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:36:06 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50625 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab3AVSf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:35:58 -0500
Message-ID: <50FEDC0B.7050604@wwwdotorg.org>
Date: Tue, 22 Jan 2013 11:35:55 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>, Will Deacon <will.deacon@arm.com>
CC: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net,
        santosh.shilimkar@ti.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [v3 2/2] ARM: tegra: Skip scu_enable(scu_base) if not Cortex
 A9
References: <1358833924-24535-1-git-send-email-hdoyu@nvidia.com> <1358833924-24535-2-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1358833924-24535-2-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 10:52 PM, Hiroshi Doyu wrote:
> Skip scu_enable(scu_base) if CPU is not Cortex A9 with SCU.

Will, is your for-next/perf branch stable; can I pull it into a branch
destined for arm-soc? Background below:

Uggh.

This patch (2/2) depends on "ARM: tegra: Use DT /cpu node to detect
number of CPU core" from your Tegra114 series, since that patch removes
the other use of scu_base, thus allowing this patch to remove that variable.

Then, that patch depends on "ARM: Define CPU part numbers and
implementors" from Will Deacon's ARM perf tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git for-next/perf

That means that in order to put this series into arm-soc, we would have
to pull in Will's perf branch first, then the following Tegra patches,
the latter two of which are already in Tegra's for-next, so I'd have to
pull them out:

0bb7bd9 ARM: tegra: Use DT /cpu node to detect number of CPU core
a8f5f25 ARM: tegra: Add CPU nodes to Tegra30 device tree
9975516 ARM: tegra: Add CPU nodes to Tegra20 device tree

Hiroshi, it would be extremely useful if you could explicitly specify
the dependencies of your series when posting them; it took me a long
time and a lot of searching to track all the dependencies down. :-(
