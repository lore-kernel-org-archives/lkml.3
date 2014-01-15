Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaAOTLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 14:11:11 -0500
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:23126
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752120AbaAOTLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 14:11:09 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Thread-Topic: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Thread-Index: AQHPEVjnKHWBxAK/ME2641uqAhZ1vZqF/DsAgAAryDA=
Date: Wed, 15 Jan 2014 19:11:05 +0000
Message-ID: <7d05d0da979343979b7bcdd7896b2c95@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1389728116-21337-1-git-send-email-kys@microsoft.com>
 <20140115163304.GA31066@aepfle.de>
In-Reply-To: <20140115163304.GA31066@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::3]
x-forefront-prvs: 00922518D8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(779001)(679001)(689001)(51704005)(377454003)(24454002)(13464003)(199002)(189002)(47446002)(76796001)(74502001)(76786001)(31966008)(74662001)(76576001)(85306002)(51856001)(69226001)(85852003)(81342001)(65816001)(80022001)(63696002)(79102001)(2656002)(77982001)(54316002)(59766001)(87936001)(81686001)(56776001)(87266001)(81542001)(80976001)(19580395003)(19580405001)(83322001)(81816001)(56816005)(90146001)(83072002)(46102001)(33646001)(74876001)(93136001)(53806001)(92566001)(74706001)(47976001)(76482001)(47736001)(49866001)(74316001)(50986001)(74366001)(54356001)(4396001)(93516002)(3826001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:2001:4898:80e0:ee43::3;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0FJBHFO011035



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Wednesday, January 15, 2014 8:33 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
> 
> On Tue, Jan 14, K. Y. Srinivasan wrote:
> 
> > +static int hv_start_fcopy(struct hv_start_fcopy *smsg)
> 
> > +	if (access((char *)smsg->path_name, F_OK)) {
> > +		if (smsg->copy_flags & CREATE_PATH) {
> > +			if (mkdir((char *)smsg->path_name, 0755)) {
> 
> KY,
> 
> I guess this needs a loop over every path compoment to implement
> 'mkdir -p', if the "-CreateFullPath" option is used?

Yes; I will make the change. The good news is that for the destination path and file name,
the host does not interpret the path components.

Regards,

K. Y
> 
> Hopefully "-DestinationPath" is an arbitrary string and does not require
> some sort of C: prefix. ;-)
> 
> 
> Olaf
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
