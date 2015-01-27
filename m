Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbbA0Jz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 04:55:26 -0500
Received: from mx-guillaumet.finsecur.com ([91.217.234.131]:40716 "EHLO
	guillaumet.finsecur.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbbA0JzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 04:55:23 -0500
Date: Tue, 27 Jan 2015 10:55:15 +0100
From: Sylvain Rochet <sylvain.rochet@finsecur.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, peda@axentia.se,
        sergei.shtylyov@cogentembedded.com, linux@maxim.org.za
Message-ID: <20150127095515.GB32121@gradator.net>
References: <1422337810-3257-1-git-send-email-wenyou.yang@atmel.com>
 <1422338247-5945-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1422338247-5945-1-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 172.16.8.13
X-SA-Exim-Mail-From: sylvain.rochet@finsecur.com
Subject: Re: [PATCH v3 07/13] pm: at91: remove the config item
 CONFIG_AT91_SLOW_CLOCK
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on guillaumet.finsecur.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wenyou,

On Tue, Jan 27, 2015 at 01:57:27PM +0800, Wenyou Yang wrote:
>  
>  static void __init at91_pm_init(void)
>  {
> -#ifdef CONFIG_AT91_SLOW_CLOCK
>  	at91_pm_sram_init();
> -#endif
>  
>  	pr_info("AT91: Power Management%s\n", (slow_clock ? " (with slow clock mode)" : ""));

Details, but the ternary operation can be removed here, slow_clock now 
defines whether we have PM support at all, not whether we have 
slow_clock mode available.

Maybe we should not even display this message on the console if we 
failed to allocate sram for slow_clock, we already fired a message 
saying that PM is not available at all in at91_pm_sram_init().

Sylvain
