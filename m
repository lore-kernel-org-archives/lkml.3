Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaGKVER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:04:17 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:20755
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753291AbaGKVEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:04:15 -0400
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
Subject: RE: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
Thread-Topic: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
Thread-Index: AQHPmwbgHQRbrGSDW0yYxe5G8grckJuZGqCAgADG0hA=
Date: Fri, 11 Jul 2014 21:03:52 +0000
Message-ID: <f7789b309ce84187b64760e3885f7cfa@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-7-git-send-email-kys@microsoft.com>
 <20140710101849.GD1151@infradead.org>
In-Reply-To: <20140710101849.GD1151@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.174.207]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 02698DF457
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(13464003)(377454003)(189002)(199002)(19580405001)(76576001)(76482001)(81542001)(46102001)(92566001)(107046002)(74502001)(86612001)(21056001)(93886003)(85306003)(31966008)(83322001)(77982001)(64706001)(83072002)(4396001)(87936001)(79102001)(50986999)(81342001)(101416001)(20776003)(80022001)(74316001)(33646001)(2656002)(95666004)(76176999)(110136001)(99286002)(86362001)(106356001)(105586002)(19580395003)(54356999)(85852003)(106116001)(74662001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB300;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, July 10, 2014 3:19 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> apw@canonical.com; linux-scsi@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
> 
> >  	default:
> >  		vm_srb->data_in = UNKNOWN_TYPE;
> > -		vm_srb->win8_extension.srb_flags = 0;
> > +		vm_srb->win8_extension.srb_flags |=
> (SRB_FLAGS_DATA_IN |
> > +						     SRB_FLAGS_DATA_OUT);
> 
> This would usually be a command that doesn't transfer data (e.g.
> TEST_UNIT_READY or SYNCHRONIZE_CACHE), do you really want to set the in
> and out flags here?

On the host, before they forward the command to the native driver stack, I am told they validate that the flags be correctly set because of some bugs in the Emulex driver.

K. Y
