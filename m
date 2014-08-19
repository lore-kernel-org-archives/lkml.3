Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaHSSZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:25:53 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:46577 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaHSSZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:25:49 -0400
Date: Tue, 19 Aug 2014 21:25:35 +0300
From: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
To: Mikko Perttunen <mikko.perttunen@kapsi.fi>
Cc: "edubezval@gmail.com" <edubezval@gmail.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Juha-Matti Tilli <jtilli@nvidia.com>
Subject: Re: [PATCH v4 4/4] thermal: Add Tegra SOCTHERM thermal management
 driver
Message-ID: <20140819182535.GA53418@sandfort.unics.fi>
References: <1408100430-29461-1-git-send-email-mperttunen@nvidia.com>
 <20140819140955.GA50475@sandfort.unics.fi>
 <CAC-25o-bLeDYpTgPy5UOvBGJ7k7HJkBM3YcCRPSZHBkyxugULA@mail.gmail.com>
 <53F36CC8.8090707@kapsi.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F36CC8.8090707@kapsi.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 06:27:04PM +0300, Mikko Perttunen wrote:
> > Well, I would suggest using the hardware documentation as a base here.
> > I don't have access to the internal driver, thus, it is hard to judge
> > what is right, what is wrong.
> 
> The hardware documentation (TRM) doesn't say anything about these 
> registers, so I've mostly gone by the downstream driver. FYI, the driver 
> is publicly available in the L4T kernel sources at 
> https://developer.nvidia.com/sites/default/files/akamai/mobile/files/L4T/kernel_src.tbz2. 
> I'm not how useful reading them would be, though.

I also haven't seen anything about the calibration calculation in any
hardware documentation so it may very well be the case that nothing has
been documented and the official information source is the internal
driver itself. Btw, this downstream driver code is most likely old code
as I can only find kernel/arch/arm/mach-tegra/tegra11_socterm.c in
there, and I do remember that on my development branch the file is named
differently. The CONFIG2 value comparison I posted is most likely
against a newer version of that code. I'm not sure if that new version
of that code is publicly available anywhere yet. I'll need to
investigate more if a newer version of that code calculates different
calibration values than an older version of that code. I'm currently
working on soc_therm for future chips, so I have plenty of time to
investigate this.

At least this internal driver can be used as a benchmark for code
clarity. Mikko's code is a lot more clear than this internal driver, so
that's why I decided to base my work on Mikko's code instead of this
internal driver and which is why I noticed the missing --i bug. But now
I'm wondering whether the calibration values are correct...
