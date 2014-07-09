Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbaGIUDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:03:07 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:31571
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754252AbaGIUDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:03:05 -0400
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
Subject: RE: [PATCH 2/8] Drivers: scsi: storvsc: Filter commands based on the
 storage protocol version
Thread-Topic: [PATCH 2/8] Drivers: scsi: storvsc: Filter commands based on the
 storage protocol version
Thread-Index: AQHPmwbbUTIhTOHLiESspoyqTREKOJuXbPGAgAC+WvA=
Date: Wed, 9 Jul 2014 20:02:41 +0000
Message-ID: <c3b8b490725541afb2fb470a9e6d4348@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-2-git-send-email-kys@microsoft.com>
 <20140709084055.GB6012@infradead.org>
In-Reply-To: <20140709084055.GB6012@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0267E514F9
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(13464003)(24454002)(377454003)(189002)(199002)(81542001)(86612001)(74502001)(107046002)(79102001)(86362001)(105586002)(99286002)(76482001)(106356001)(92566001)(46102001)(99396002)(64706001)(19580405001)(83322001)(31966008)(93886003)(83072002)(76576001)(21056001)(85306003)(4396001)(81342001)(66066001)(77982001)(87936001)(50986999)(33646001)(20776003)(101416001)(80022001)(74316001)(95666004)(76176999)(106116001)(85852003)(19580395003)(54356999)(74662001)(110136001)(2656002)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB300;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, July 9, 2014 1:41 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> apw@canonical.com; linux-scsi@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH 2/8] Drivers: scsi: storvsc: Filter commands based on the
> storage protocol version
> 
> On Tue, Jul 08, 2014 at 05:46:46PM -0700, K. Y. Srinivasan wrote:
> > Going forward it is possible that some of the commands that are not
> > currently implemented will be implemented on future Windows hosts.
> > Make command filtering depend on the host version.
> 
> > +	if (vmstor_current_major <= VMSTOR_WIN8_MAJOR) {
> > +		/*
> > +		 * On legacy hosts filter unimplemented commands.
> > +		 */
> > +		if (!storvsc_scsi_cmd_ok(scmnd)) {
> > +			scmnd->scsi_done(scmnd);
> > +			return 0;
> > +		}
> 
> So post-Win8 versions don't need command filering as they can properly
> reject commands they don't understand?  If that's the case please state it in
> the patch description.

I will add the comments you have suggested.

K. Y
