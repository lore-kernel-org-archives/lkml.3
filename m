Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaLRBp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 20:45:29 -0500
Received: from mail-by2on0135.outbound.protection.outlook.com ([207.46.100.135]:64544
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751252AbaLRBp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 20:45:28 -0500
From: Dudley Du <dudl@cypress.com>
To: Jeremiah Mahler <jmmahler@gmail.com>, DuDudley <dudlx@outlook.com>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Solda <dso@cypress.com>
Subject: RE: [PATCH v16 01/12] input: cyapa: re-design driver to support
Thread-Topic: [PATCH v16 01/12] input: cyapa: re-design driver to support
Thread-Index: AdAZ3moPZDW6X3ZuSs2FUqtqBLB2qAAA9cUAAAE5/dAAAw97gAADXSQAAAJ7iYAAFebVcA==
Date: Thu, 18 Dec 2014 01:45:24 +0000
Message-ID: <BN1PR06MB0706683F43D01A545F0EB21D16A0@BN1PR06MB070.namprd06.prod.outlook.com>
References: <BAY407-EAS4239EB7A931AAE7C4C747F3BD6D0@phx.gbl>
 <20141217101434.GA2155@newt.localdomain>
 <BN1PR06MB0702F0782A3A6B975EDA156D16D0@BN1PR06MB070.namprd06.prod.outlook.com>
 <20141217121719.GA7134@hudson.localdomain>
 <BAY176-W39AFAEB1037657BD495F30BD6D0@phx.gbl>
 <20141217150443.GB3895@newt.localdomain>
In-Reply-To: <20141217150443.GB3895@newt.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1080;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1080;
x-forefront-prvs: 042957ACD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51914003)(51164003)(189002)(164054003)(13464003)(46034005)(45914002)(199003)(51704005)(50986999)(62966003)(97736003)(102836002)(21056001)(4396001)(105586002)(19580405001)(86362001)(54206007)(54606007)(68736005)(101416001)(87936001)(74316001)(40100003)(77156002)(120916001)(99286002)(99396003)(107046002)(92566001)(46102003)(66066001)(76176999)(76576001)(106356001)(33656002)(122556002)(93886004)(20776003)(31966008)(64706001)(19580395003)(54356999)(2900100001)(2656002)(2950100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1080;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jeremiah Mahler [mailto:jmmahler@gmail.com]
> Sent: 2014?12?17? 23:05
> To: DuDudley
> Cc: Dudley Du; dmitry.torokhov@gmail.com; rydberg@euromail.se;
> bleung@google.com; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org;
> David Solda
> Subject: Re: [PATCH v16 01/12] input: cyapa: re-design driver to support
>
> Dudley,
>
> On Wed, Dec 17, 2014 at 01:53:38PM +0000, DuDudley wrote:
> >
> >
> > > Date: Wed, 17 Dec 2014 04:17:19 -0800
> > > From: jmmahler@gmail.com
> > > To: dudl@cypress.com
> > > CC: dudlx@outlook.com; dmitry.torokhov@gmail.com; rydberg@euromail.se;
> bleung@google.com; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org;
> dso@cypress.com
> > > Subject: Re: [PATCH v16 01/12] input: cyapa: re-design driver to support
> > >
> > > Dudley,
> > >
> > > On Wed, Dec 17, 2014 at 10:55:00AM +0000, Dudley Du wrote:
> > > > Jeremiah,
> > > >
> > > > Thanks for the feedback.
> > > > Yes, the our net proxy may broken this. It needs sometime to fix this.
> > > >
> > > > Attched are the patch files, could you try to apply these patch files firstly.
> > > >
> > > > Thanks,
> > > > Dudley
> > > >
> > >
> > > Attachments are difficult to comment on [1].  Just re-send the series
> > > when you can format them properly.
> > Sorry, I cannot fix it today. I need IT help to try to fix this tommorrow.
>
> That is fine.  What do you normally use to send your patches?  I use
> git send-email after creating a series with git format-patch and it has
> always worked well.

Yes, I also use git format-path and git send-email to create and send patches.
This working fine during several months, but stop working on this Wednesday when I do same as before. :(
The connect to smtp.gmail.com is blocked (connection refused always).
I will talk with IT to find out the problem.

>
> > >
> > >   [1]: linux/Documentation/SubmittingPatches
> > >
> > > [...]
> > >
> > > --
> > > - Jeremiah Mahler
> >
>
> --
> - Jeremiah Mahler

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
