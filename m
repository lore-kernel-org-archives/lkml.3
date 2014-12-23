Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbaLWH7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:59:02 -0500
Received: from mail-bn1on0137.outbound.protection.outlook.com ([157.56.110.137]:32592
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754869AbaLWH7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:59:00 -0500
Message-ID: <1419321529.5581.181.camel@freescale.com>
Subject: Re: Ask help about killing irqchip.irq_print_chip on PPC platforms
From: Scott Wood <scottwood@freescale.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
CC: Tudor Laurentiu <b10716@freescale.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Date: Tue, 23 Dec 2014 01:58:49 -0600
In-Reply-To: <5499204B.4040808@linux.intel.com>
References: <54991DE5.5090805@linux.intel.com>
	 <5499204B.4040808@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BLUPR11CA0079.namprd11.prod.outlook.com (10.141.30.47) To
 BY2PR0301MB0728.namprd03.prod.outlook.com (25.160.63.18)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0728;
X-Forefront-PRVS: 04347F8039
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(41574002)(24454002)(377424004)(46102003)(50226001)(23676002)(68736005)(92566001)(33646002)(47776003)(20776003)(64706001)(50466002)(76176999)(21056001)(89996001)(87976001)(36756003)(2950100001)(31966008)(101416001)(62966003)(103116003)(122386002)(107046002)(99396003)(106356001)(105586002)(77156002)(97736003)(120916001)(4396001)(110136001)(86362001)(40100003)(42186005)(50986999);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0728;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2014 07:58:57.3651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0728
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-23 at 15:56 +0800, Jiang Liu wrote:
> Hi Scott and Tudor,
> 	Sorry, resend and Ccing the list.

Resending reply...

> 	We are trying to clean up some irqchip interfaces, and
> irqchip.irq_print_chip is a candidate for removal. After some
> changes on x86 side, arch/powerpc/sysdev/fsl_msi.c may be the
> last user of irqchip.irq_print_chip. So could you please help
> to advice on whether we could kill irqchip.irq_print_chip
> by using "fsl-msi" instead of "fsl-msi-%d" for irqchip name?
> Will it break any userspace interfaces?
> Thanks!
> Gerry

fsl-msi-%d was introduced to allow userspace to identify the cascade
interrupt belonging to a particular MSI, for the purpose of setting
affinity, as this cannot be done on the MSI itself due to hardware
limitations.

Removing it would not exactly eliminate a lot of code or complexity...

-Scott


