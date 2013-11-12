Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab3KLUEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:04:33 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50554 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab3KLUEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:04:24 -0500
Message-ID: <528289C0.3040202@wwwdotorg.org>
Date: Tue, 12 Nov 2013 13:04:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH] ARM: tegra: init fuse before setting reset handler
References: <1384238186-8473-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1384238186-8473-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 11:36 PM, Alexandre Courbot wrote:
> CPU reset handler was set before fuse is initialized, but
> tegra_cpu_reset_handler_enable() uses tegra_chip_id, which is set by
> tegra_init_fuse(). This patch reorders the calls so the CPU reset
> handler code does not read an uninitialized variable.

Thanks. I forwarded this to the arm-soc maintainers as a patch for 3.13.
