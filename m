Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaJLBVK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 21:21:10 -0400
Received: from mail-bl2on0113.outbound.protection.outlook.com ([65.55.169.113]:26058
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752103AbaJLBVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 21:21:08 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Jeff Leung <jleung@v10networks.ca>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@infradead.org>
CC: Sitsofe Wheeler <sitsofe@gmail.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Thread-Topic: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Thread-Index: AQHP5F6vAKuuUZSVZE66AaSXedI4EpwrK8AAgAAAzICAACKA4IAAB8PAgABTMeA=
Date: Sun, 12 Oct 2014 01:21:01 +0000
Message-ID: <da5106ddc725481784ed12bccb594980@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20141010074901.GA32028@sucs.org>
 <20141011173902.GA1946@infradead.org> <1413049313.2068.48.camel@jarvis.lan>
 <b0069f11bbe64ebc8c9981ea90429014@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <A70AC0C1B7E7FD478A6BF19705461AA01109B3@IMBER.smb.curriegrad2004.ca>
In-Reply-To: <A70AC0C1B7E7FD478A6BF19705461AA01109B3@IMBER.smb.curriegrad2004.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [131.107.159.166]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 0362BF9FDB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(6009001)(199003)(377454003)(189002)(13464003)(51704005)(19580395003)(105586002)(76576001)(46102003)(107046002)(99286002)(108616004)(33646002)(92566001)(19580405001)(106116001)(50986999)(80022003)(86362001)(106356001)(4396001)(122556002)(54356999)(85306004)(76176999)(77096002)(101416001)(95666004)(93886004)(20776003)(87936001)(76482002)(2656002)(21056001)(99396003)(31966008)(120916001)(86612001)(97736003)(85852003)(66066001)(74316001)(64706001)(40100003)(24736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:ovrnspm;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9C1LXFP011686



> -----Original Message-----
> From: Jeff Leung [mailto:jleung@v10networks.ca]
> Sent: Saturday, October 11, 2014 1:22 PM
> To: KY Srinivasan; James Bottomley; Christoph Hellwig
> Cc: Sitsofe Wheeler; Haiyang Zhang; Christoph Hellwig; Hannes Reinecke;
> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: RE: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
> 
> > On the current release of Windows (windows 10), we are advertising SPC3
> compliance.
> > We are ok with declaring compliance to SPC3 in our drivers.
> If you are going to declare SPC3 compliance in the drivers, are you going to
> put in checks to ensure that SPC-3 compliance doesn't get accidentally
> enabled for hypervisors below Win10?
> 
> I do know for a fact that Ubuntu's kernels already force SPC3 compliance to
> enable specific features such as TRIM on earlier versions of Hyper-V (Namely
> Hyper-V 2012 and 2012 R2).

You are right; Ubuntu has been carrying a patch  that was doing just this and this has been
working without any issues on many earlier versions of Windows. (2012 and 2012 R2).
On windows 10 we don't need any changes in the Linux driver as the host itself is
advertising SPC3 compliance. Based on the testing we have done with Ubuntu, we are
comfortable picking up that patch.

Regards,

K. Y    
> 
> --Jeff
> 
> > Regards,
> >
> > K. Y
> >
> >
> > NryØ²XvØ–){nÇ‰{zX}zj:v zZzf~zwÚ¢)jyA
> >
> > i
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
