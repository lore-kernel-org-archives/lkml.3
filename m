Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278Ab3LJWrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:47:17 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:44026 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3LJWrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:47:10 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.236.217
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX185hjniU8A4Vk8niRmgwnJZ
Date: Tue, 10 Dec 2013 14:46:59 -0800
From: Tony Lindgren <tony@atomide.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        NeilBrown <neilb@suse.de>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Subject: Re: [PATCH 1/3] arm: omap2: Export devconf1 bypass and acbias.
Message-ID: <20131210224659.GY13171@atomide.com>
References: <1381784555-18344-1-git-send-email-marek@goldelico.com>
 <1381784555-18344-2-git-send-email-marek@goldelico.com>
 <20131111164917.GN15154@atomide.com>
 <CAAfyv37LRb_Q=UZVgtKdOAz_r6_qThewAU90W7nrqHdB5fDA_g@mail.gmail.com>
 <20131111233152.GR15154@atomide.com>
 <CAAfyv36MaVqrmQxpqDu-ciO9GNJK3pJkFZohEvd1BOLOWWEOhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfyv36MaVqrmQxpqDu-ciO9GNJK3pJkFZohEvd1BOLOWWEOhw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Belisko Marek <marek.belisko@gmail.com> [131210 14:13]:
> On Tue, Nov 12, 2013 at 12:31 AM, Tony Lindgren <tony@atomide.com> wrote:
> >
> > It would be best to set it up as omap-ctrl.c driver under drivers
> > somewhere with few functions exported for DSS and MMC drivers.
>
> I create small dummy driver based on phy-omap-control which can be
> used but before sending patch (with more updates) I would like to get
> some feedback if my direction is correct.

Cool thanks. Yeah what you have can easily be combined with the patches
Balaji has posted to make HSMMC use drivers/mfd/syscon.c via regmap
for the SCM register access. Maybe take a look at the work in progress
patches in thread:

[PATCH v4 0/7] mmc: omap_hsmmc: pbias dt and cleanup

And also see my comments regarding using the SCM GENERAL register area
as base for the syscon.c driver. That should work for your driver too,
right? And then you can access the SYSCON1 register that way from your
consumer driver ;)

Regards,

Tony
