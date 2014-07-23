Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbaGWPjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:39:22 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:15447
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757966AbaGWPjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:39:21 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Thread-Topic: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Thread-Index: AQHPpS/NDcbvaizdgkyl0kJjZb6qA5utcLIAgABctGA=
Date: Wed, 23 Jul 2014 15:39:16 +0000
Message-ID: <c8cff1e18d9c456ea98ada869fe4b2bf@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <20140723100448.GA2540@sucs.org>
In-Reply-To: <20140723100448.GA2540@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(24454002)(13464003)(51704005)(377454003)(199002)(189002)(19580405001)(101416001)(85852003)(92566001)(31966008)(80022001)(81542001)(33646002)(1411001)(15202345003)(46102001)(21056001)(81342001)(83322001)(83072002)(87936001)(86612001)(66066001)(77982001)(20776003)(99396002)(19580395003)(86362001)(2656002)(74502001)(79102001)(15975445006)(15395725005)(85306003)(74316001)(106356001)(74662001)(76576001)(77096002)(99286002)(95666004)(76482001)(64706001)(110136001)(50986999)(107046002)(106116001)(105586002)(4396001)(76176999)(54356999)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0712;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Wednesday, July 23, 2014 3:05 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; apw@canonical.com;
> jasowang@redhat.com; jbottomley@parallels.com; hch@infradead.org;
> linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
> 
> On Mon, Jul 21, 2014 at 04:06:01PM -0700, K. Y. Srinivasan wrote:
> > Add blist flags to permit the reading of the VPD pages even when the
> > target may claim SPC-2 compliance. MSFT targets currently claim SPC-2
> > compliance while they implement post SPC-2 features.
> > With this patch we can correctly handle WRITE_SAME_16 issues.
> 
> OK I've just seen this as I was about to post a similar patch to get discard
> going on Hyper-V. Will your patches handle Hyper-V pass through devices
> that support discard? The SSD I have here reports the following in the Linux

It should. Hyper-V does support pass through devices.

K. Y
> VM:
> 
> # sg_vpd -p lbpv  /dev/sdc
> Logical block provisioning VPD page (SBC):
>   Unmap command supported (LBPU): 1
>   Write same (16) with unmap bit supported (LBWS): 0
>   Write same (10) with unmap bit supported (LBWS10): 0
>   Logical block provisioning read zeros (LBPRZ): 0
>   Anchored LBAs supported (ANC_SUP): 1
>   Threshold exponent: 0
>   Descriptor present (DP): 0
>   Provisioning type: 0
> 
> # sg_readcap -l /dev/sdc
> Read Capacity results:
>    Protection: prot_en=0, p_type=0, p_i_exponent=0
>    Logical block provisioning: lbpme=0, lbprz=0
>    Last logical block address=234441647 (0xdf94baf), Number of logical
> blocks=234441648
>    Logical block length=512 bytes
>    Logical blocks per physical block exponent=0
>    Lowest aligned logical block address=0
> Hence:
>    Device size: 120034123776 bytes, 114473.5 MiB, 120.03 GB
> 
> --
> Sitsofe | http://sucs.org/~sits/
