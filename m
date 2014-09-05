Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaIEVIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:08:24 -0400
Received: from mail-bl2on0108.outbound.protection.outlook.com ([65.55.169.108]:22302
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751144AbaIEVIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:08:23 -0400
X-Greylist: delayed 899 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 17:08:22 EDT
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Enable interrupt driven flow
 control
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Enable interrupt driven flow
 control
Thread-Index: AQHPyS2HCMcjkkrCkkS7mhYFD7Es2Jvy6CAAgAAZOgA=
Date: Fri, 5 Sep 2014 20:53:01 +0000
Message-ID: <af50b440e57a455e810242b83a2462ad@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1409941402-486-1-git-send-email-kys@microsoft.com>
 <20140905191148.GA24879@kroah.com>
In-Reply-To: <20140905191148.GA24879@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:4898:80e0:ee43::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
x-forefront-prvs: 0325F6C77B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019017)(979002)(6009001)(24454002)(129404003)(199003)(377454003)(13464003)(189002)(51704005)(108616004)(81542001)(106356001)(95666004)(105586002)(19580405001)(80022001)(92566001)(46102001)(20776003)(64706001)(81342001)(99286002)(85306004)(77096002)(107046002)(97736003)(79102001)(54356999)(31966008)(76576001)(87936001)(106116001)(101416001)(110136001)(33646002)(99396002)(90102001)(77982001)(4396001)(76176999)(21056001)(74502001)(74662001)(86612001)(2656002)(86362001)(76482001)(83322001)(19580395003)(74316001)(85852003)(83072002)(50986999)(3826002)(24736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:ovrnspm;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, September 5, 2014 12:12 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Enable interrupt driven flow
> control
> 
> On Fri, Sep 05, 2014 at 11:23:22AM -0700, K. Y. Srinivasan wrote:
> > This is a win8 feature that has been implemented. Turn on the feature
> > bit to enable the feature.
> 
> What does those two sentances even mean?
Greg,

The feature has been implemented and has been in the tree for a while.
However, the feature was not advertised to the host and this patch does just that.
> 
> > With this feature turned on,
> 
> What is "this"?
"this" refers to the feature bit.
> 
> > when the host is waiting
> > for space to become available on the ringbuffer (host to guest), the
> > guest will interrupt the host when space becomes available (as part of
> > draining the ring buffer).
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/hv/ring_buffer.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c index
> > 15db66b..6361d12 100644
> > --- a/drivers/hv/ring_buffer.c
> > +++ b/drivers/hv/ring_buffer.c
> > @@ -361,6 +361,11 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info
> *ring_info,
> >  	ring_info->ring_buffer->read_index =
> >  		ring_info->ring_buffer->write_index = 0;
> >
> > +	/*
> > +	 * Set the feature bit for enabling flow control.
> > +	 */
> > +	ring_info->ring_buffer->feature_bits.value = 1;
> 
> What happens if you are running on an old system that doesn't support this
> new "feature"?
The control structure for the ring buffer (where this feature bit is) has not changed and so, for
hosts that don't understand this, it does not matter.

Hope this helps. Let me know if you want me to rewrite comment and resend this patch.

Regards,

K. Y
