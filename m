Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab3JHRDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:03:31 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:45478 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753013Ab3JHRD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:03:29 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/V/51ohe5t1VrfxsAmjBI+/c6GTWYl0SQ=
Date: Tue, 8 Oct 2013 13:03:08 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] ARM: kirkwood: retain MAC address for DT ethernet
Message-ID: <20131008170308.GP5402@titan.lakedaemon.net>
References: <1380881842-24605-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1381177511-1100-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381177511-1100-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 10:25:11PM +0200, Sebastian Hesselbarth wrote:
> Ethernet IP on Kirkwood SoCs loose their MAC address register content
> if clock gated. To allow modular ethernet driver setups and gated clocks
> also on non-DT capable bootloaders, we fixup port device nodes with no
> valid MAC address property. This patch copies MAC address register
> contents set up by bootloaders early, notably before ethernet clocks
> are gated. While at it, also reorder call sequence in _dt_init.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Tested-by: Andrew Lunn <andrew@lunn.ch>
> ---
> Just to make sure they don't get lost this time:
> Added Jason's and Ezequiel's Reviewed-by to honor their constant reviews,
> and Andrew's last Tested-by because I know he will be testing again.
> 
> Changelog:
> v3->v4:
> - drop clk_is_enabled (and dependency) due to possible abuse of the
>   new function; enable/disable clk instead, remove gated clock warning
>   (Suggested by Andrew Lunn, Uwe Kleine-Koenig, Mike Turquette)
> - reduce FW_BUG to FW_INFO (Suggested by Andrew Lunn)
> - proper cleanup of iomap, clk, nodes
> v2->v3:
> - make use of new public clk_is_enabled (adds dependency)
> - add warning about gated clock && missing MAC property
>   (Suggested by Jason Gunthorpe)
> v1->v2:
> - check for gated clock before accessing eth registers
>   (Suggested by Andrew Lunn)
> 
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-kirkwood/board-dt.c |   86 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 83 insertions(+), 3 deletions(-)

Applied to mvebu/soc with Mike's Reviewed-by:

thx,

Jason.
