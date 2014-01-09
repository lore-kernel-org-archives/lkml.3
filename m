Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbaAISBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:01:46 -0500
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:46499
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752814AbaAISBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:01:38 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: hv: Implement the file copy service
Thread-Topic: [PATCH 1/1] Drivers: hv: Implement the file copy service
Thread-Index: AQHPDMVZ9zrtMOoYp0KOm7oSIbZbR5p8TC2AgABjvCA=
Date: Thu, 9 Jan 2014 18:01:21 +0000
Message-ID: <35fb9cd2070242f1b1f5f5c44e6d1438@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1389224915-8737-1-git-send-email-kys@microsoft.com>
 <20140109120351.GA25423@aepfle.de>
In-Reply-To: <20140109120351.GA25423@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.174.216]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(377454003)(24454002)(51704005)(199002)(189002)(13464003)(92566001)(81686001)(66066001)(54356001)(51856001)(59766001)(77982001)(79102001)(54316002)(46102001)(56776001)(76482001)(53806001)(81816001)(80022001)(65816001)(63696002)(74876001)(85306002)(74316001)(90146001)(56816005)(33646001)(85852003)(74366001)(83072002)(87936001)(2656002)(74706001)(76576001)(76786001)(76796001)(87266001)(4396001)(49866001)(47736001)(47976001)(50986001)(81542001)(80976001)(19580405001)(19580395003)(83322001)(69226001)(74662001)(47446002)(81342001)(74502001)(31966008)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB297;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:131.107.174.216;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s09I1oe2003891



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Thursday, January 09, 2014 4:04 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: hv: Implement the file copy service
> 
> On Wed, Jan 08, K. Y. Srinivasan wrote:
> 
> > +++ b/tools/hv/hv_fcopy_daemon.c
> 
> > +		len = pread(fcopy_fd, buffer, (4096 * 2), 0);
> > +
> > +		if (len <= 0) {
> > +			syslog(LOG_ERR, "Read error: %s\n", strerror(errno));
> > +			continue;
> 
> This could flood syslog. I think the error should be logged just once.
> Maybe like this:
> 
>         if (len <=0) {
>                 if (!error) {
>                         syslog(...);
>                         error = HV_ERROR_NOT_SUPPORTED;
>                 }
>                 continue;
>         }
> 
> > +		}
> > +		in_msg = (struct hv_fcopy_hdr *)buffer;
> > +
> > +		switch (in_msg->operation) {
> > +		case START_FILE_COPY:
> > +			error = hv_start_fcopy((struct hv_start_fcopy *)in_msg);

Will do. 

K. Y
> 
> Olaf
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
