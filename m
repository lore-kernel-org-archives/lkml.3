Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbaK0Ba5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 20:30:57 -0500
Received: from mail-bl2on0123.outbound.protection.outlook.com ([65.55.169.123]:47008
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753528AbaK0Baw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 20:30:52 -0500
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Alexander Graf <agraf@suse.de>, Jose Rivera <German.Rivera@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Kim Phillips <Kim.Phillips@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        "bhamciu1@freescale.com" <bhamciu1@freescale.com>,
        "R89243@freescale.com" <R89243@freescale.com>,
        Geoff Thorpe <Geoff.Thorpe@freescale.com>,
        "bhupesh.sharma@freescale.com" <bhupesh.sharma@freescale.com>,
        "nir.erez@freescale.com" <nir.erez@freescale.com>,
        Richard Schmitt <richard.schmitt@freescale.com>
Subject: RE: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex
 APIs
Thread-Topic: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex
 APIs
Thread-Index: AQHQCWH+izjvEAXJzUaTeK76eOkwuZxze4awgAAisQCAAAvfAA==
Date: Thu, 27 Nov 2014 01:15:38 +0000
Message-ID: <CY1PR0301MB0748E49FD0D2232858A3774F87710@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1415901246-24131-1-git-send-email-German.Rivera@freescale.com>
 <1415901246-24131-2-git-send-email-German.Rivera@freescale.com>
 <5475A85E.1080204@suse.de>
 <CY1PR0301MB0748850351477C53D47A042087700@CY1PR0301MB0748.namprd03.prod.outlook.com>
 <54766F36.3050104@suse.de>
In-Reply-To: <54766F36.3050104@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.168.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0651;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0651;
x-forefront-prvs: 040866B734
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(189002)(77096003)(77156002)(74316001)(122556002)(54606007)(46102003)(62966003)(76176999)(20776003)(66066001)(54206007)(64706001)(4396001)(40100003)(107046002)(21056001)(86362001)(95666004)(99286002)(106356001)(106116001)(105586002)(92726001)(2201001)(50986999)(33656002)(54356999)(97736003)(76576001)(101416001)(93886004)(2656002)(120916001)(2501002)(99396003)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0651;H:CY1PR0301MB0748.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1211;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> +int dprc_get_container_id(struct fsl_mc_io *mc_io, int *container_id)
> >>
> >> This one is definitely a misnomer. It's a command that operates on the
> >> MC object, not a DPRC object. Also it doesn't fetch a random
> >> "container_id", it fetches the root container id.
> >
> > It's not strictly the root container. It fetches the container/DPRC ID
> > associated with the portal you are using.  A virtual machine would use
> > it to fetch it's container ID.
> 
> So does every portal properly react to this call?

Yes, they should.

> Or do only container
> portals react to it?

Every portal is associated with some contianer-- either built into
the container/DPRC object, or in a container/DPRC.

> In fact, what does make the initial portal special?

Nothing...it has the same semantics as any other portal.

> Who reacts to
> DPMNG_CMDID_foo calls? Every DPRC or only the initial root?

All portals.  It just means 'what container am I in?'

> >> Please move it and its definition to the files that operate on the MC
> >> management interface.
> >
> > Note, the binary interface opcode really is DPRC_CMDID_GET_CONT_ID.
> >
> > We can request that the binary interface naming be changed, but wouldn't
> > it be better to keep the functions separated by opcode type-- having
> > DPRC_CMDID* opcode-based commands be in one file and DPMNG_CMDID* commands
> > in a separate file?
> 
> It really depends on what the semantics are. If this is a call that's
> only valid on the MC root, then it should belong there. If it's
> available on every container portal, it should be part of dprc of course.

It is valid on any portal, including container portals.  For that reason,
I do think it may make sense for it to be a DPMNG* command.  But, I would
say leave the files implementing the opcode groupings alone until the MC
architecture is changed.

Stuart
