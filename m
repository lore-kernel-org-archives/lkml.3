Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbaGITxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:53:00 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:18562
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754666AbaGITw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:52:58 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Thread-Topic: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Thread-Index: AQHPmwbc2vh72TcerE+9u7O+On3hT5uXbYYAgACybAA=
Date: Wed, 9 Jul 2014 19:52:54 +0000
Message-ID: <a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-4-git-send-email-kys@microsoft.com>
 <20140709084300.GD6012@infradead.org>
In-Reply-To: <20140709084300.GD6012@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0267E514F9
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(199002)(51704005)(189002)(13464003)(377454003)(24454002)(64706001)(4396001)(106116001)(93886003)(101416001)(19580395003)(76176999)(87936001)(106356001)(83072002)(80022001)(54356999)(46102001)(19580405001)(31966008)(83322001)(2656002)(99396002)(50986999)(99286002)(92566001)(81342001)(95666004)(105586002)(76482001)(86612001)(74316001)(21056001)(74502001)(66066001)(85306003)(81542001)(20776003)(85852003)(79102001)(33646001)(107046002)(74662001)(86362001)(76576001)(77982001)(110136001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, July 9, 2014 1:43 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> apw@canonical.com; linux-scsi@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
> 
> On Tue, Jul 08, 2014 at 05:46:48PM -0700, K. Y. Srinivasan wrote:
> > Host does not handle WRITE_SAME_16; filter this command out. This
> > patch is required to handle large devices (greater than 2 TB disks).
> 
> Storvsc already sets the no_write_same flag, where is the command coming
> from?

In spite of this flag,  I see WRITE_SAME_16 being issued when I format a device bigger than 2 TB;
I tried both xfs and ext4. Windows hosts currently do not handle unsupported commands correctly -
The information returned is not sufficient to effect recovery in the Linux guest. While this may be addressed in
future hosts, this patch fixes the problem.

K. Y
