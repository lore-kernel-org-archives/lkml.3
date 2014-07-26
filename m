Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaGZNm7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 09:42:59 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:23184
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750810AbaGZNmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 09:42:51 -0400
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <jbottomley@parallels.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "sitsofe@gmail.com" <sitsofe@gmail.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Thread-Topic: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Thread-Index: AQHPpznyfmLHK0GnrkSEOCNbbvYH8ZuvP1KVgAAcOACAAAU+74ABn+twgAAHZgCAAVfFUA==
Date: Sat, 26 Jul 2014 13:42:46 +0000
Message-ID: <739c32de010444499fea6f5f47ca948d@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20140724122223.GA31798@sucs.org>
	 <yq1iommkgkv.fsf@sermon.lab.mkp.net> <20140724153612.GA23648@sucs.org>
	 <yq1egxakb0z.fsf@sermon.lab.mkp.net>
	 <16fea5bb87ba47019527cee788e07a72@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <1406308203.1789.33.camel@jarvis.lan>
In-Reply-To: <1406308203.1789.33.camel@jarvis.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(199002)(51914003)(24454002)(377424004)(377454003)(13464003)(51704005)(74662001)(66066001)(110136001)(81342001)(93886003)(2656002)(33646002)(83322001)(77982001)(106116001)(106356001)(86612001)(107046002)(46102001)(21056001)(54356999)(31966008)(64706001)(85852003)(79102001)(83072002)(95666004)(92566001)(99396002)(76576001)(4396001)(81542001)(19580395003)(74316001)(19580405001)(74502001)(76176999)(80022001)(99286002)(87936001)(85306003)(76482001)(105586002)(77096002)(86362001)(20776003)(50986999)(101416001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6QDh7d1005744



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Friday, July 25, 2014 10:10 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; hch@infradead.org; sitsofe@gmail.com;
> devel@linuxdriverproject.org; apw@canonical.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org;
> ohering@suse.com; gregkh@linuxfoundation.org; jasowang@redhat.com
> Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
> 
> On Fri, 2014-07-25 at 16:47 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> > > Sent: Thursday, July 24, 2014 8:54 AM
> > > To: Sitsofe Wheeler
> > > Cc: Martin K. Petersen; Christoph Hellwig; KY Srinivasan;
> > > gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; ohering@suse.com; apw@canonical.com;
> > > jasowang@redhat.com; jbottomley@parallels.com; linux-
> > > scsi@vger.kernel.org
> > > Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks
> > > tests
> > >
> > > >>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:
> > >
> > > Sitsofe> So we can see it is really a SATA device that announces
> > > Sitsofe> discard correctly and supports discard through WRITE_SAME(16).
> > >
> > > No, that's the SATA device that announces support for DSM TRIM, and
> > > as a result the Linux SATL reports support for WRITE SAME(16) w. the
> > > UNMAP bit set and LBPME.
> > >
> > > Sitsofe> It is the act of passing it through Hyper-V that turned it
> > > Sitsofe> into a SCSI device that supports UNMAP (but not
> > > Sitsofe> WRITE_SAME(16)), doesn't announce its SCSI conformance
> > > Sitsofe> number and doesn't correctly announce which features it
> > > Sitsofe> supports. Surely in this case it's reasonable to quirk our way
> around the problem?
> > >
> > > No. That's an issue in Hyper-V that'll you'll have to take up with
> > > Microsoft. I don't know what their passthrough limitations are for SCSI-
> ATA translation.
> > > Maybe K. Y. has some insight into this?
> >
> > For the pass through case, the host validates the request and passes
> > the request to the device.
> > However, not all scsi commands are passed through even though the
> > device it is being passed through may support the command. WRITE_SAME
> > is one such command. Consequently, in the EVPD page, we will set state
> > indicating that WRITE_SAME is not supported (even if the device
> > supports it).
> 
> I think you haven't appreciated the problem: He's passing a SATA SSD via the
> SCSI hyper-v interface.  That means that the windows host is doing SCSI<-
> >ATA translation.  The problem is that the Windows translation layer (SATL)
> looks to be incomplete and it's not correctly translating the IDENTIFY bit that
> corresponds to TRIM to the correct VPD pages so consequently, Linux  won't
> send UNMAP commands to the device (to be translated back to TRIM).
> 
> We already know this is a bug in the Windows SATL which needs fixing (if you
> could report it and get a fix, that would be great) and that we're not going to
> be able to work around this automatically in Linux because the proposed
> patch would have us unconditionally try UNMAP for all Hyper-V devices.  The
> current proposed fix is to enable UNMAP manually via sysfs in the guest boot
> scripts, but obviously that means that Hyper-V guests with direct pass
> through of SSDs need operator intervention to turn on TRIM.

James,

Thanks for the clarification. I am talking to the folks in MSFT that develop the native scsi
stack on Windows. Hyper-V's back-end driver is not involved in SATL. I will keep you guys
posted.

Regards,

K. Y
> 
> James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
