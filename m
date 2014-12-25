Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaLYIs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 03:48:27 -0500
Received: from mail-db3on0067.outbound.protection.outlook.com ([157.55.234.67]:65123
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751668AbaLYIsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 03:48:24 -0500
X-Greylist: delayed 1066 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Dec 2014 03:48:24 EST
Message-ID: <549BCAF8.1070500@mellanox.com>
Date: Thu, 25 Dec 2014 10:29:44 +0200
From: Haggai Eran <haggaie@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: <j.glisse@gmail.com>, <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, <joro@8bytes.org>,
        Mel Gorman <mgorman@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Johannes Weiner" <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, "Rik van Riel" <riel@redhat.com>,
        Dave Airlie <airlied@redhat.com>, Brendan Conoboy <blc@redhat.com>,
        Joe Donohue <jdonohue@redhat.com>, Duncan Poole <dpoole@nvidia.com>,
        Sherry Cheung <SCheung@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Mark Hairgrove <mhairgrove@nvidia.com>,
        Lucien Dunning <ldunning@nvidia.com>,
        "Cameron Buschardt" <cabuschardt@nvidia.com>,
        Arvind Gopalakrishnan <arvindg@nvidia.com>,
        Shachar Raindel <raindel@mellanox.com>,
        Liran Liss <liranl@mellanox.com>,
        Roland Dreier <roland@purestorage.com>,
        Ben Sander <ben.sander@amd.com>, Greg Stoner <Greg.Stoner@amd.com>,
        John Bridgman <John.Bridgman@amd.com>,
        Michael Mantor <Michael.Mantor@amd.com>,
        "Paul Blinzer" <Paul.Blinzer@amd.com>,
        Laurent Morichetti <Laurent.Morichetti@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Oded Gabbay <Oded.Gabbay@amd.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>
Subject: Re: [PATCH 2/7] mmu_notifier: keep track of active invalidation ranges
 v2
References: <1419266940-5440-1-git-send-email-j.glisse@gmail.com>
 <1419266940-5440-3-git-send-email-j.glisse@gmail.com>
In-Reply-To: <1419266940-5440-3-git-send-email-j.glisse@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.8.3.60]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 193.47.165.134)
 smtp.mailfrom=haggaie@mellanox.com; 
X-Forefront-Antispam-Report: CIP:193.47.165.134;CTRY:IL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(428002)(51704005)(24454002)(479174004)(189002)(199003)(33656002)(2950100001)(46102003)(36756003)(64706001)(65816999)(59896002)(99396003)(120916001)(50466002)(87936001)(77156002)(4396001)(21056001)(20776003)(50986999)(62966003)(47776003)(105586002)(83506001)(77096005)(106466001)(6806004)(80316001)(64126003)(19580405001)(54356999)(65806001)(87266999)(23676002)(19580395003)(86362001)(101416001)(76176999)(107046002)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:AM3PR05MB0935;H:mtlcas13.mtl.com;FPR:;SPF:None;MLV:sfv;PTR:genko134.voltaire.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:AM3PR05MB0935;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:AM3PR05MB0935;
X-Forefront-PRVS: 04362AC73B
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:AM3PR05MB0935;
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2014 08:30:35.8362
 (UTC)
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a652971c-7d2e-4d9b-a6a4-d149256f461b;Ip=[193.47.165.134]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM3PR05MB0935
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/12/2014 18:48, j.glisse@gmail.com wrote:
>  static inline void mmu_notifier_invalidate_range_start(struct mm_struct *mm,
> -						       unsigned long start,
> -						       unsigned long end,
> -						       enum mmu_event event)
> +						       struct mmu_notifier_range *range)
>  {
> +	/*
> +	 * Initialize list no matter what in case a mmu_notifier register after
> +	 * a range_start but before matching range_end.
> +	 */
> +	INIT_LIST_HEAD(&range->list);

I don't see how can an mmu_notifier register after a range_start but
before a matching range_end. The mmu_notifier registration locks all mm
locks, and that should prevent any invalidation from running, right?

>  	if (mm_has_notifiers(mm))
> -		__mmu_notifier_invalidate_range_start(mm, start, end, event);
> +		__mmu_notifier_invalidate_range_start(mm, range);
>  }

...

>  void __mmu_notifier_invalidate_range_start(struct mm_struct *mm,
> -					   unsigned long start,
> -					   unsigned long end,
> -					   enum mmu_event event)
> +					   struct mmu_notifier_range *range)
>  
>  {
>  	struct mmu_notifier *mn;
> @@ -185,21 +183,36 @@ void __mmu_notifier_invalidate_range_start(struct mm_struct *mm,
>  	id = srcu_read_lock(&srcu);
>  	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
>  		if (mn->ops->invalidate_range_start)
> -			mn->ops->invalidate_range_start(mn, mm, start,
> -							end, event);
> +			mn->ops->invalidate_range_start(mn, mm, range);
>  	}
>  	srcu_read_unlock(&srcu, id);
> +
> +	/*
> +	 * This must happen after the callback so that subsystem can block on
> +	 * new invalidation range to synchronize itself.
> +	 */
> +	spin_lock(&mm->mmu_notifier_mm->lock);
> +	list_add_tail(&range->list, &mm->mmu_notifier_mm->ranges);
> +	mm->mmu_notifier_mm->nranges++;
> +	spin_unlock(&mm->mmu_notifier_mm->lock);
>  }
>  EXPORT_SYMBOL_GPL(__mmu_notifier_invalidate_range_start);

Don't you have a race here because you add the range struct after the
callback?

-------------------------------------------------------------------------
Thread A                    | Thread B
-------------------------------------------------------------------------
call mmu notifier callback  |
  clear SPTE                |
                            | device page fault
                            |   mmu_notifier_range_is_valid returns true
                            |   install new SPTE
add event struct to list    |
mm clears/modifies the PTE  |
-------------------------------------------------------------------------

So we are left with different entries in the host page table and the
secondary page table.

I would think you'd want the event struct to be added to the list before
the callback is run.

Best regards,
Haggai


