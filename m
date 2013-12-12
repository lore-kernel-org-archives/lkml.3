Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab3LLIbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 03:31:06 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:49769 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3LLIbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 03:31:04 -0500
MIME-Version: 1.0
In-Reply-To: <20131210224659.GY13171@atomide.com>
References: <1381784555-18344-1-git-send-email-marek@goldelico.com>
	<1381784555-18344-2-git-send-email-marek@goldelico.com>
	<20131111164917.GN15154@atomide.com>
	<CAAfyv37LRb_Q=UZVgtKdOAz_r6_qThewAU90W7nrqHdB5fDA_g@mail.gmail.com>
	<20131111233152.GR15154@atomide.com>
	<CAAfyv36MaVqrmQxpqDu-ciO9GNJK3pJkFZohEvd1BOLOWWEOhw@mail.gmail.com>
	<20131210224659.GY13171@atomide.com>
Date: Thu, 12 Dec 2013 09:31:02 +0100
Message-ID: <CAAfyv35wKAK2PNjcXcNan9GC0x-MmH5k4xmzj_vKKhPeztHV-A@mail.gmail.com>
Subject: Re: [PATCH 1/3] arm: omap2: Export devconf1 bypass and acbias.
From: Belisko Marek <marek.belisko@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        NeilBrown <neilb@suse.de>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Tue, Dec 10, 2013 at 11:46 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Belisko Marek <marek.belisko@gmail.com> [131210 14:13]:
>> On Tue, Nov 12, 2013 at 12:31 AM, Tony Lindgren <tony@atomide.com> wrote:
>> >
>> > It would be best to set it up as omap-ctrl.c driver under drivers
>> > somewhere with few functions exported for DSS and MMC drivers.
>>
>> I create small dummy driver based on phy-omap-control which can be
>> used but before sending patch (with more updates) I would like to get
>> some feedback if my direction is correct.
>
> Cool thanks. Yeah what you have can easily be combined with the patches
> Balaji has posted to make HSMMC use drivers/mfd/syscon.c via regmap
> for the SCM register access. Maybe take a look at the work in progress
> patches in thread:
>
> [PATCH v4 0/7] mmc: omap_hsmmc: pbias dt and cleanup
>
> And also see my comments regarding using the SCM GENERAL register area
> as base for the syscon.c driver. That should work for your driver too,
> right? And then you can access the SYSCON1 register that way from your
> consumer driver ;)
If I understand correclty I can use syscon driver (it will have in
range also devconf1 register) ad get rid of my custom driver
and then get regmap from syscon and update bits that I need for venc, right?
>
> Regards,
>
> Tony

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
