Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaGIBrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 21:47:07 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:28320
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751104AbaGIBrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 21:47:04 -0400
From: Dexuan Cui <decui@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH v2] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Thread-Topic: [PATCH v2] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Thread-Index: AQHPmo7K9bmiR/mw30qA8kPuB/vMKpuWvrIAgAAFu4CAADUD0A==
Date: Wed, 9 Jul 2014 01:46:18 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C987AEB9@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1403818501-15547-1-git-send-email-decui@microsoft.com>
 <20140708092709.GI25880@mwanda>
 <EE124450C0AAF944A40DD71E61F878C987A663@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140708223425.GB6310@kroah.com>
In-Reply-To: <20140708223425.GB6310@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.94]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(377454003)(199002)(189002)(13464003)(51704005)(164054003)(19580405001)(79102001)(26826002)(76482001)(81342001)(4396001)(86362001)(54356999)(92566001)(81156004)(50986999)(92726001)(97736001)(55846006)(85852003)(99396002)(74662001)(86612001)(6806004)(20776003)(31966008)(47776003)(16796002)(68736004)(106466001)(95666004)(74502001)(110136001)(76176999)(77982001)(85306003)(69596002)(97756001)(19580395003)(107046002)(33656002)(23726002)(93886003)(80022001)(85806002)(2656002)(87936001)(77096002)(64706001)(46406003)(81542001)(50466002)(83072002)(46102001)(106116001)(83322001)(84676001)(2351001)(44976005)(21056001);DIR:OUT;SFP:;SCL:1;SRVR:BN3PR0301MB1169;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0267E514F9
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> > > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > > Sent: Tuesday, July 8, 2014 17:27 PM
> > > To: Dexuan Cui
> > > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> driverdev-
> > > devel@linuxdriverproject.org; plagnioj@jcrosoft.com;
> > > tomi.valkeinen@ti.com; linux-fbdev@vger.kernel.org; olaf@aepfle.de;
> > > apw@canonical.com; jasowang@redhat.com; Haiyang Zhang
> > > Subject: Re: [PATCH v2] video: hyperv: hyperv_fb: refresh the VM screen
> by
> > > force on VM panic
> > >
> > > Don't use likely/unlikely unless you have benchmark numbers to show
> that
> > > it makes a speed up.
> > >
> > > regards,
> > > dan carpenter
> >
> > Hi Dan,
> > Here the variable 'synchronous_fb' is only set to true when the system
> panics.
> > So before the system panics, it's always 'unlikely'. :-)
> 
> Then take advantage of gcc's and your processor's prediction, which
> knows that 0 is the "common" case and will choose to do the right thing
> here.
> 
> Dan is right, never put those markings in your code unless you can
> benchmark the difference.  Which means in reality, never put them in
> your code.
> 
> gerg k-h

OK, let me send out a v3 patch, which will remove the unlikely.

Thanks,
-- Dexuan
