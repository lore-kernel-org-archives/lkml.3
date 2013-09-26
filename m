Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab3IZWxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 18:53:38 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:10265
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754407Ab3IZWxg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 18:53:36 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/13] hv: clean up dev_attr usage
Thread-Topic: [PATCH 00/13] hv: clean up dev_attr usage
Thread-Index: AQHOsK+1mcM+7wT8AkG+31wmWIBnRpnKSIeQgA345ICAAG7ioA==
Date: Thu, 26 Sep 2013 22:36:29 +0000
Message-ID: <6d9cd58d90574c3682a83d3a35cf5691@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
 <654a20fac822400798f991f33b699018@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130926155935.GA30834@kroah.com>
In-Reply-To: <20130926155935.GA30834@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.238.76.143]
x-forefront-prvs: 0981815F2F
x-forefront-antispam-report: SFV:NSPM;SFS:(377454003)(52604005)(51704005)(13464003)(199002)(189002)(24454002)(49866001)(69226001)(47736001)(81542001)(81816001)(4396001)(33646001)(74316001)(74706001)(46102001)(74876001)(80022001)(81342001)(74366001)(83322001)(65816001)(50986001)(66066001)(19580395003)(19580405001)(76482001)(83072001)(54356001)(79102001)(56776001)(53806001)(47446002)(74502001)(76796001)(77096001)(76786001)(31966008)(81686001)(54316002)(80976001)(47976001)(76576001)(51856001)(59766001)(63696002)(56816003)(77982001)(74662001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:212.238.76.143;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I am currently travelling; when I get back I will take a look.

K. Y

> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, September 26, 2013 9:00 AM
> To: KY Srinivasan
> Cc: Haiyang Zhang; devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 00/13] hv: clean up dev_attr usage
> 
> On Tue, Sep 17, 2013 at 06:42:30PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> > > Sent: Friday, September 13, 2013 11:33 AM
> > > To: KY Srinivasan; Haiyang Zhang
> > > Cc: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
> > > Subject: [PATCH 00/13] hv: clean up dev_attr usage
> > >
> > > Hi,
> > >
> > > Here's a set of 13 patches to get rid of the dev_attrs use in the hv bus
> > > code, as it will be going away soon.  It's _way_ bigger than all other
> > > conversions I've had to do so far in the kernel, as you were using a
> > > "multiplexor" function for all of these files.
> > >
> > > So, I've broken it up into individual show/store sysfs functions, and
> > > cleaned up a bunch of debug structures that aren't needed and shouldn't
> > > be exported to the rest of the kernel.
> > >
> > > I've also fixed up some void * usage in the hv core, in patch 07, to
> > > make things simpler and not so "magic" when dealing with these pages.
> > > If you could review that one closely to ensure I didn't mess anything
> > > up, I would appreciate it.
> > >
> > > Also, are all of these files really needed for sysfs?  They seem to be
> > > all debugging stuff, shouldn't they go into debugfs if you really
> > > need/use them anymore?
> > >
> > > KY, could you test these out?  I don't have access to a hv system at the
> > > moment.  I'll wait for your ack before applying them to any of my trees.
> >
> > The patches look good and I tested them. The guest comes up and is functional.
> > I did notice though that the pending state appears to be a signed entity now
> which was not the
> > the case  before - I see a negative sign when I cat the client/server pending
> state.
> 
> Which exact file is that?  I didn't change the % modifiers for any of
> the data types, or at least I sure shouldn't have, if so, that's a bug
> on my side.
> 
> Thanks for testing, I'll queue these up, and if you can tell me which
> sysfs file is different, I'll verify the code conversion again, but I
> just reviewed it and can't seem to find anything.
> 
> thanks,
> 
> greg k-h
