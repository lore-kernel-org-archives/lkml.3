Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3IXVxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:53:09 -0400
Received: from mail-bn1lp0155.outbound.protection.outlook.com ([207.46.163.155]:14772
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753517Ab3IXVxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:53:04 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Mike Christie <michaelc@cs.wisc.edu>
CC: Jack Wang <xjtuwjp@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: Drivers: scsi: FLUSH timeout
Thread-Topic: Drivers: scsi: FLUSH timeout
Thread-Index: AQHOtkBtWGcmfS/7wkmW+8Ppp9OK8pnPmBJggAU49YCAAAdE0IAAT/uAgABKyIA=
Date: Tue, 24 Sep 2013 21:53:00 +0000
Message-ID: <bf168ab724a140f989ab3dfe877b750f@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com>
 <20130920203222.GA14306@kroah.com>
 <a97d266e2c284d688d2dd7ad43f179b8@SN2PR03MB061.namprd03.prod.outlook.com>
 <524180B7.7090307@gmail.com>
 <3413dbd7fa254fd380a84fe6d9cd87e1@SN2PR03MB061.namprd03.prod.outlook.com>
 <5241C9E7.2000404@cs.wisc.edu>
In-Reply-To: <5241C9E7.2000404@cs.wisc.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [80.169.49.146]
x-forefront-prvs: 09796A1B83
x-forefront-antispam-report: SFV:NSPM;SFS:(51704005)(189002)(199002)(479174003)(24454002)(377454003)(13464003)(74706001)(74316001)(74366001)(83072001)(77096001)(56816003)(76796001)(76786001)(66066001)(80022001)(81342001)(59766001)(63696002)(65816001)(69226001)(77982001)(81542001)(79102001)(15202345003)(54356001)(53806001)(56776001)(54316002)(81816001)(15975445006)(76482001)(50986001)(4396001)(19580395003)(47976001)(74876001)(19580405001)(83322001)(46102001)(47736001)(49866001)(80976001)(51856001)(74662001)(31966008)(81686001)(76576001)(47446002)(74502001)(33646001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:80.169.49.146;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mike Christie [mailto:michaelc@cs.wisc.edu]
> Sent: Tuesday, September 24, 2013 10:21 AM
> To: KY Srinivasan
> Cc: Jack Wang; Greg KH; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: Re: Drivers: scsi: FLUSH timeout
> 
> On 09/24/2013 07:35 AM, KY Srinivasan wrote:
> >
> >
> >> -----Original Message-----
> >> From: Jack Wang [mailto:xjtuwjp@gmail.com]
> >> Sent: Tuesday, September 24, 2013 5:08 AM
> >> To: KY Srinivasan
> >> Cc: Greg KH; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> >> ohering@suse.com; jbottomley@parallels.com; hch@infradead.org; linux-
> >> scsi@vger.kernel.org; Mike Christie
> >> Subject: Re: Drivers: scsi: FLUSH timeout
> >>
> >> On 09/21/2013 07:24 AM, KY Srinivasan wrote:
> >>>
> >>>
> >>>> -----Original Message-----
> >>>> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> >>>> Sent: Friday, September 20, 2013 1:32 PM
> >>>> To: KY Srinivasan
> >>>> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> >>>> ohering@suse.com; jbottomley@parallels.com; hch@infradead.org; linux-
> >>>> scsi@vger.kernel.org
> >>>> Subject: Re: Drivers: scsi: FLUSH timeout
> >>>>
> >>>> On Fri, Sep 20, 2013 at 12:32:27PM -0700, K. Y. Srinivasan wrote:
> >>>>> The SD_FLUSH_TIMEOUT value is currently hardcoded.
> >>>>
> >>>> Hardcoded where?  Please, more context.
> >>>
> >>> This is defined in scsi/sd.h:
> >>>
> >>> #define SD_FLUSH_TIMEOUT        (60 * HZ)
> >>>>
> >>>>> On our cloud, we sometimes hit this timeout. I was wondering if we
> >>>>> could make this a module parameter. If this is acceptable, I can send
> >>>>> you a patch for this.
> >>>>
> >>>> A module parameter don't make sense for a per-device value, does it?
> >>> Currently, the 60 second timeout is applied across devices. Ideally, I want to
> be
> >>> able to control the FLUSH TIMEOUT as we currently do I/O timeout. If this is
> >>> acceptable, I can work on a patch for that as well.
> >>>
> >>> Regards,
> >>>
> >>> K. Y
> >>>>
> >>>> greg k-h
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >> Hi,
> >>
> >> Back to 2010, Mike(cc-ed) try to add a flush time out interface, similar
> >> to what you want here, no idea why it's just ignored?
> >> http://www.spinics.net/lists/linux-scsi/msg45017.html
> >
> > Thanks Jack. Mike, do you know what the concerns were as to why this
> > patch was not accepted?
> >
> 
> I do not remember the exact concerns. We ended up just increasing the
> hard coded value in:
> 
> commit e3b3e6246726cd05950677ed843010b8e8c5884c
> Author: Mike Christie <mchristi@redhat.com>
> Date:   Wed Aug 11 11:06:25 2010 -0500
> 
>     [SCSI] scsi/block: increase flush/sync timeout
> 
> 
> In the git commit message there is a comment about people thinking
> making it configurable for users was troublesome.

I am not sure how that magic number was arrived at (the 60HZ number). We want this to be little higher -
would there be any issues raising this to say  180 seconds. This is the value we currently have for I/O
timeout.

Regards,

K. Y

