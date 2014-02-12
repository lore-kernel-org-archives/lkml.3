Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaBLMod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 07:44:33 -0500
Received: from top.free-electrons.com ([176.31.233.9]:43926 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752264AbaBLMob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 07:44:31 -0500
Date: Wed, 12 Feb 2014 13:44:28 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        boris brezillon <b.brezillon@overkiz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 0/8] Device Tree support for the at91sam9261ek
Message-ID: <20140212134428.4a442f31@skate>
In-Reply-To: <CACh+v5Nv7u4WSXttvsnMPxwNwN6R4ZDRABOXr9XXBjy6mSDi5w@mail.gmail.com>
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
	<52FB5795.9020708@free-electrons.com>
	<20140212133449.5c42216d@skate>
	<CACh+v5Nv7u4WSXttvsnMPxwNwN6R4ZDRABOXr9XXBjy6mSDi5w@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jean-Jacques Hiblot,

On Wed, 12 Feb 2014 13:36:08 +0100, Jean-Jacques Hiblot wrote:

> >> For dm9000 the issue is (again) related to an ordering problem:
> >> the Ethernet need an interrupt provided by the gpio driver. Unfortunately,
> >> the gpio driver initialization is called after the dm900 driver
> >> initialization.
> >
> > And -EPROBE_DEFER doesn't solve this problem?
> not really the problem happens before the driver is actually probed
> when the ressource for the platform driver are filled

Sorry, I don't have all the context. If I understand correctly what you
mean, the GPIO driver is probed through the DT, but the DM9000 driver
is probed in a legacy way from the board file, and you have the case
where the DM9000 platform_device gets registered before the GPIOs are
actually available? In this case, what about having the
of_platform_populate() call *before* the platform_device_register() for
your DM9000 ? Again, I don't have all the context, so I might very well
be getting the situation incorrectly.

Of course, ideally, the DM9000 driver should be probed using the DT,
but I guess this needs the SMC DT binding that is still being
discussed, if I followed correctly.

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
