Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbaGQXx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:53:58 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:9254
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758228AbaGQXx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:53:56 -0400
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, Jens Axboe <axboe@kernel.dk>,
        "James Bottomley" <jbottomley@parallels.com>,
        "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>,
        "Christoph Hellwig (hch@infradead.org)" <hch@infradead.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Thread-Topic: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Thread-Index: AQHPgAqq5L1zp+ngQ0O2dQQp+rFvKZthLVSAgAABPoCAAh+9gIAAFcfQgADyoICAAAl2AIAACGQAgBY2XeCAKpUUYA==
Date: Thu, 17 Jul 2014 23:53:33 +0000
Message-ID: <13807d2cc8744ae1bc374f20d8f9caec@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1401899623-24194-1-git-send-email-kys@microsoft.com>
 <1401901323.17510.23.camel@dabdike>
 <d61f4b87a72544e4b0c1e1872a76f97b@BY2PR03MB299.namprd03.prod.outlook.com>
 <53911A35.7010805@cs.wisc.edu>
 <d9854e6ff97f4b0087dbe835a2a57c8f@BY2PR03MB299.namprd03.prod.outlook.com>
 <5391F801.4010107@cs.wisc.edu>
 <1402077167.2207.89.camel@dabdike.int.hansenpartnership.com>
 <539206FA.1020001@kernel.dk>
 <5b926a0a9f264edda91c7c2ab0acb7d1@BY2PR03MB299.namprd03.prod.outlook.com>
In-Reply-To: <5b926a0a9f264edda91c7c2ab0acb7d1@BY2PR03MB299.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.192.26]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(199002)(479174003)(189002)(24454002)(51704005)(377454003)(377424004)(50986999)(99396002)(77096002)(46102001)(74316001)(74502001)(31966008)(74662001)(81342001)(81542001)(79102001)(80022001)(4396001)(77982001)(76482001)(1511001)(85306003)(33646002)(83072002)(101416001)(85852003)(20776003)(76576001)(92566001)(21056001)(76176999)(54356999)(107046002)(19580395003)(19580405001)(15975445006)(93886003)(86362001)(66066001)(106356001)(106116001)(64706001)(15202345003)(99286002)(95666004)(2656002)(2171001)(86612001)(105586002)(87936001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0712;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: driverdev-devel-bounces@linuxdriverproject.org [mailto:driverdev-
> devel-bounces@linuxdriverproject.org] On Behalf Of KY Srinivasan
> Sent: Friday, June 20, 2014 2:37 PM
> To: Jens Axboe; James Bottomley; michaelc@cs.wisc.edu
> Cc: linux-scsi@vger.kernel.org; gregkh@linuxfoundation.org;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; ohering@suse.com;
> hch@infradead.org; apw@canonical.com; devel@linuxdriverproject.org
> Subject: RE: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT
> from the basic I/O timeout
> 
> 
> 
> > -----Original Message-----
> > From: Jens Axboe [mailto:axboe@kernel.dk]
> > Sent: Friday, June 6, 2014 11:23 AM
> > To: James Bottomley; michaelc@cs.wisc.edu
> > Cc: linux-kernel@vger.kernel.org; hch@infradead.org;
> > devel@linuxdriverproject.org; apw@canonical.com; KY Srinivasan; linux-
> > scsi@vger.kernel.org; ohering@suse.com; gregkh@linuxfoundation.org;
> > jasowang@redhat.com
> > Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the
> > FLUSH_TIMEOUT from the basic I/O timeout
> >
> > On 2014-06-06 11:52, James Bottomley wrote:
> > > On Fri, 2014-06-06 at 12:18 -0500, Mike Christie wrote:
> > >> On 6/5/14, 9:53 PM, KY Srinivasan wrote:
> > >>>
> > >>>
> > >>>> -----Original Message-----
> > >>>> From: Mike Christie [mailto:michaelc@cs.wisc.edu]
> > >>>> Sent: Thursday, June 5, 2014 6:33 PM
> > >>>> To: KY Srinivasan
> > >>>> Cc: James Bottomley; linux-kernel@vger.kernel.org;
> > >>>> apw@canonical.com; devel@linuxdriverproject.org;
> > hch@infradead.org;
> > >>>> linux- scsi@vger.kernel.org; ohering@suse.com;
> > >>>> gregkh@linuxfoundation.org; jasowang@redhat.com
> > >>>> Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the
> > >>>> FLUSH_TIMEOUT from the basic I/O timeout
> > >>>>
> > >>>> On 06/04/2014 12:15 PM, KY Srinivasan wrote:
> > >>>>>
> > >>>>>
> > >>>>>> -----Original Message-----
> > >>>>>> From: James Bottomley [mailto:jbottomley@parallels.com]
> > >>>>>> Sent: Wednesday, June 4, 2014 10:02 AM
> > >>>>>> To: KY Srinivasan
> > >>>>>> Cc: linux-kernel@vger.kernel.org; apw@canonical.com;
> > >>>>>> devel@linuxdriverproject.org; hch@infradead.org; linux-
> > >>>>>> scsi@vger.kernel.org; ohering@suse.com;
> > >>>>>> gregkh@linuxfoundation.org; jasowang@redhat.com
> > >>>>>> Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the
> > >>>>>> FLUSH_TIMEOUT from the basic I/O timeout
> > >>>>>>
> > >>>>>> On Wed, 2014-06-04 at 09:33 -0700, K. Y. Srinivasan wrote:
> > >>>>>>> Commit ID: 7e660100d85af860e7ad763202fff717adcdaacd added
> > code
> > >>>>>>> to derive the FLUSH_TIMEOUT from the basic I/O timeout.
> > However,
> > >>>>>>> this patch did not use the basic I/O timeout of the device.
> > >>>>>>> Fix this
> > bug.
> > >>>>>>>
> > >>>>>>> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > >>>>>>> ---
> > >>>>>>>    drivers/scsi/sd.c |    4 +++-
> > >>>>>>>    1 files changed, 3 insertions(+), 1 deletions(-)
> > >>>>>>>
> > >>>>>>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c index
> > >>>>>>> e9689d5..54150b1 100644
> > >>>>>>> --- a/drivers/scsi/sd.c
> > >>>>>>> +++ b/drivers/scsi/sd.c
> > >>>>>>> @@ -832,7 +832,9 @@ static int
> > sd_setup_write_same_cmnd(struct
> > >>>>>>> scsi_device *sdp, struct request *rq)
> > >>>>>>>
> > >>>>>>>    static int scsi_setup_flush_cmnd(struct scsi_device *sdp,
> > >>>>>>> struct request *rq)  {
> > >>>>>>> -	rq->timeout *= SD_FLUSH_TIMEOUT_MULTIPLIER;
> > >>>>>>> +	int timeout = sdp->request_queue->rq_timeout;
> > >>>>>>> +
> > >>>>>>> +	rq->timeout = (timeout *
> > SD_FLUSH_TIMEOUT_MULTIPLIER);
> > >>>>>>
> > >>>>>> Could you share where you found this to be a problem?  It looks
> > >>>>>> like a bug in block because all inbound requests being prepared
> > >>>>>> should have a timeout set, so block would be the place to fix it.
> > >>>>>
> > >>>>> Perhaps; what I found was that the value in rq->timeout was 0
> > >>>>> coming into this function and thus multiplying obviously has no
> effect.
> > >>>>>
> > >>>>
> > >>>> I think you are right. We hit this problem because we are doing:
> > >>>>
> > >>>> scsi_request_fn -> blk_peek_request -> sd_prep_fn ->
> > >>>> scsi_setup_flush_cmnd.
> > >>>>
> > >>>> At this time request->timeout is zero so the multiplication does
> > >>>> nothing. See how sd_setup_write_same_cmnd will set the request-
> > >timeout at this time.
> > >>>>
> > >>>> Then in scsi_request_fn we do:
> > >>>>
> > >>>> scsi_request_fn -> blk_start_request -> blk_add_timer.
> > >>>>
> > >>>> At this time it will set the request->timeout if something like
> > >>>> req block pc users (like scsi_execute() or block/scsi_ioctl.c) or
> > >>>> the write same code mentioned above have not set the timeout.
> > >>>
> > >>> I don't think this is a recent change. Prior to this commit, we
> > >>> were setting the timeout value in this function; it just happened
> > >>> to be a different constant unrelated to the I/O timeout.
> > >>>
> > >>
> > >> Yeah, it looks like when 7e660100d85af860e7ad763202fff717adcdaacd
> > >> was merged we were supposed to initialize it like in your patch in this
> thread.
> > >>
> > >> I guess we could do your patch in this thread, or if we want the
> > >> block layer to initialize the timeout before the prep_fn callout is
> > >> called then we would need to have the blk-flush.c code to that when
> > >> it sets up the request. If we do the latter, do we want the discard
> > >> and write same code to initialize the request's timeout before the
> > >> prep_fn callout is called too?
> > >
> > > I looked through the call chain; it seems to be intentional
> > > behaviour on the part of block.  Just from an mq point of view, it
> > > would make better code if we unconditionally initialised rq->timeout
> > > early and allowed prep to modify it and then dumped the
> > > if(!req->timeout) in blk_add_timer(), but it's a marginal if
> > > condition that would compile to a conditional store on sensible
> > > architectures, so losing the conditional probably isn't worth worrying
> about.
> > >
> > > Cc'd Jens for his opinion with the block patch
> >
> > I just committed this one earlier today:
> >
> > http://git.kernel.dk/?p=linux-
> > block.git;a=commit;h=f6be4fb4bcb396fc3b1c134b7863351972de081f
> >
> > since I ran into the same thing on nvme. Either approach is fine with
> > me, as they both allow override of the timeout before insertion. But
> > we've always done the rq->timeout = 0 init, so I think we should just
> > reinstate that behavior.
> 
> James,
> 
> How is this being fixed now.
> 
> Regards,
> 
> K. Y

I still see this problem. There was talk of fixing it elsewhere.

Regards,

K. Y
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
