Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaANXMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:12:31 -0500
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:27216
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751384AbaANXM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:12:27 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Thread-Topic: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Thread-Index: AQHPEVjnKHWBxAK/ME2641uqAhZ1vZqEyPuAgAAP8pA=
Date: Tue, 14 Jan 2014 23:12:25 +0000
Message-ID: <9727e8776e9542b0bc4576cb9f9a6248@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1389728116-21337-1-git-send-email-kys@microsoft.com>
 <20140114221323.GA16960@aepfle.de>
In-Reply-To: <20140114221323.GA16960@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ed43::2]
x-forefront-prvs: 0091C8F1EB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(679001)(779001)(689001)(164054003)(189002)(199002)(51704005)(24454002)(13464003)(377454003)(53806001)(93136001)(74706001)(92566001)(74876001)(54356001)(4396001)(74366001)(76482001)(47736001)(49866001)(47976001)(50986001)(74316001)(46102001)(33646001)(51856001)(85306002)(81342001)(69226001)(85852003)(74662001)(76786001)(76576001)(74502001)(47446002)(76796001)(31966008)(80976001)(19580395003)(19580405001)(83322001)(81542001)(83072002)(90146001)(56816005)(81816001)(79102001)(2656002)(87266001)(65816001)(63696002)(80022001)(81686001)(87936001)(56776001)(59766001)(77982001)(54316002)(3826001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:2001:4898:80e0:ed43::2;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0ENCeuB004276



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Tuesday, January 14, 2014 2:13 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
> 
> On Tue, Jan 14, K. Y. Srinivasan wrote:
> 
> 
> > +static ssize_t fcopy_write(struct file *file, const char __user *buf,
> > +			size_t count, loff_t *ppos)
> > +{
> > +	int error = 0;
> > +
> > +	if (count != sizeof(int))
> > +		return 0;
> > +
> > +	if (copy_from_user(&error, buf, sizeof(int)))
> > +		return -EFAULT;
> > +
> > +	if (in_hand_shake) {
> > +		fcopy_handle_handshake();
> > +		return 0;
> > +	}
> 
> 
> > +	/*
> > +	 * Register with the kernel.
> > +	 */
> > +	write(fcopy_fd, &version, sizeof(int));
> 
> 
> Shouldnt there be some version check already even in this initial
> implementation? What if there will be a newer daemon running on an older
> kernel?

Currently, the daemon registers with the kernel passing its version number. I will make the
version check "real".

Thanks,

K. Y
> 
> Olaf
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
