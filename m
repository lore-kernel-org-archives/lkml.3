Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab3HZXXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 19:23:15 -0400
Received: from [207.46.163.154] ([207.46.163.154]:59721 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab3HZXXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 19:23:13 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in the handling of
 channel offers
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in the handling of
 channel offers
Thread-Index: AQHOoprZO3vQBjcbS0OW+8HWuT6PHZmoCSYAgAAFNMCAABAxAIAAAJyg
Date: Mon, 26 Aug 2013 23:21:04 +0000
Message-ID: <b8d214b2635b4754894ee5bf576af8ad@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1377551338-29582-1-git-send-email-kys@microsoft.com>
 <20130826215656.GA2276@kroah.com>
 <240d7113f9cd4862a44bd5d6a7751ca0@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130826231330.GB26285@kroah.com>
In-Reply-To: <20130826231330.GB26285@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::3]
x-forefront-prvs: 0950706AC1
x-forefront-antispam-report: SFV:NSPM;SFS:(13464003)(377454003)(189002)(199002)(24454002)(51704005)(53806001)(69226001)(74876001)(65816001)(56816003)(54356001)(74706001)(80976001)(74316001)(81542001)(76482001)(4396001)(77096001)(74502001)(47446002)(74662001)(54316002)(81342001)(81816001)(31966008)(56776001)(77982001)(59766001)(74366001)(51856001)(76786001)(46102001)(49866001)(47736001)(33646001)(63696002)(80022001)(19580395003)(47976001)(79102001)(83072001)(50986001)(76796001)(19580405001)(83322001)(76576001)(81686001)(3826001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e8:ed31::3;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Monday, August 26, 2013 4:14 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; stable@vger.kernel.org
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in the handling of channel
> offers
> 
> On Mon, Aug 26, 2013 at 10:48:16PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Sent: Monday, August 26, 2013 2:57 PM
> > > To: KY Srinivasan
> > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de;
> > > apw@canonical.com; jasowang@redhat.com; stable@vger.kernel.org
> > > Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in the handling of
> channel
> > > offers
> > >
> > > On Mon, Aug 26, 2013 at 02:08:58PM -0700, K. Y. Srinivasan wrote:
> > > > The channel state should be correctly set before registering the device. In
> the
> > > current
> > > > code the driver probe would fail for channels that have been rescinded and
> > > subsequently
> > > > re-offered. Fix the bug.
> > > >
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > Cc: <stable@vger.kernel.org>
> > >
> > > What older kernel versions have this bug?  When did it show up?
> >
> > The patch that introduced the bug is:
> >
> > commit e68d2971d26577b932a16333ce165af98a96e068
> > Author: K. Y. Srinivasan <kys@microsoft.com>
> > Date:   Thu May 23 12:02:32 2013 -0700
> >
> >     Drivers: hv: vmbus: Implement multi-channel support
> >
> > I think 3.10 shipped with this bug.
> 
> Why do you think that, it's not what git shows:
> 	$ git describe --contains e68d2971d26577b932a16333ce165af98a96e068
> 	v3.11-rc1~157^2~64
> 
> So this is a 3.11-only thing, right?

My mistake; I was looking at some version of linux-3.10 code that had this problem and so I assumed it must have shipped
in 3.10.

Regards,

K. Y
> 
> thanks,
> 
> greg k-h
