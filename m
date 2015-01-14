Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbbANR6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:58:42 -0500
Received: from mail-by2on0108.outbound.protection.outlook.com ([207.46.100.108]:56836
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750856AbbANR6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:58:40 -0500
Message-ID: <1421258312.4961.133.camel@freescale.com>
Subject: Re: [PATCH] powerpc/mpic: Add DT option to skip readback after EOI
From: Scott Wood <scottwood@freescale.com>
To: Bogdan Purcareata <bogdan.purcareata@freescale.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Wed, 14 Jan 2015 11:58:32 -0600
In-Reply-To: <1421236622-29366-1-git-send-email-bogdan.purcareata@freescale.com>
References: <1421236622-29366-1-git-send-email-bogdan.purcareata@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BL2PR05CA0036.namprd05.prod.outlook.com (10.255.226.36) To
 BY2PR0301MB0726.namprd03.prod.outlook.com (25.160.63.16)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR0301MB0726;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0726;
X-Forefront-PRVS: 04569283F9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(51704005)(24454002)(377424004)(76176999)(50986999)(64706001)(47776003)(106356001)(110136001)(101416001)(19580395003)(19580405001)(77156002)(62966003)(92566002)(87976001)(103116003)(68736005)(36756003)(2950100001)(46102003)(86362001)(105586002)(97736003)(50226001)(33646002)(50466002)(23676002)(42186005)(122386002)(40100003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0726;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0726;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2015 17:58:37.5580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0726
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-14 at 11:57 +0000, Bogdan Purcareata wrote:
> The readback is necessary in order to handle PCI posted
> writes,

That is unclear.

>  or when the MPIC is handling interrupts in a loop
> (ppc_md.get_irq).

I'm questioning this one as well -- if reading WHOAMI is sufficient to
sync with the EOI, why wouldn't reading INTACK work as well?

>  Newer MPIC versions don't require this readback. Leave the option
> configurable using a device tree entry.
> 
> This saves a MMIO trap per interrupt.
> 
> Signed-off-by: Scott Wood <scottwood@freescale.com>
> Signed-off-by: Bogdan Purcareata <bogdan.purcareata@freescale.com>

You should note changes (e.g. with a [] note between signoffs) if it
differs from the original...

-Scott


