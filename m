Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaC2FF6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 01:05:58 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:55465
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751181AbaC2FF5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 01:05:57 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "benjamin.tissoires@redhat.com" <benjamin.tissoires@redhat.com>,
        "dh.herrmann@gmail.com" <dh.herrmann@gmail.com>
Subject: RE: [PATCH 1/1] Drivers: hid: hid-hyperv: Implement a stub
  raw_request() entry point
Thread-Topic: [PATCH 1/1] Drivers: hid: hid-hyperv: Implement a stub
  raw_request() entry point
Thread-Index: AQHPSuAdfiUxVf6Aq0yh8eE33LNb3Zr3SpsAgAA4mTA=
Date: Sat, 29 Mar 2014 05:05:53 +0000
Message-ID: <61cf7a771df1479eb6c407f0109e7587@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1396053687-21421-1-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1403281842100.16202@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1403281842100.16202@pobox.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.19.246.69]
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(51704005)(199002)(189002)(377454003)(97186001)(74876001)(74316001)(74706001)(19580395003)(74366001)(83322001)(19580405001)(31966008)(74502001)(95416001)(47446002)(86612001)(81816001)(95666003)(47976001)(50986001)(69226001)(53806001)(76482001)(4396001)(81686001)(56776001)(54356001)(54316002)(80976001)(98676001)(47736001)(49866001)(46102001)(90146001)(80022001)(65816001)(85306002)(66066001)(20776003)(63696002)(56816005)(93136001)(93516002)(86362001)(76796001)(92566001)(85852003)(77982001)(94946001)(94316002)(59766001)(79102001)(76786001)(76576001)(97336001)(81542001)(2656002)(33646001)(81342001)(83072002)(87266001)(87936001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB300;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:B84CF75A.8CF26D26.B07FBFE7.43FAFAD9.2029C;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Jiri Kosina [mailto:jkosina@suse.cz]
> Sent: Friday, March 28, 2014 6:43 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> benjamin.tissoires@redhat.com; dh.herrmann@gmail.com
> Subject: Re: [PATCH 1/1] Drivers: hid: hid-hyperv: Implement a stub
> raw_request() entry point
> 
> On Fri, 28 Mar 2014, K. Y. Srinivasan wrote:
> 
> > commit 3c86726cfe38952f0366f86acfbbb025813ec1c2
> > Author: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > Date:   Thu Feb 20 15:24:49 2014 -0500
> >
> >     HID: make .raw_request mandatory
> >
> >     SET_REPORT and GET_REPORT are mandatory in the HID specification.
> >     Make the corresponding API in hid-core mandatory too, which removes
> the
> >     need to test against it in some various places.
> >
> >     Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >     Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
> >     Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> >
> > Made .raw_request mandatory and broke the Hyper-V mouse driver. This
> > patch fixes the problem.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/hid/hid-hyperv.c |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c index
> > c24908f..89a9234 100644
> > --- a/drivers/hid/hid-hyperv.c
> > +++ b/drivers/hid/hid-hyperv.c
> > @@ -460,12 +460,22 @@ static void mousevsc_hid_stop(struct hid_device
> > *hid)  {  }
> >
> > +static int mousevsc_hid_raw_request(struct hid_device *hid,
> > +				    unsigned char report_num,
> > +				    __u8 buf, size_t len,
> 
> This should be __u8 *buf. I have fixed that and applied.

Thanks Jiri,

K. Y
> 
> --
> Jiri Kosina
> SUSE Labs
