Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbaJUSah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:30:37 -0400
Received: from mail-bl2on0126.outbound.protection.outlook.com ([65.55.169.126]:38272
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755131AbaJUSaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:30:35 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: Jeff Leung <jleung@v10networks.ca>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@infradead.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Christoph Hellwig" <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Thread-Topic: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Thread-Index: AQHP5F6vAKuuUZSVZE66AaSXedI4EpwrK8AAgAAAzICAACKA4IAAB8PAgABTMeCADmEIAIAA4aEA
Date: Tue, 21 Oct 2014 18:30:30 +0000
Message-ID: <c7c3284a40234f399b653d199a39e92b@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20141010074901.GA32028@sucs.org>
 <20141011173902.GA1946@infradead.org> <1413049313.2068.48.camel@jarvis.lan>
 <b0069f11bbe64ebc8c9981ea90429014@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <A70AC0C1B7E7FD478A6BF19705461AA01109B3@IMBER.smb.curriegrad2004.ca>
 <da5106ddc725481784ed12bccb594980@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20141021044550.GC11691@sucs.org>
In-Reply-To: <20141021044550.GC11691@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:4898:80e8:ee31::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0709;UriScan:;
x-forefront-prvs: 0371762FE7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(24454002)(189002)(13464003)(377454003)(2656002)(87936001)(85852003)(120916001)(99396003)(31966008)(105586002)(40100003)(33646002)(122556002)(107046002)(77096002)(99286002)(106356001)(95666004)(106116001)(76576001)(76482002)(74316001)(50986999)(101416001)(108616004)(46102003)(80022003)(93886004)(85306004)(575784001)(86362001)(110136001)(64706001)(86612001)(97736003)(20776003)(92566001)(15975445006)(54356999)(4396001)(1411001)(19580405001)(15395725005)(76176999)(19580395003)(21056001)(15202345003)(3826002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0709;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0760;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9LIUiup002014



> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Monday, October 20, 2014 9:46 PM
> To: KY Srinivasan
> Cc: Jeff Leung; James Bottomley; Christoph Hellwig; Haiyang Zhang; Christoph
> Hellwig; Hannes Reinecke; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
> 
> On Sun, Oct 12, 2014 at 01:21:01AM +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: Jeff Leung [mailto:jleung@v10networks.ca]
> > > Sent: Saturday, October 11, 2014 1:22 PM
> > >
> > > > On the current release of Windows (windows 10), we are advertising
> > > > SPC3 compliance.
> > > > We are ok with declaring compliance to SPC3 in our drivers.
> > > If you are going to declare SPC3 compliance in the drivers, are you
> > > going to put in checks to ensure that SPC-3 compliance doesn't get
> > > accidentally enabled for hypervisors below Win10?
> > >
> > > I do know for a fact that Ubuntu's kernels already force SPC3
> > > compliance to enable specific features such as TRIM on earlier
> > > versions of Hyper-V (Namely Hyper-V 2012 and 2012 R2).
> > You are right; Ubuntu has been carrying a patch  that was doing just
> > this and this has been working without any issues on many earlier
> > versions of Windows. (2012 and 2012 R2).  On windows 10 we don't need
> > any changes in the Linux driver as the host itself is advertising SPC3
> > compliance. Based on the testing we have done with Ubuntu, we are
> > comfortable picking up that patch.
> 
> OK this seems to be the patch currently carried by Ubuntu:
> 
> From ff2c5fa3fa9adf0b919b9425e71a8ba044c31a7d Mon Sep 17 00:00:00 2001
> From: Andy Whitcroft <apw@canonical.com>
> Date: Fri, 13 Sep 2013 17:49:16 +0100
> Subject: [PATCH] scsi: hyper-v storsvc switch up to SPC-3
> 
> Suggested-By: James Bottomley
> <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---
>  drivers/scsi/storvsc_drv.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> 9969fa1..3903c8a 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1441,6 +1441,14 @@ static int storvsc_device_configure(struct
> scsi_device *sdevice)
> 
>  	sdevice->no_write_same = 1;
> 
> +	/*
> +	 * hyper-v lies about its capabilities indicating it is only SPC-2
> +	 * compliant, but actually implements the core SPC-3 features.
> +	 * If we pretend to be SPC-3, we send RC16 which activates trim and
> +	 * will query the appropriate VPD pages to enable trim.
> +	 */
> +	sdevice->scsi_level = SCSI_SPC_3;
> +
>  	return 0;
>  }
> 
> --
> 1.7.9.5
> 
> (Downloaded from
> http://kernel.ubuntu.com/git?p=jsalisbury/stable/trusty/ubuntu-
> trusty.git;a=patch;h=ff2c5fa3fa9adf0b919b9425e71a8ba044c31a7d
> ).
> 
> I think it's unwise to override the scsi_level at this particular point because
> you are going to do it for ALL Hyper-V "disks" (perhaps all Hyper-V SCSI
> devices?)...

I agree with you. I was only referring virtual hard disks (VHDs) being presented to the guest and
not pass-through devices. Furthermore, we would fix up the scsi conformance level based on the
version of the host we are running on.

Regards,

K. Y
> 
> Here's the SCSI inquiry information reported by a USB 2 hard disk being
> passed passed-through by one of my 2012 R2 hosts:
> 
> # sg_inq /dev/sdc
> standard INQUIRY:
>   PQual=0  Device_type=0  RMB=0  version=0x02  [SCSI-2]
>   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=1
>   SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
>   EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
>   [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=0
>     length=36 (0x24)   Peripheral device type: disk
>  Vendor identification: MDT MD50
>  Product identification: 00AAKS-00TMA0
>  Product revision level:
> 
> Is it OK to replace a scsi_level of SCSI-2 with SCSI_SPC_3? Additionally is it
> also OK to force SCSI_SPC_3 on Hyper-V 2008?
> 
> > > > NryØ²XvØ–){nÇ‰{zX}zj:v zZzf~zwÚ¢)jyA
> > > >
> > > > i
> > N?????r??y????b?X??Ç§v?^?)Şº{.n?+????{????zX????Ü¨}???Æ z?&j:+v???
> ????zZ+??+zf???h???~????i???z??w?????????&?)ß¢f??^jÇ«y?m??@A?a??
> ?
> 
> 0??h???i
> 
> ^^^ Where do these characters come from? I've occasionally seen them on
> emails from other Microsoft folks posting to LKML too...
> 
> --
> Sitsofe | http://sucs.org/~sits/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
