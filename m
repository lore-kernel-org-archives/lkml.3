Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbaAIVNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 16:13:13 -0500
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:26225
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754979AbaAIVNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:13:08 -0500
From: KY Srinivasan <kys@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC: "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] Drivers: hv: Implement the file copy service
Thread-Topic: [PATCH 1/1] Drivers: hv: Implement the file copy service
Thread-Index: AQHPDMVZ9zrtMOoYp0KOm7oSIbZbR5p8AmiAgAC00tCAAByZgIAAAXcAgAAPqHA=
Date: Thu, 9 Jan 2014 21:13:05 +0000
Message-ID: <1890f66fdb9341178202866cd20d4504@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1389224915-8737-1-git-send-email-kys@microsoft.com>
 <20140109073949.GR30234@mwanda>
 <540ecdf5cf6b47d79583f4f97788e3f0@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140109200921.GT30234@mwanda> <20140109201436.GA16425@kroah.com>
In-Reply-To: <20140109201436.GA16425@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.174.216]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(377454003)(24454002)(51704005)(199002)(189002)(13464003)(92566001)(81686001)(66066001)(54356001)(51856001)(59766001)(77982001)(79102001)(54316002)(46102001)(56776001)(76482001)(53806001)(81816001)(80022001)(65816001)(63696002)(74876001)(85306002)(74316001)(90146001)(56816005)(33646001)(85852003)(74366001)(83072002)(87936001)(2656002)(74706001)(76576001)(76786001)(76796001)(87266001)(4396001)(49866001)(47736001)(47976001)(50986001)(81542001)(80976001)(19580405001)(19580395003)(83322001)(69226001)(74662001)(47446002)(81342001)(74502001)(31966008)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB300;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:131.107.174.216;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, January 09, 2014 12:15 PM
> To: Dan Carpenter
> Cc: KY Srinivasan; olaf@aepfle.de; jasowang@redhat.com; linux-
> kernel@vger.kernel.org; apw@canonical.com; devel@linuxdriverproject.org
> Subject: Re: [PATCH 1/1] Drivers: hv: Implement the file copy service
> 
> On Thu, Jan 09, 2014 at 11:09:21PM +0300, Dan Carpenter wrote:
> > We've had this discussion before where you urge me to trust the host...
> >
> >  Problem: This code is racy.
> > Solution: The host will only send one message at a time.
> >
> > Now I have to audit the user space code on the host and I don't feel
> > like doing that so you win.
> >
> > I wish we had a better way to do IPC.  If kdbus were ready, that might
> > have worked for this, and it's a better solution because both sender and
> > reciever code will be written in a less trusting way.
> 
> kdbus is almost ready, it might make 3.15, depending on the result of
> work that is happening at linux.conf.au and FOSDEM.
> 
> If it would be a better solution for this, that's even more reason to
> get kdbus merged soon, no need to add something that doesn't really
> work.
> 
> But, how will kdbus help with this?  It's a userspace <-> userspace
> message transmission bus, would you want the kernel to be a receiver or
> sender here?

Greg,

The transport between the kernel and the user in this driver is a regular char device and
Vmbus is the transport between the host and the guest. As you observe, I am not sure
how kdbus would be useful.

K. Y
> 
> thanks,
> 
> greg k-h
