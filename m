Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab3ISQbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 12:31:49 -0400
Received: from [207.46.163.158] ([207.46.163.158]:58901 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751157Ab3ISQbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 12:31:48 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "vojtech@suse.cz" <vojtech@suse.cz>
Subject: RE: [PATCH V2 1/1] Drivers: input: serio: New driver to support
 Hyper-V synthetic keyboard
Thread-Topic: [PATCH V2 1/1] Drivers: input: serio: New driver to support
 Hyper-V synthetic keyboard
Thread-Index: AQHOs/eVPipjOSapYkq/ifTO5i21spnL/HUAgAAj11CAARhlgIAACdjw
Date: Thu, 19 Sep 2013 16:31:07 +0000
Message-ID: <c3ebbe28a47b45a98252f2d57a5adad0@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379460418-1523-1-git-send-email-kys@microsoft.com>
 <20130918210107.GA32320@core.coreip.homeip.net>
 <304cbdeb0aa34f9a9ba6b44828fb5647@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130919155259.GA5731@core.coreip.homeip.net>
In-Reply-To: <20130919155259.GA5731@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::2]
x-forefront-prvs: 09749A275C
x-forefront-antispam-report: SFV:NSPM;SFS:(377454003)(24454002)(13464003)(51704005)(199002)(189002)(81686001)(76482001)(77982001)(56776001)(33646001)(81816001)(53806001)(74502001)(74662001)(31966008)(47446002)(46102001)(74706001)(51856001)(59766001)(74876001)(19580395003)(19580405001)(54316002)(83322001)(47736001)(76576001)(74316001)(50986001)(47976001)(74366001)(4396001)(63696002)(80976001)(83072001)(54356001)(76786001)(76796001)(69226001)(49866001)(77096001)(56816003)(81542001)(80022001)(81342001)(65816001)(79102001)(3826001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e0:ee43::2;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Thursday, September 19, 2013 8:53 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; dan.carpenter@oracle.com; linux-
> input@vger.kernel.org; vojtech@suse.cz
> Subject: Re: [PATCH V2 1/1] Drivers: input: serio: New driver to support Hyper-V
> synthetic keyboard
> 
> On Wed, Sep 18, 2013 at 11:27:51PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> > > Sent: Wednesday, September 18, 2013 2:01 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > jasowang@redhat.com; dan.carpenter@oracle.com; linux-
> > > input@vger.kernel.org; vojtech@suse.cz
> > > Subject: Re: [PATCH V2 1/1] Drivers: input: serio: New driver to support
> Hyper-V
> > > synthetic keyboard
> > >
> > > Hi K.Y.,
> > >
> > > On Tue, Sep 17, 2013 at 04:26:58PM -0700, K. Y. Srinivasan wrote:
> > > > Add a new driver to support synthetic keyboard. On the next generation
> > > > Hyper-V guest firmware, many legacy devices will not be emulated and this
> > > > driver will be required.
> > > >
> > > > I would like to thank Vojtech Pavlik <vojtech@suse.cz> for helping me with
> the
> > > > details of the AT keyboard driver. I would also like to thank
> > > > Dan Carpenter <dan.carpenter@oracle.com> and
> > > > Dmitry Torokhov <dmitry.torokhov@gmail.com> for their detailed review of
> > > this
> > > > driver.
> > > >
> > > > I have addressed all the comments of Dan and Dmitry in this version of
> > > > the patch
> > >
> > > This looks much better. Could you tell me if the patch below (on top of
> > > yours) still works?
> > >
> > > Thanks.
> >
> > Thank you. The code looks much better now. You forgot to initialize the
> port_data and
> > after I fixed that everything seems to work as it did before: Here is the patch I
> used:
> 
> Excellent, thank you for trying it out. I folded it all together and
> queued for 3.13.

Thank you.

Regards,

K. Y

