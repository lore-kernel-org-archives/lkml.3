Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaFFCxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 22:53:21 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:26953
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751748AbaFFCxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 22:53:20 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Mike Christie <michaelc@cs.wisc.edu>
CC: James Bottomley <jbottomley@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Thread-Topic: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Thread-Index: AQHPgAqq5L1zp+ngQ0O2dQQp+rFvKZthLVSAgAABPoCAAh+9gIAAFcfQ
Date: Fri, 6 Jun 2014 02:53:15 +0000
Message-ID: <d9854e6ff97f4b0087dbe835a2a57c8f@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1401899623-24194-1-git-send-email-kys@microsoft.com>
 <1401901323.17510.23.camel@dabdike>
 <d61f4b87a72544e4b0c1e1872a76f97b@BY2PR03MB299.namprd03.prod.outlook.com>
 <53911A35.7010805@cs.wisc.edu>
In-Reply-To: <53911A35.7010805@cs.wisc.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:605e:a01a:1e1f:e170]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(479174003)(51704005)(377454003)(24454002)(13464003)(377424004)(199002)(189002)(92566001)(19580395003)(86612001)(74316001)(77982001)(79102001)(46102001)(101416001)(80022001)(20776003)(93886002)(99396002)(81542001)(64706001)(74662001)(86362001)(21056001)(83322001)(19580405001)(50986999)(87936001)(77096999)(85852003)(76176999)(31966008)(54356999)(2656002)(83072002)(76576001)(2171001)(76482001)(99286001)(33646001)(4396001)(74502001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB297;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mike Christie [mailto:michaelc@cs.wisc.edu]
> Sent: Thursday, June 5, 2014 6:33 PM
> To: KY Srinivasan
> Cc: James Bottomley; linux-kernel@vger.kernel.org; apw@canonical.com;
> devel@linuxdriverproject.org; hch@infradead.org; linux-
> scsi@vger.kernel.org; ohering@suse.com; gregkh@linuxfoundation.org;
> jasowang@redhat.com
> Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT
> from the basic I/O timeout
> 
> On 06/04/2014 12:15 PM, KY Srinivasan wrote:
> >
> >
> >> -----Original Message-----
> >> From: James Bottomley [mailto:jbottomley@parallels.com]
> >> Sent: Wednesday, June 4, 2014 10:02 AM
> >> To: KY Srinivasan
> >> Cc: linux-kernel@vger.kernel.org; apw@canonical.com;
> >> devel@linuxdriverproject.org; hch@infradead.org; linux-
> >> scsi@vger.kernel.org; ohering@suse.com; gregkh@linuxfoundation.org;
> >> jasowang@redhat.com
> >> Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the
> >> FLUSH_TIMEOUT from the basic I/O timeout
> >>
> >> On Wed, 2014-06-04 at 09:33 -0700, K. Y. Srinivasan wrote:
> >>> Commit ID: 7e660100d85af860e7ad763202fff717adcdaacd added code to
> >>> derive the FLUSH_TIMEOUT from the basic I/O timeout. However, this
> >>> patch did not use the basic I/O timeout of the device. Fix this bug.
> >>>
> >>> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> >>> ---
> >>>  drivers/scsi/sd.c |    4 +++-
> >>>  1 files changed, 3 insertions(+), 1 deletions(-)
> >>>
> >>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c index
> >>> e9689d5..54150b1 100644
> >>> --- a/drivers/scsi/sd.c
> >>> +++ b/drivers/scsi/sd.c
> >>> @@ -832,7 +832,9 @@ static int sd_setup_write_same_cmnd(struct
> >>> scsi_device *sdp, struct request *rq)
> >>>
> >>>  static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct
> >>> request *rq)  {
> >>> -	rq->timeout *= SD_FLUSH_TIMEOUT_MULTIPLIER;
> >>> +	int timeout = sdp->request_queue->rq_timeout;
> >>> +
> >>> +	rq->timeout = (timeout * SD_FLUSH_TIMEOUT_MULTIPLIER);
> >>
> >> Could you share where you found this to be a problem?  It looks like
> >> a bug in block because all inbound requests being prepared should
> >> have a timeout set, so block would be the place to fix it.
> >
> > Perhaps; what I found was that the value in rq->timeout was 0 coming
> > into this function and thus multiplying obviously has no effect.
> >
> 
> I think you are right. We hit this problem because we are doing:
> 
> scsi_request_fn -> blk_peek_request -> sd_prep_fn ->
> scsi_setup_flush_cmnd.
> 
> At this time request->timeout is zero so the multiplication does nothing. See
> how sd_setup_write_same_cmnd will set the request->timeout at this time.
> 
> Then in scsi_request_fn we do:
> 
> scsi_request_fn -> blk_start_request -> blk_add_timer.
> 
> At this time it will set the request->timeout if something like req block pc
> users (like scsi_execute() or block/scsi_ioctl.c) or the write same code
> mentioned above have not set the timeout.

I don't think this is a recent change. Prior to this commit, we were setting the timeout
value in this function; it just happened to be a different constant unrelated to the I/O
timeout.

K. Y
> 
> 

