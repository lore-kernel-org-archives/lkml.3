Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbaDYQec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:34:32 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:45212
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753234AbaDYQe0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:34:26 -0400
From: Guenter Roeck <groeck@juniper.net>
To: Bjorn Helgaas <bhelgaas@google.com>, Rajat Jain <rajatxjain@gmail.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>
Subject: RE: [PATCH] pci/pciehp: Allow polling/irq mode to be decided on a
 per-port basis
Thread-Topic: [PATCH] pci/pciehp: Allow polling/irq mode to be decided on a
 per-port basis
Thread-Index: AQHPTTw64Av0pi5eWUyOx5zeRBePnZshbocAgAE8dVA=
Date: Fri, 25 Apr 2014 16:34:23 +0000
Message-ID: <e760e15b4f404c6cb3252480a7d8a78a@CO1PR05MB523.namprd05.prod.outlook.com>
References: <5339FF99.2050200@gmail.com> <20140424213106.GI29593@google.com>
In-Reply-To: <20140424213106.GI29593@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.129.239.10]
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(13464003)(51704005)(24454002)(199002)(189002)(66066001)(50986999)(74502001)(99396002)(54356999)(76482001)(33646001)(46102001)(76176999)(87936001)(19580405001)(74316001)(83322001)(4396001)(85852003)(79102001)(83072002)(76576001)(77982001)(99286001)(86362001)(74662001)(81542001)(19580395003)(20776003)(92566001)(2656002)(80022001)(31966008)(81342001)(80976001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR05MB670;H:CO1PR05MB523.namprd05.prod.outlook.com;FPR:E0BCF216.A9F8C519.B1F391B3.88F8C979.202EF;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Thursday, April 24, 2014 2:31 PM
> To: Rajat Jain
> Cc: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; Rajat
> Jain; Guenter Roeck
> Subject: Re: [PATCH] pci/pciehp: Allow polling/irq mode to be decided
> on a per-port basis
> 
> On Mon, Mar 31, 2014 at 04:51:53PM -0700, Rajat Jain wrote:
> > Today, there is a global pciehp_poll_mode module parameter using
> which
> > either _all_ the hot-pluggable ports are to use polling, or _all_ the
> > ports are to use interrupts.
> >
> > In a system where a certain port has IRQ issues, today the only
> option
> > is to use the parameter that converts ALL the ports to use polling
> mode.
> > This is not good, and hence this patch intruduces a bit field that
> can
> > be set using a PCI quirk that indicates that polling should always be
> > used for this particular PCIe port. The remaining ports can still
> > hoose to continue to operate in whatever mode they wish to.
> >
> > Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
> > Signed-off-by: Rajat Jain <rajatjain@juniper.net>
> > Signed-off-by: Guenter Roeck <groeck@juniper.net>
> 
> I'm willing to merge this, but I'd prefer to merge it along with a
> quirk that actually sets dev->hotplug_polling.  Otherwise it's dead
> code and I'll have no way to tell whether we need to keep it.
> 
Bjorn,

what would be the proper location for such a quirk ? 
We use it to help simulating hotplug support on an IDT PES12NT3.
The code is a bit more invasive than just the quirk itself,
since it also needs to touch link and slot status registers,
so quirks.c doesn't seem appropriate.

drivers/pci/pes12nt3.c, maybe, with a separate configuration
option ? Or in the hotplug directory ?

Guenter

