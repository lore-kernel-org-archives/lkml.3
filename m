Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557AbaELRFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:05:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51532 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaELRFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:05:15 -0400
Message-ID: <5370FDB2.40704@wwwdotorg.org>
Date: Mon, 12 May 2014 10:58:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
CC: linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        kgene.kim@samsung.com, thierry.reding@gmail.com, shc_work@mail.ru
Subject: Re: [PATCH v2 5/6] usb: host: ehci-tegra: Use devm_ioremap_resource
 instead of devm_ioremap
References: <1399723210-21569-1-git-send-email-gautam.vivek@samsung.com> <1399723210-21569-6-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1399723210-21569-6-git-send-email-gautam.vivek@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2014 06:00 AM, Vivek Gautam wrote:
> Using devm_ioremap_resource() API should actually be preferred over
> devm_ioremap(), since the former request the mem region first and then
> gives back the ioremap'ed memory pointer.
> devm_ioremap_resource() calls request_mem_region(), therby preventing
> other drivers to make any overlapping call to the same region.

This patch on its own works OK on Tegra. However, if a similar patch
were to be applied to the Tegra PHY driver, then I expect that would
break USB on Tegra. The reason is that the Tegra USB controller and PHY
registers are interleaved a bit randomly within the same address range,
and rather than call out which individual addresses are relevant to the
controller and the PHY, the DT for both devices just specifies the same
whole range, and the drivers only touch the appropriate registers within
the range. Perhaps we should have described that as an MFD rather than
separate DT nodes and devices, but that's not what we ended up with.
