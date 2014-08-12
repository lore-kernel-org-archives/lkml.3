Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaHLHQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:16:20 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:12303
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751626AbaHLHQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:16:18 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] Input: serio: make HYPERV_KEYBOARD depend on
 SERIO_I8042=y
Thread-Topic: [PATCH] Input: serio: make HYPERV_KEYBOARD depend on
 SERIO_I8042=y
Thread-Index: AQHPtfL80p5QO0TZ/0qF/qigPt99A5vMiCDw
Date: Tue, 12 Aug 2014 07:15:25 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C9920EAF@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1407814240-4275-1-git-send-email-decui@microsoft.com>
 <20140812032148.GB6867@kroah.com>
 <EE124450C0AAF944A40DD71E61F878C9920A1C@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140812060108.GA13231@kroah.com>
In-Reply-To: <20140812060108.GA13231@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.95]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(164054003)(189002)(199003)(51914003)(13464003)(51704005)(95666004)(110136001)(74662001)(19580405001)(81342001)(64706001)(20776003)(80022001)(50466002)(31966008)(79102001)(83072002)(55846006)(106116001)(85806002)(77982001)(106466001)(76176999)(46102001)(16796002)(107046002)(85306004)(50986999)(74502001)(47776003)(93886004)(54356999)(76482001)(6806004)(21056001)(23726002)(4396001)(86362001)(46406003)(97756001)(97736001)(19580395003)(92726001)(92566001)(99396002)(33656002)(83322001)(87936001)(85852003)(81156004)(81542001)(26826002)(2656002)(77096002)(86612001)(84676001)(68736004)(69596002)(44976005);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB241;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0301360BF5
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Greg KH
> > > What exactly needs to be done to fix this "correctly" that is going to
> > > take too much work at the moment?
> >
> > To decouple the dependency between the hyperv-keyboard and i8042
> > modules, I suppose we probably have to re-implement hyperv-keyboard by
> > using input_allocate_device(), input_register_device(), and using
> > input_report_key() to pass the key strokes to the high level.
> 
> Yes, that would be the best thing to do, and shouldn't be that hard to
> create an input driver, it's pretty simple code, right?
Hi Greg,
Thanks for the confirmation!
I didn't use the APIs before. 
I think I need a couple of days to code, test and debug it while I have many
 things at hand at present. :-(

> > I'll have to need some time for further investigation and a new
> > implementation. Before the new code is completely ready, IMHO the
> > patch can help to avoid a bad user experience like Arch Linux working
> > as a Generation 2 hyper-v guest.
> 
> You are still preventing Arch from working here, as the driver can't be
> built at all, right?
The driver can build(compile) fine.
The issue is: the latest Arch Linux release doesn't have a working (virtual)
keyboard when it runs as Generation 2 hyper-v guest -- when it runs as
a "traditional" Generation 1 hyper-v guest, everything works fine.
I hope this patch can temporarily help Arch users if they find the issue
and if they can rebuild the kernel.
 
> > BTW, looks most of Linux distros (like RHEL, Ubuntu, SUSE) have
> > CONFIG_SERIO_I8042=y, probably because it's the result of
> > "make defconfig". So the patch actually doesn't affect these distros.
> 
> Or maybe it is beause they use older kernels and like to turn on every
> single possible option :)
If these 3 distros had =m, we could have found the issue earlier.

Thanks,
-- Dexuan
