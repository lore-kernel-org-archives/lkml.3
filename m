Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaI3Vvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:51:52 -0400
Received: from mail-bl2on0124.outbound.protection.outlook.com ([65.55.169.124]:38816
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753267AbaI3Vvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:51:49 -0400
Date: Tue, 30 Sep 2014 14:35:51 -0700
From: Guenter Roeck <groeck@juniper.net>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Bjorn Helgaas <bhelgaas@google.com>, Rajat Jain <rajatxjain@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>
Subject: Re: [PATCH 0/4] Driver for talking to PLX PEX8xxx PCIe switch over
 I2C
Message-ID: <20140930213306.GA29008@svl-evodev-groeck.juniper.net>
References: <542A3593.4020108@gmail.com>
 <CAErSpo7BkXDHOZwHzwEu2BN3=39xFwQOyrjgVo6afWKMsnYT=A@mail.gmail.com>
 <20140930211339.GA1264@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140930211339.GA1264@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [66.129.239.11]
X-ClientProxiedBy: CO2PR06CA012.namprd06.prod.outlook.com (10.141.242.12) To
 DM2PR05MB528.namprd05.prod.outlook.com (10.141.99.156)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR05MB528;
X-Forefront-PRVS: 0350D7A55D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6069001)(6009001)(24454002)(51704005)(199003)(189002)(54356999)(76176999)(76482002)(97756001)(101416001)(50466002)(102836001)(42186005)(46406003)(50986999)(110136001)(97736003)(20776003)(99396003)(21056001)(33656002)(4396001)(66066001)(105586002)(83506001)(76506005)(77096002)(64706001)(31966008)(92566001)(107046002)(85306004)(554214002)(80022003)(87976001)(120916001)(106356001)(47776003)(95666004)(85852003)(23726002)(92726001)(46102003)(86362001)(10300001)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR05MB528;H:localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: juniper.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 11:13:39PM +0200, Wolfram Sang wrote:
> 
> > > Since this is a driver for a PCIe switch, I currently put it under /driver/pci/.
> > > I'm very open to suggestions for moving this around (Does introducing
> > > drivers/pci/switch/ seem any better?). Especially I can see that the
> > > drivers/pci/Kconfig appears under "Bus Options" in the main menu which does not
> > > look like the right place for this driver. I am looking for suggestions here.
> > 
> > Definitely interesting work.  I have no idea where to put it.  It
> > doesn't have anything to do with PCI core services or structures, so
> > drivers/pci doesn't seem like the ideal place for it, but I don't have
> > any better ideas.  If it did end up under drivers/pci, I agree that a
> > drivers/pci/switch or something similar would probably be better than
> > having it directly in drivers/pci.
> > 
> > Maybe Wolfram or other I2C folks will have an idea.
> 
> Hmm, is this a common interface for those switches? Then a directory
> like drivers/pci/switch could make sense. Otherwise I'd suggest
> drivers/misc?
> 
We had discussed drivers/misc internally, but it didn't seem to be the right
location to me. After all, it is not a misc driver, but a driver to configure
a PCIe switch. Not that I have a better idea, though.

Guenter
