Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935146Ab3BNXpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:45:11 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44381 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935091Ab3BNXpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:45:09 -0500
Message-ID: <511D7701.8040809@wwwdotorg.org>
Date: Thu, 14 Feb 2013 16:45:05 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Dinh Nguyen <dinguyen@altera.com>, Pavel Machek <pavel@denx.de>,
        Stephen Warren <swarren@nvidia.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: Re: [PATCH 8/9] [HACK] ARM: imx: work around v7_cpu_resume link error
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de> <1360882071-4072668-9-git-send-email-arnd@arndb.de>
In-Reply-To: <1360882071-4072668-9-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 03:47 PM, Arnd Bergmann wrote:
> Patch c08e20d24 "arm: Add v7_invalidate_l1 to cache-v7.S"
> moves the v7_invalidate_l1 symbol out of imx/headsmp.S,
> which seems to cause a link error because it is now
> too far away from v7_cpu_resume when building an
> allyesconfig kernel.

Is the problem from the following in arch/arm/mach-imx/headsmp.S:

ENTRY(v7_cpu_resume)
        bl      v7_invalidate_l1

Isn't the range of bl +/- 32MiB (or +/- 16MibB in Thumb 2). Is the
kernel really that big? Sorry, I'm having trouble understanding what
causes the problem.
