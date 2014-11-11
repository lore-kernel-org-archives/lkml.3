Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaKKUmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:42:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36094 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaKKUmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:42:22 -0500
Date: Tue, 11 Nov 2014 21:42:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: "jonghwa3.lee@samsung.com" <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "sre@kernel.org" <sre@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "anton@enomsg.org" <anton@enomsg.org>
Subject: Re: [PATCH 2/3] power: core: Add variables related temperature to
 power_supply_info.
Message-ID: <20141111204219.GA1347@amd>
References: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
 <1412679518-21499-3-git-send-email-jonghwa3.lee@samsung.com>
 <20ADAB092842284E95860F279283C5642ED9EDE3@BGSMSX104.gar.corp.intel.com>
 <546158A0.5000707@samsung.com>
 <20ADAB092842284E95860F279283C5642EDB8431@BGSMSX104.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20ADAB092842284E95860F279283C5642EDB8431@BGSMSX104.gar.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-11-11 04:56:31, Tc, Jenny wrote:
> > > The CC,CV and restart threshold would vary based on the battery temperature
> > > So I would suggest to have temperature zone table as part  of battery info
> > > along with other attributes.
> > >
> > > int iterm; //charge termination current (used to stop charging)
> > > int temp_zone_count; // number of temperature zone tables present
> > > struct batt_temp_mon_table temp_mon_tbl[MAX_TEMP_MON_TABLE];
> > //temperature zone table array
> > >
> > > struct  batt_temp_mon_table {
> > > 	 short int temp_max;
> > > 	 short int cc;
> > > 	 short int cv;
> > > 	 short int vbat_vchk_drop_uv;
> > > 	 short int temp_min;
> > > };
> > >
> > 
> > 
> > IMO, throttling cc/cv according the temperature can be done via thermal fw
> > interface. However voltage drop and charging termination current can be added here.
> 
> The CC/CV for each battery temperature zone is defined as part of battery spec. This is
> as per the JEITA/PSE standards. So IMO, this is a battery charging information
> (charging object) rather than a thermal throttling information.
> 
> Also the battery information may not fit into a standard format. Different standards have
> different format for charging object. So I would suggest to make it flexible enough to
> support different charging object format. For example MIPI BIF charging object format
> (https://members.mipi.org/wg/BIF/document/11518) and MIPI BIF Rule based charging algorithm
> (http://mipi.org/sites/default/files/mipi_BIF_rule-based-charging_white-paper_1.pdf)
> has different charging object format. This is why the patch  https://lkml.org/lkml/2014/8/13/355
> has option to support different charging objects and different charging algorithms.

Yes, and this is also why your patches are not being
merged. Overengineered, too complex. Citing standards will not improve
the patches.

And yes, adding cc/cv to the thermal interface seems like a good idea
to me.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
