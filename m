Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750970AbaLPLOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 06:14:30 -0500
Received: from mail-db3on0089.outbound.protection.outlook.com ([157.55.234.89]:54352
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750840AbaLPLO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 06:14:28 -0500
X-Greylist: delayed 940 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Dec 2014 06:14:28 EST
Message-ID: <54901021.9020205@mellanox.com>
Date: Tue, 16 Dec 2014 12:57:37 +0200
From: Or Gerlitz <ogerlitz@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Haggai Eran <haggaie@mellanox.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yevgeny Petrilin <yevgenyp@mellanox.com>,
        Amir Vadai <amirv@mellanox.com>
Subject: Re: linux-next: build failure after merge of the infiniband tree
References: <20141216124750.153e3fdd@canb.auug.org.au>
 <CAG4TOxP9WFHALPb0y0eKFup6uhszXfd+hLcwZ98kZUVaR_9j4w@mail.gmail.com>
In-Reply-To: <CAG4TOxP9WFHALPb0y0eKFup6uhszXfd+hLcwZ98kZUVaR_9j4w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.1.5.214]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 193.47.165.134)
 smtp.mailfrom=ogerlitz@mellanox.com; 
X-Forefront-Antispam-Report: CIP:193.47.165.134;CTRY:IL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(428002)(189002)(53754006)(24454002)(199003)(377454003)(52604005)(51704005)(479174004)(54356999)(50466002)(76176999)(120916001)(20776003)(6806004)(47776003)(31966008)(99396003)(21056001)(23676002)(77096005)(77156002)(46102003)(4396001)(65816999)(106466001)(36756003)(107046002)(64706001)(86362001)(92566001)(19580395003)(101416001)(117636001)(50986999)(59896002)(65806001)(105586002)(65956001)(64126003)(19580405001)(87266999)(87936001)(2950100001)(83506001)(62816006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB4PR05MB0944;H:mtlcas13.mtl.com;FPR:;SPF:None;MLV:sfv;PTR:genko134.voltaire.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DB4PR05MB0944;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DB4PR05MB0944;
X-Forefront-PRVS: 04270EF89C
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB4PR05MB0944;
X-OriginatorOrg: Mellanox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 3:56 AM, Roland Dreier wrote:
> On Mon, Dec 15, 2014 at 5:47 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> After merging the infiniband tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> drivers/infiniband/hw/mlx5/main.c: In function 'mlx5_ib_query_device':
>> drivers/infiniband/hw/mlx5/main.c:248:34: error: 'MLX5_DEV_CAP_FLAG_ON_DMND_PG' undeclared (first use in this function)
>>    if (dev->mdev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
>>                                    ^
>> [...]
>> Really?  Code added half way though the merge window not even build
>> tested?
> It's not quite as bad as it seems.  The infiniband tree itself builds,
> the problem is the merged tree.
>
> The Mellanox guys merged the "cleanup"

Hi Roland,

So shit happens... Eli is away this week, but it's clear that this 
portion of the cleanup
was terribly wrongand done by mistake, sorry for that and thanks for 
addressing quickly.

Or.

>
> commit 0c7aac854f52
> Author: Eli Cohen <eli@dev.mellanox.co.il>
> Date:   Tue Dec 2 02:26:14 2014
>
>      net/mlx5_core: Remove unused dev cap enum fields
>
>      These enumerations are not used so remove them.
>
>      Signed-off-by: Eli Cohen <eli@mellanox.com>
>      Signed-off-by: David S. Miller <davem@davemloft.net>
>
> through davem's tree, and then went ahead and used at least
> MLX5_DEV_CAP_FLAG_ON_DMND_PG (which that patch removes) in patches
> they merged through my tree.
>
> I'll add a partial revert of that patch to my tree to get back the
> now-used enum values.
>
>   - R.
>
