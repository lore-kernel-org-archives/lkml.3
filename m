Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaLORDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:03:13 -0500
Received: from mail-am1on0062.outbound.protection.outlook.com ([157.56.112.62]:4449
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751503AbaLORDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:03:08 -0500
X-Greylist: delayed 2509 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Dec 2014 12:03:07 EST
Message-ID: <548F0A68.7070400@ezchip.com>
Date: Mon, 15 Dec 2014 11:20:56 -0500
From: Chris Metcalf <cmetcalf@ezchip.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/12] tile: use {cpu|node}mask pr_cont and seq output
 functions
References: <1418226774-30215-1-git-send-email-tj@kernel.org> <1418226774-30215-6-git-send-email-tj@kernel.org>
In-Reply-To: <1418226774-30215-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [12.216.194.146]
X-ClientProxiedBy: BLUPR11CA0048.namprd11.prod.outlook.com (10.141.30.16) To
 AM3PR02MB0533.eurprd02.prod.outlook.com (25.160.6.139)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:AM3PR02MB0533;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601003);SRVR:AM3PR02MB0533;
X-Forefront-PRVS: 04267075BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(24454002)(479174004)(51704005)(199003)(189002)(377454003)(50466002)(36756003)(83506001)(107046002)(62966003)(20776003)(21056001)(23756003)(40100003)(122386002)(31966008)(80316001)(19580395003)(19580405001)(46102003)(15975445007)(77096005)(68736005)(77156002)(64126003)(76176999)(50986999)(65816999)(92566001)(86362001)(105586002)(4396001)(64706001)(47776003)(101416001)(106356001)(87266999)(66066001)(33656002)(42186005)(65956001)(54356999)(99396003)(97736003)(87976001)(120916001)(18886065003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM3PR02MB0533;H:[10.7.0.239];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:AM3PR02MB0533;
X-OriginatorOrg: ezchip.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2014 16:21:08.7458 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM3PR02MB0533
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 10:52 AM, Tejun Heo wrote:
> Convert the existing user of cpu{mask|list}_scnprintf() and
> node{mask|list}_scnprintf() which use them just to printk or
> seq_printf() the resulting buffer to use the following functions
> instead respectively.
>
> * For printk: cpu{mask|list}_pr_cont() and node{mask|list}_pr_cont().
>
> * For seq_file: seq_cpumask[_list]() and seq_nodemask[_list]().
>
> Because these conversions usually break up a single output function
> call into multiple, the reduction is LOC isn't too big but it removes
> unnecessary complexity and/or arbitrary limit on the length printed.
>
> This patch is dependent on the previous patch ("bitmap, cpumask,
> nodemask: implement pr_cont variants of formatting functions") which
> is planned to go through -mm.  It'd be the easiest to route this
> together.  If this should go through the subsystem tree, please wait
> till the forementioned patch is merged to mainline.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Andrew Morton<akpm@linux-foundation.org>
> Cc: Chris Metcalf<cmetcalf@tilera.com>
> ---
>   arch/tile/kernel/hardwall.c         |  6 ++----
>   arch/tile/kernel/proc.c             |  6 +++---
>   arch/tile/kernel/setup.c            | 12 ++++++------
>   arch/tile/mm/homecache.c            | 14 +++++++-------
>   arch/tile/mm/init.c                 | 12 ++++++------
>   drivers/net/ethernet/tile/tilegx.c  |  6 +++---
>   drivers/net/ethernet/tile/tilepro.c |  6 +++---
>   7 files changed, 30 insertions(+), 32 deletions(-)

Acked-by: Chris Metcalf <cmetcalf@ezchip.com>

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

