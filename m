Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab3IXMgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:36:17 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:15320
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750784Ab3IXMgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:36:16 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Jack Wang <xjtuwjp@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: RE: Drivers: scsi: FLUSH timeout
Thread-Topic: Drivers: scsi: FLUSH timeout
Thread-Index: AQHOtkBtWGcmfS/7wkmW+8Ppp9OK8pnPmBJggAU49YCAAAdE0A==
Date: Tue, 24 Sep 2013 12:35:53 +0000
Message-ID: <3413dbd7fa254fd380a84fe6d9cd87e1@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com>
 <20130920203222.GA14306@kroah.com>
 <a97d266e2c284d688d2dd7ad43f179b8@SN2PR03MB061.namprd03.prod.outlook.com>
 <524180B7.7090307@gmail.com>
In-Reply-To: <524180B7.7090307@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [109.174.139.136]
x-forefront-prvs: 09796A1B83
x-forefront-antispam-report: SFV:NSPM;SFS:(479174003)(377454003)(24454002)(13464003)(51704005)(199002)(189002)(50986001)(4396001)(49866001)(80976001)(47736001)(51856001)(46102001)(19580395003)(83322001)(19580405001)(74876001)(47976001)(53806001)(1411001)(76482001)(15975445006)(54316002)(56776001)(81816001)(31966008)(74662001)(47446002)(74502001)(33646001)(81686001)(76576001)(77096001)(76786001)(76796001)(56816003)(74316001)(74366001)(74706001)(83072001)(54356001)(15202345003)(81342001)(65816001)(63696002)(66066001)(77982001)(69226001)(59766001)(80022001)(79102001)(81542001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:109.174.139.136;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jack Wang [mailto:xjtuwjp@gmail.com]
> Sent: Tuesday, September 24, 2013 5:08 AM
> To: KY Srinivasan
> Cc: Greg KH; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; hch@infradead.org; linux-
> scsi@vger.kernel.org; Mike Christie
> Subject: Re: Drivers: scsi: FLUSH timeout
> 
> On 09/21/2013 07:24 AM, KY Srinivasan wrote:
> >
> >
> >> -----Original Message-----
> >> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> >> Sent: Friday, September 20, 2013 1:32 PM
> >> To: KY Srinivasan
> >> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> >> ohering@suse.com; jbottomley@parallels.com; hch@infradead.org; linux-
> >> scsi@vger.kernel.org
> >> Subject: Re: Drivers: scsi: FLUSH timeout
> >>
> >> On Fri, Sep 20, 2013 at 12:32:27PM -0700, K. Y. Srinivasan wrote:
> >>> The SD_FLUSH_TIMEOUT value is currently hardcoded.
> >>
> >> Hardcoded where?  Please, more context.
> >
> > This is defined in scsi/sd.h:
> >
> > #define SD_FLUSH_TIMEOUT        (60 * HZ)
> >>
> >>> On our cloud, we sometimes hit this timeout. I was wondering if we
> >>> could make this a module parameter. If this is acceptable, I can send
> >>> you a patch for this.
> >>
> >> A module parameter don't make sense for a per-device value, does it?
> > Currently, the 60 second timeout is applied across devices. Ideally, I want to be
> > able to control the FLUSH TIMEOUT as we currently do I/O timeout. If this is
> > acceptable, I can work on a patch for that as well.
> >
> > Regards,
> >
> > K. Y
> >>
> >> greg k-h
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> Hi,
> 
> Back to 2010, Mike(cc-ed) try to add a flush time out interface, similar
> to what you want here, no idea why it's just ignored?
> http://www.spinics.net/lists/linux-scsi/msg45017.html

Thanks Jack. Mike, do you know what the concerns were as to why this
patch was not accepted?

Regards,

K. Y 
