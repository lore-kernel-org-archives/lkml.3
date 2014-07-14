Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaGNDWf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 23:22:35 -0400
Received: from [207.46.163.242] ([207.46.163.242]:57074 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752634AbaGNDW3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 23:22:29 -0400
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        James Bottomley <jbottomley@parallels.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Thread-Topic: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Thread-Index: AQHPnpon2vh72TcerE+9u7O+On3hT5ueWMnAgACC7zCAAAhFgA==
Date: Mon, 14 Jul 2014 03:19:53 +0000
Message-ID: <37d97111862a4d119bbad89eb1bfe6b9@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-4-git-send-email-kys@microsoft.com>
 <20140709084300.GD6012@infradead.org>
 <a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
 <1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
 <2f3ae589e6f149acbe4c5dd79f905971@BY2PR03MB299.namprd03.prod.outlook.com>
 <1404944843.2184.8.camel@dabdike.int.hansenpartnership.com>
 <20140711063216.GA20660@infradead.org>
 <328b7a6174ef4dd8a54a7db5ac959834@BY2PR03MB299.namprd03.prod.outlook.com>
 <yq1a98d2z5x.fsf@sermon.lab.mkp.net>
  <ba0ec0e3d04748eab3fb26e3c4964b4d@BY2PR03MB299.namprd03.prod.outlook.com>
In-Reply-To: <ba0ec0e3d04748eab3fb26e3c4964b4d@BY2PR03MB299.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02723F29C4
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(51704005)(13464003)(199002)(189002)(106116001)(93886003)(106356001)(105586002)(85306003)(31966008)(99286002)(95666004)(85852003)(92566001)(83072002)(33646001)(2656002)(4396001)(77096002)(101416001)(87936001)(74662001)(107046002)(2421001)(76576001)(76176999)(50986999)(54356999)(81542001)(80022001)(20776003)(64706001)(81342001)(76482001)(79102001)(77982001)(1511001)(66066001)(74502001)(74316001)(99396002)(15202345003)(46102001)(21056001)(86612001)(575784001)(19580395003)(83322001)(86362001)(19580405001)(15975445006)(108616002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: driverdev-devel-bounces@linuxdriverproject.org [mailto:driverdev-
> devel-bounces@linuxdriverproject.org] On Behalf Of KY Srinivasan
> Sent: Sunday, July 13, 2014 7:38 PM
> To: Martin K. Petersen
> Cc: linux-scsi@vger.kernel.org; jasowang@redhat.com; linux-
> kernel@vger.kernel.org; stable@vger.kernel.org; ohering@suse.com;
> hch@infradead.org; James Bottomley; apw@canonical.com;
> devel@linuxdriverproject.org
> Subject: RE: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
> 
> 
> 
> > -----Original Message-----
> > From: KY Srinivasan
> > Sent: Sunday, July 13, 2014 11:50 AM
> > To: 'Martin K. Petersen'
> > Cc: hch@infradead.org; James Bottomley; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; apw@canonical.com;
> > stable@vger.kernel.org; linux-scsi@vger.kernel.org; ohering@suse.com;
> > jasowang@redhat.com
> > Subject: RE: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
> >
> >
> >
> > > -----Original Message-----
> > > From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> > > Sent: Sunday, July 13, 2014 5:59 AM
> > > To: KY Srinivasan
> > > Cc: hch@infradead.org; James Bottomley;
> > > linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > > apw@canonical.com; stable@vger.kernel.org;
> > > linux-scsi@vger.kernel.org; ohering@suse.com; jasowang@redhat.com
> > > Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter
> > > WRITE_SAME_16
> > >
> > > >>>>> "KY" == KY Srinivasan <kys@microsoft.com> writes:
> > >
> > > KY> Windows hosts do support UNMAP and set the field in the EVPD.
> > > KY> However, since the host advertises SPC-2 compliance, Linux does
> > > KY> not even query the VPD page.
> > >
> > > >> If we want to enable UNMAP in this case I'd prefer a blacklist
> > > >> entry than trying UNMAP despite the device not advertising it.
> > >
> > > I agree with that. We could do something like the patch below.
> > >
> > > However, I do think it's a good idea that you guys are looking into
> > > reporting SPC-3.
> >
> > Thanks Martin; this patch would address our present issues. I will get
> > some testing done and report back.
> 
> How should we force the flag (BLIST_TRY_VPD_PAGES) to be set.

Once I force the flag set, it works. Thanks Martin.

K. Y
> 
> K. Y
> >
> > Regards,
> >
> > K. Y
> > >
> > >
> > > SCSI: Add a blacklist flag which enables VPD page inquiries
> > >
> > > Despite supporting modern SCSI features some storage devices
> > > continue to claim conformance to an older version of the SPC spec.
> > > This is done for compatibility with legacy operating systems.
> > >
> > > Linux by default will not attempt to read VPD pages on devices that
> > > claim
> > > SPC-2 or older. Introduce a blacklist flag that can be used to
> > > trigger VPD page inquiries on devices that are known to support them.
> > >
> > > Reported-by: KY Srinivasan <kys@microsoft.com>
> > > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> > >
> > > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > > index 4a6e4ba5a400..a5b1a224628a 100644
> > > --- a/drivers/scsi/scsi_scan.c
> > > +++ b/drivers/scsi/scsi_scan.c
> > > @@ -949,7 +949,9 @@ static int scsi_add_lun(struct scsi_device
> > > *sdev, unsigned char *inq_result,
> > >
> > >  	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;
> > >
> > > -	if (*bflags & BLIST_SKIP_VPD_PAGES)
> > > +	if (*bflags & BLIST_TRY_VPD_PAGES)
> > > +		sdev->try_vpd_pages = 1;
> > > +	else if (*bflags & BLIST_SKIP_VPD_PAGES)
> > >  		sdev->skip_vpd_pages = 1;
> > >
> > >  	transport_configure_device(&sdev->sdev_gendev);
> > > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c index
> > > 87566b51fcf7..31d32b9077ca 100644
> > > --- a/drivers/scsi/sd.c
> > > +++ b/drivers/scsi/sd.c
> > > @@ -2701,6 +2701,11 @@ static void sd_read_write_same(struct
> > > scsi_disk *sdkp, unsigned char *buffer)
> > >
> > >  static int sd_try_extended_inquiry(struct scsi_device *sdp)  {
> > > +	/* Attempt VPD inquiry if the device blacklist explicitly calls
> > > +	 * for it.
> > > +	 */
> > > +	if (sdp->try_vpd_pages)
> > > +		return 1;
> > >  	/*
> > >  	 * Although VPD inquiries can go to SCSI-2 type devices,
> > >  	 * some USB ones crash on receiving them, and the pages diff --git
> > > a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h index
> > > 9aa38f7b303b..f579408620f0 100644
> > > --- a/include/scsi/scsi_device.h
> > > +++ b/include/scsi/scsi_device.h
> > > @@ -155,6 +155,7 @@ struct scsi_device {
> > >  	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08
> > > */
> > >  	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f
> > > */
> > >  	unsigned skip_vpd_pages:1;	/* do not read VPD pages */
> > > +	unsigned try_vpd_pages:1;	/* attempt to read VPD pages */
> > >  	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page
> > 0x3f
> > > */
> > >  	unsigned no_start_on_add:1;	/* do not issue start on add */
> > >  	unsigned allow_restart:1; /* issue START_UNIT in error handler */
> > > diff --git a/include/scsi/scsi_devinfo.h
> > > b/include/scsi/scsi_devinfo.h index 8670c04e199e..1fdd6fc5492b
> > > 100644
> > > --- a/include/scsi/scsi_devinfo.h
> > > +++ b/include/scsi/scsi_devinfo.h
> > > @@ -34,4 +34,5 @@
> > >  #define BLIST_SKIP_VPD_PAGES	0x4000000 /* Ignore SBC-3 VPD pages
> > > */
> > >  #define BLIST_SCSI3LUN		0x8000000 /* Scan more than 256
> > > LUNs
> > >  					     for sequential scan */
> > > +#define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD
> > > pages */
> > >  #endif
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
