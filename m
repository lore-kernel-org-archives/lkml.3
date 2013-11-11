Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3KKHrC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 02:47:02 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60383 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3KKHqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 02:46:55 -0500
Date: Mon, 11 Nov 2013 08:46:33 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org,
        =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v2] ARM: Use udiv/sdiv for __aeabi_{u}idiv library
 functions
Message-ID: <20131111074633.GG14892@pengutronix.de>
References: <1383951632-6090-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383951632-6090-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Nov 08, 2013 at 03:00:32PM -0800, Stephen Boyd wrote:
> diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
> index bd454b0..38621729 100644
> --- a/arch/arm/lib/Makefile
> +++ b/arch/arm/lib/Makefile
> @@ -15,6 +15,12 @@ lib-y		:= backtrace.o changebit.o csumipv6.o csumpartial.o   \
>  		   io-readsb.o io-writesb.o io-readsl.o io-writesl.o  \
>  		   call_with_stack.o
>  
> +lib-$(CONFIG_CPU_V7) += div-v7.o
CPU_V7M could make use of that, too.
(If you follow Nico's advice to use runtime patching I cannot test it
for you on v7-M though as my machine has to use an XIP kernel.)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
