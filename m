Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbbA0KHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:07:46 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42228 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755340AbbA0KHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:07:44 -0500
Date: Tue, 27 Jan 2015 11:07:42 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sylvain Rochet <sylvain.rochet@finsecur.com>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, nicolas.ferre@atmel.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, peda@axentia.se,
        sergei.shtylyov@cogentembedded.com, linux@maxim.org.za
Subject: Re: [PATCH v3 07/13] pm: at91: remove the config item
 CONFIG_AT91_SLOW_CLOCK
Message-ID: <20150127100742.GA15829@piout.net>
References: <1422337810-3257-1-git-send-email-wenyou.yang@atmel.com>
 <1422338247-5945-1-git-send-email-wenyou.yang@atmel.com>
 <20150127095515.GB32121@gradator.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150127095515.GB32121@gradator.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27/01/2015 at 10:55:15 +0100, Sylvain Rochet wrote :
> Hello Wenyou,
> 
> On Tue, Jan 27, 2015 at 01:57:27PM +0800, Wenyou Yang wrote:
> >  
> >  static void __init at91_pm_init(void)
> >  {
> > -#ifdef CONFIG_AT91_SLOW_CLOCK
> >  	at91_pm_sram_init();
> > -#endif
> >  
> >  	pr_info("AT91: Power Management%s\n", (slow_clock ? " (with slow clock mode)" : ""));
> 
> Details, but the ternary operation can be removed here, slow_clock now 
> defines whether we have PM support at all, not whether we have 
> slow_clock mode available.
> 
> Maybe we should not even display this message on the console if we 
> failed to allocate sram for slow_clock, we already fired a message 
> saying that PM is not available at all in at91_pm_sram_init().
> 

That is done in patch 10/13.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
