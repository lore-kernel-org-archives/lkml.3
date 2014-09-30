Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaI3NLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:11:24 -0400
Received: from mx0.aculab.com ([213.249.233.131]:55427 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750954AbaI3NLW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:11:22 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'David Miller'" <davem@davemloft.net>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "sandeep_n@ti.com" <sandeep_n@ti.com>,
        "joe@perches.com" <joe@perches.com>
Subject: RE: [PATCH v5 2/3] net: Add Keystone NetCP ethernet driver
Thread-Topic: [PATCH v5 2/3] net: Add Keystone NetCP ethernet driver
Thread-Index: AQHP3B6zmjPDCB9GJkW0dya+Jw2jkpwZpd2A
Date: Tue, 30 Sep 2014 13:09:34 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D174A1012@AcuExch.aculab.com>
References: <1411667317-1163-1-git-send-email-santosh.shilimkar@ti.com>
	<1411667317-1163-3-git-send-email-santosh.shilimkar@ti.com>
 <20140929.155200.2231132602322345812.davem@davemloft.net>
In-Reply-To: <20140929.155200.2231132602322345812.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller
> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Date: Thu, 25 Sep 2014 13:48:36 -0400
> 
> > +static inline int gbe_phy_link_status(struct gbe_slave *slave)
> > +{
> > +	if (!slave->phy)
> > +		return 1;
> > +
> > +	if (slave->phy->link)
> > +		return 1;
> > +
> > +	return 0;
> > +}
> 
> Please use 'bool' as the return type and return 'true' or 'false'.

That function body could also be just:
	return !slave->phy && slave->phy->link;
which might be more readable if directly coded.

I also wonder if slave>phy can actually be NULL?
If it can be under unusual circumstances it might be worth
assigning the address of a dummy 'phy' structure so that the
tests can all be removed.

	David



