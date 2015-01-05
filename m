Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbbAESLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:11:09 -0500
Received: from mail-bn1bbn0107.outbound.protection.outlook.com ([157.56.111.107]:46720
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753418AbbAESLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:11:08 -0500
Message-ID: <1420481454.4961.16.camel@freescale.com>
Subject: Re: [RFC] PPC: MPIC: necessary readback after EOI?
From: Scott Wood <scottwood@freescale.com>
To: Andreas Mohr <andi@lisas.de>
CC: Purcareata Bogdan <b43198@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 5 Jan 2015 12:10:54 -0600
In-Reply-To: <20150105174616.GA3159@rhlx01.hs-esslingen.de>
References: <20150105174616.GA3159@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: CO2PR11CA0021.namprd11.prod.outlook.com (10.141.242.159) To
 BY2PR0301MB0728.namprd03.prod.outlook.com (25.160.63.18)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR0301MB0728;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0728;
X-Forefront-PRVS: 0447DB1C71
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(377424004)(51704005)(24454002)(46102003)(99396003)(107046002)(120916001)(122386002)(64706001)(20776003)(47776003)(23676002)(50466002)(89996001)(50226001)(4396001)(68736005)(36756003)(31966008)(87976001)(101416001)(62966003)(103116003)(40100003)(97736003)(33646002)(551934003)(106356001)(50986999)(105586002)(110136001)(76176999)(2950100001)(77156002)(21056001)(42186005)(92566001)(86362001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0728;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2015 18:11:04.1034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0728
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 18:46 +0100, Andreas Mohr wrote:
> Hi,
> 
> > I was curious why the mpic_cpu_read(MPIC_INFO(CPU_WHOAMI)) was there in
> > the first place and if it's still needed. If it's still required, I
> > guess a better approach is to eliminate the call only if the kernel is
> > running on the KVM guest side, where the MPIC is emulated and no longer
> > requires a readback.
> 
> "Why not?"
> 
> A mechanism being "emulated"/"virtual" or not
> may not necessarily be much of a distinction (if at all!).
> The readback might be required
> to properly fulfill all requirements
> of a full state change protocol specification,
> which might easily be the case for both RS(*) and virtual hardware.
> And especially for virtual hardware
> such a "readback" event
> might be an extremely important "end of transaction" marker
> which may often be needed for freeing of temporary resources etc.

I'm not convinced that it's required in real silicon (though there are
many MPIC implementations which have their own quirks...), and I'm 100%
sure that it's not required in the QEMU/KVM implementation of MPIC.

It would have been nice if a code comment explained why it was doing the
readback...  I don't see any particular need to wait for EOI completion
here (unlike when masking).

-Scott


