Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab3BDBeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 20:34:17 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:34003 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753659Ab3BDBeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 20:34:14 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ELK+JUl6r3MJfYsq7f48Fml13LglOqO8=
Date: Sun, 3 Feb 2013 20:34:08 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Simon Baatz <gmbnomis@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/2] ARM: kirkwood: fix to retain gbe MAC addresses
 for DT kernels
Message-ID: <20130204013408.GH14746@titan.lakedaemon.net>
References: <20130130183049.GR7717@titan.lakedaemon.net>
 <1359577799-23351-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359577799-23351-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> ---
> Changelog:
> [v2]
> - add note in patch description that MAC address is lost only when using
>   modular driver
> - add note in patch description that the workaround will be removed soon
> 
> Cc: Simon Baatz <gmbnomis@gmail.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-kirkwood/board-dt.c |   24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)

Applied to mvebu/fixes with Simon's Tested-by:

thx,

Jason.
