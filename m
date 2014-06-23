Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbaFWTBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:01:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44465 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaFWTBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:01:16 -0400
Message-ID: <53A87979.6000104@wwwdotorg.org>
Date: Mon, 23 Jun 2014 13:01:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH 2/2] ARM: tegra: roth: enable input on mmc clock pins
References: <1403508779-25896-1-git-send-email-acourbot@nvidia.com> <1403508779-25896-3-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1403508779-25896-3-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 01:32 AM, Alexandre Courbot wrote:
> Input had been disabled by mistake on these pins, leading to issues with
> SDIO devices like the Wifi module not being probed or random errors
> occuring on the SD card.

I thought the host controller always drove the clock, so there should be
no need for the pin's input path to be enabled. Perhaps it depends on
the transfer mode (e.g. UHS)?

If this fix is valid, perhaps Jetson TK1's sdmmc3_clk and Venice2's
sdmmc1_clk need the same fix, although we'll need to file bugs against
their pinmux spreadsheets first if that's the case.
