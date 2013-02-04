Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3BDWKC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 17:10:02 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60250 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab3BDWKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 17:10:00 -0500
Message-ID: <511031B5.4010900@wwwdotorg.org>
Date: Mon, 04 Feb 2013 15:09:57 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: tegra: move to of_clk_get
References: <1359985230-11506-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1359985230-11506-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 06:40 AM, Peter De Schrijver wrote:
> The new clockframework introduced DT IDs for each clock. To be able to remove
> the device registrations, this driver needs to be updated to use the DT IDs.
> Note that the actual removal of the clk_register_clkdev() calls will be done
> in a later series.

This seems fine for 3.10, but I wonder about dependencies. Will there be
a bunch of other similar changes? I guess this patch is a dependency of
some changes to drivers/clk/tegra/ to remove the non-DT clock
registrations? It'd be good to get a clear idea of all the dependencies,
so we can see what's the best tree to apply the changes to; perhaps this
should go through the drivers/clk tree, or Tegra's clk driver changes
need to go through the Tegra tree again in 3.10?
