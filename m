Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaJKUCe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 16:02:34 -0400
Received: from mail-by2on0117.outbound.protection.outlook.com ([207.46.100.117]:21429
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751006AbaJKUCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 16:02:31 -0400
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@infradead.org>
CC: Sitsofe Wheeler <sitsofe@gmail.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Thread-Topic: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Thread-Index: AQHP5F6vAKuuUZSVZE66AaSXedI4EpwrK8AAgAAAzICAACKA4A==
Date: Sat, 11 Oct 2014 19:48:10 +0000
Message-ID: <b0069f11bbe64ebc8c9981ea90429014@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20141010074901.GA32028@sucs.org>
	 <20141011173902.GA1946@infradead.org> <1413049313.2068.48.camel@jarvis.lan>
In-Reply-To: <1413049313.2068.48.camel@jarvis.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2601:8:9b00:fd:350e:59dd:eb8b:ea6f]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0711;UriScan:;
x-forefront-prvs: 0361212EA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(13464003)(199003)(377454003)(377424004)(189002)(24454002)(50986999)(54356999)(101416001)(31966008)(76176999)(19580395003)(20776003)(40100003)(19580405001)(64706001)(21056001)(122556002)(85852003)(4396001)(87936001)(2656002)(74316001)(95666004)(99286002)(97736003)(80022003)(105586002)(106116001)(76576001)(106356001)(33646002)(85306004)(46102003)(99396003)(108616004)(77096002)(76482002)(86362001)(107046002)(86612001)(92566001)(120916001)(3826002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0645;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9BK2dln011187



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Saturday, October 11, 2014 10:42 AM
> To: Christoph Hellwig
> Cc: Sitsofe Wheeler; KY Srinivasan; Haiyang Zhang; Christoph Hellwig; Hannes
> Reinecke; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
> 
> On Sat, 2014-10-11 at 10:39 -0700, Christoph Hellwig wrote:
> > On Fri, Oct 10, 2014 at 08:49:01AM +0100, Sitsofe Wheeler wrote:
> > > Microsoft Hyper-V virtual disks currently only claim SPC-2
> > > compliance even though they implement post SPC-2 features (such as
> > > thin
> > > provisioning) which means the Linux kernel does not go on to test
> > > for those features even though they are advertised.
> > >
> > > A previous patch attempted to add a quirk to workaround this but the
> > > quirk was only enabled after the features had been scanned for,
> > > wouldn't work for "small" disks and would quirk on  all Hyper-V SCSI
> > > devices (e.g. passthrough disks).
> > >
> > > The new patches partially revert the previous effort, add the quirk
> > > in a more traditional manner to only Hyper-V virtual disks and work
> > > on small virtual disks.
> >
> > This seems like might want a quirk to simply "force" a SPC3 compliance
> > level?
> 
> This was initially suggested, but rejected by Microsoft because of other
> problems advertising SPC-3 compliance brings.  Perhaps the hyper-v
> emulator has matured sufficiently that it will now work OK?

James,

On the current release of Windows (windows 10), we are advertising SPC3 compliance.
We are ok with declaring compliance to SPC3 in our drivers. 

Regards,

K. Y


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
