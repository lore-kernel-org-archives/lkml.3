Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaHSO04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:26:56 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:47849
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753161AbaHSO0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:26:54 -0400
Date: Tue, 19 Aug 2014 09:21:36 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Guenter Roeck <linux@roeck-us.net>
CC: Mark Brown <broonie@kernel.org>, Jean Delvare <jdelvare@suse.de>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: power supply gating with ltc2978
In-Reply-To: <20140818030717.GA5131@roeck-us.net>
Message-ID: <alpine.DEB.2.02.1408190914310.22837@atx-linux-37>
References: <alpine.DEB.2.02.1408151623140.21645@atx-linux-37> <20140816132050.GH28623@sirena.org.uk> <20140818030717.GA5131@roeck-us.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR04CA034.namprd04.prod.outlook.com (10.141.154.152) To
 BY2PR03MB313.namprd03.prod.outlook.com (10.141.139.13)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0308EE423E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009006)(6009001)(24454002)(51704005)(189002)(199003)(77096002)(50986999)(4396001)(102836001)(74502001)(81156004)(85306004)(46406003)(79102001)(110136001)(77982001)(99396002)(42186005)(83506001)(76176999)(53416004)(101416001)(106356001)(83322001)(54356999)(23726002)(86152002)(86362001)(83072002)(74662001)(95666004)(81342001)(81542001)(87976001)(76482001)(85852003)(80022001)(50466002)(33716001)(66066001)(46102001)(105586002)(47776003)(20776003)(92726001)(107046002)(69596002)(21056001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB313;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2014, Guenter Roeck wrote:

> On Sat, Aug 16, 2014 at 02:20:50PM +0100, Mark Brown wrote:
> > On Fri, Aug 15, 2014 at 04:34:49PM -0500, atull wrote:
> > 
> > > I am interested in adding functionality to be able to gate power supplies 
> > > going through a ltc2978.  I see that there is a hwmon driver already 
> > > existing (hwmon/pmbus/ltc2978.c).  I see some of the other hwmon drivers 
> > > have MFD's.  It looks like this ltc driver would need a MFD and a 
> > > regulator driver added.  However I don't see other pmbus hwmon drivers
> > > using MFD.
> > 
> > > So I am asking for recommendations and reservations on how to proceed here 
> > > before I get too far with this.
> > 
> > Without knowing anything at all about pmbus or this particular hardware
> > it's hard to comment but what you're saying here sounds sensible (though
> > I do see that apparently splitting the drivers may not actually be
> > sensible from Guenter's followup).
> 
> I had originally thought about converting the pmbus drivers to mfd with client
> drivers, but I concluded that it would add a lot of complexity with little gain.
> It makes sense to separate a driver into mfd and a number of client drivers
> if a device has clear functional blocks for the different devices it supports.
> With PMBus, this is not the case. Separating a PMBus driver would be a purely
> artificial costruct, and there would be overlapping functionality. Separating
> just a single driver out of the group of PMBus drivers, as seems to be suggested
> above, makes even less sense as one simply can not separate the core PMBus
> driver code from its front-end drivers.
> 
> On the other side, adding regulator support into the PMBus driver code would
> make a lot of sense. It should also be quite straightforward.
> 
> Or anyway that is my opinion. If someone wants to spend the time and separate
> the PMBus drivers into an MfD part and hwmon and regulator client drivers, I'll
> be happy to look at the resulting patch set.
> 
> Guenter
> 

Hi Guenter,

I'd really rather just add regulator support to the PMBus driver code and 
avoid all the mess of creating a MFD.  It seems more straigtforward. I'll 
let you know when I have something working to look at.

Alan
