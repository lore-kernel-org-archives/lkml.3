Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaGJW0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:26:19 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:1988
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751684AbaGJW0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 18:26:17 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
Thread-Topic: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
Thread-Index: AQHPmwbaMJcVE9K7bk+ZFkv2/whfmJuXbd+AgACmi9CAAQSuAIAAzDFQ
Date: Thu, 10 Jul 2014 22:26:14 +0000
Message-ID: <f662b500fada4fbca75c55089d3f8ee4@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-6-git-send-email-kys@microsoft.com>
 <20140709084415.GF6012@infradead.org>
 <9b76360fb30745d3941b6d56bdae268f@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140710101320.GB1151@infradead.org>
In-Reply-To: <20140710101320.GB1151@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.160.237]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 0268246AE7
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(199002)(189002)(13464003)(377454003)(19580395003)(99396002)(50986999)(83322001)(92566001)(106116001)(2656002)(80022001)(19580405001)(54356999)(64706001)(101416001)(4396001)(93886003)(46102001)(99286002)(105586002)(74316001)(31966008)(85306003)(95666004)(86612001)(66066001)(74502001)(77982001)(21056001)(33646001)(81542001)(20776003)(85852003)(76576001)(86362001)(107046002)(83072002)(74662001)(106356001)(87936001)(81342001)(76176999)(110136001)(76482001)(79102001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, July 10, 2014 3:13 AM
> To: KY Srinivasan
> Cc: Christoph Hellwig; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; jasowang@redhat.com; apw@canonical.com;
> linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
> 
> 
> Note that you could increase the timeout and/or implement an
> eh_timed_out handler that just returns BLK_EH_RESET_TIMER, but if the
> completion takes too long the expectation is that a command will eventually
> finish instead of beeing delayed by an unmound amount.

I like this idea; I will implement a eh_timed_out_handler.

K. Y

