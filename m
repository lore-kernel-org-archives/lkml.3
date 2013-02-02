Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab3BBXt0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 18:49:26 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54224 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3BBXtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 18:49:25 -0500
Date: Sun, 3 Feb 2013 00:49:20 +0100
From: Simon Baatz <gmbnomis@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ARM: kirkwood: fix to retain gbe MAC addresses
 for DT kernels
Message-ID: <20130202234919.GB17361@schnuecks.de>
References: <20130130183049.GR7717@titan.lakedaemon.net>
 <1359577799-23351-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359577799-23351-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian, Jason,

On Wed, Jan 30, 2013 at 09:29:58PM +0100, Sebastian Hesselbarth wrote:
> The ethernet controller used on kirkwood looses its MAC address
> register contents when the corresponding clock is gated. As soon as
> mv643xx_eth is built as module, the clock gets gated and when loading
> the module, the MAC address is gone.
> 
> Proper DT support for the mv643xx_eth driver is expected soon, so we add
> a workaround to always enable ge0/ge1 clocks on kirkwood. This workaround
> is also already used on non-DT kirkwood kernels.
> 
> Reported-by: Simon Baatz <gmbnomis@gmail.com>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Tested this on IB-NAS6210 (kirkwood, single GBE interface). Using
mv643xx_eth as a module works again now and yields

# cat /sys/kernel/debug/clk/tclk/ge[01]/clk_enable_count 
2
1

as expected.

- Simon
