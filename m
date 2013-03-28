Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3C1RAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:00:48 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:42339 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755610Ab3C1RAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:00:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/x7W9rv934aKYDKcsT+RIc3Dzo6Gqp+cc=
Date: Thu, 28 Mar 2013 13:00:39 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Soeren Moch <smoch@web.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Kirkwood: fix unused mvsdio gpio pins
Message-ID: <20130328170039.GW13280@titan.lakedaemon.net>
References: <1364043420-17641-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364043420-17641-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 01:56:58PM +0100, Sebastian Hesselbarth wrote:
> mvsdio_platform_data allows to pass card detect and write protect gpio
> numbers to the driver. Some kirkwood boards don't use both pins as they
> are not connected, and don't set the corresponding value in platform_data.
> 
> This will leave the unset values in platform_data initialized as 0, which
> is in fact a valid gpio pin. mvsdio will grab that pin and configure it as
> gpio, which in turn breaks nand controller as mpp0 also carries nand_io2.
> 
> This patch fixes the above by initializing unused gpio functions in the
> platform_data with an invalid (-1) value.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Reported-by: Soeren Moch <smoch@web.de>
> ---
> Cc: Soeren Moch <smoch@web.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-kirkwood/guruplug-setup.c  |    2 ++
>  arch/arm/mach-kirkwood/openrd-setup.c    |    1 +
>  arch/arm/mach-kirkwood/rd88f6281-setup.c |    1 +
>  3 files changed, 4 insertions(+)

Applied to mvebu/fixes

thx,

Jason.
