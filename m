Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbbAGRE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:04:57 -0500
Received: from mail-bn1bon0110.outbound.protection.outlook.com ([157.56.111.110]:31232
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752635AbbAGREz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:04:55 -0500
Message-ID: <1420650283.4961.52.camel@freescale.com>
Subject: Re: [RFC] PPC: MPIC: necessary readback after EOI?
From: Scott Wood <scottwood@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, Purcareata Bogdan <b43198@freescale.com>,
        <linux-kernel@vger.kernel.org>, Andreas Mohr <andi@lisas.de>
Date: Wed, 7 Jan 2015 11:04:43 -0600
In-Reply-To: <1420641876.5830.32.camel@kernel.crashing.org>
References: <20150105174616.GA3159@rhlx01.hs-esslingen.de>
	 <1420481454.4961.16.camel@freescale.com>
	 <1420641876.5830.32.camel@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: DM2PR11CA0023.namprd11.prod.outlook.com (25.160.91.33) To
 DM2PR0301MB0734.namprd03.prod.outlook.com (25.160.97.142)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:DM2PR0301MB0734;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB0734;
X-Forefront-PRVS: 044968D9E1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(377424004)(199003)(189002)(24454002)(87976001)(99396003)(89996001)(46102003)(76176999)(50986999)(107046002)(50466002)(42186005)(120916001)(86362001)(40100003)(122386002)(4396001)(50226001)(31966008)(47776003)(64706001)(97736003)(20776003)(21056001)(103116003)(33646002)(105586002)(106356001)(92566001)(101416001)(110136001)(77156002)(2950100001)(23676002)(62966003)(68736005)(36756003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0734;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0734;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2015 17:04:51.4163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0734
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-07 at 15:44 +0100, Benjamin Herrenschmidt wrote:
> On Mon, 2015-01-05 at 12:10 -0600, Scott Wood wrote:
> > It would have been nice if a code comment explained why it was doing the
> > readback...  I don't see any particular need to wait for EOI completion
> > here (unlike when masking).
> 
> The EOI is what causes the MPIC to drop it's EE output to the CPU, if the
> EOI is processed too slowly & asynchronously (posted write + 33Mhz MPIC)
> we observe cases of spurrious interrupts. We had some macs basically getting
> a spurrious irq for every MPIC interrupts...

Shouldn't reading INTACK be what causes the MPIC to drop its EE output?

-Scott


