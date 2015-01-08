Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbbAHLGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 06:06:50 -0500
Received: from mail-db3on0057.outbound.protection.outlook.com ([157.55.234.57]:13408
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754256AbbAHLGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 06:06:47 -0500
Message-ID: <54AE6485.60402@mellanox.com>
Date: Thu, 8 Jan 2015 13:05:41 +0200
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
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jatin Kumar <jakumar@nvidia.com>
Subject: Re: [PATCH 5/6] HMM: add per mirror page table.
References: <1420497889-10088-1-git-send-email-j.glisse@gmail.com>
 <1420497889-10088-6-git-send-email-j.glisse@gmail.com>
In-Reply-To: <1420497889-10088-6-git-send-email-j.glisse@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.8.0.101]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 193.47.165.134)
 smtp.mailfrom=haggaie@mellanox.com; 
X-Forefront-Antispam-Report: CIP:193.47.165.134;CTRY:IL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(428002)(24454002)(189002)(199003)(479174004)(86362001)(83506001)(105586002)(65956001)(106466001)(33656002)(84676001)(47776003)(120916001)(99396003)(20776003)(87936001)(19580405001)(65806001)(92566001)(21056001)(19580395003)(6806004)(64706001)(46102003)(107046002)(101416001)(23676002)(54356999)(97736003)(77156002)(62966003)(65816999)(76176999)(4396001)(64126003)(36756003)(31966008)(50986999)(68736005)(77096005)(50466002)(2950100001)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:DB3PR05MB0794;H:mtlcas13.mtl.com;FPR:;SPF:None;MLV:sfv;PTR:ErrorRetry;MX:1;A:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:DB3PR05MB0794;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(601004);SRVR:DB3PR05MB0794;
X-Forefront-PRVS: 0450A714CB
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:DB3PR05MB0794;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2015 11:06:38.3193
 (UTC)
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a652971c-7d2e-4d9b-a6a4-d149256f461b;Ip=[193.47.165.134]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR05MB0794
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DB3PR05MB028;
X-OriginatorOrg: Mellanox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2015 00:44, j.glisse@gmail.com wrote:
> +	/* fence_wait() - to wait on device driver fence.
> +	 *
> +	 * @fence: The device driver fence struct.
> +	 * Returns: 0 on success,-EIO on error, -EAGAIN to wait again.
> +	 *
> +	 * Called when hmm want to wait for all operations associated with a
> +	 * fence to complete (including device cache flush if the event mandate
> +	 * it).
> +	 *
> +	 * Device driver must free fence and associated resources if it returns
> +	 * something else thant -EAGAIN. On -EAGAIN the fence must not be free
> +	 * as hmm will call back again.
> +	 *
> +	 * Return error if scheduled operation failed or if need to wait again.
> +	 * -EIO Some input/output error with the device.
> +	 * -EAGAIN The fence not yet signaled, hmm reschedule waiting thread.
> +	 *
> +	 * All other return value trigger warning and are transformed to -EIO.
> +	 */
> +	int (*fence_wait)(struct hmm_fence *fence);

According to the comment, the device frees the fence struct when the
fence_wait callback returns zero or -EIO, but the code below calls
fence_unref after fence_wait on the same fence.

> +
> +	/* fence_ref() - take a reference fence structure.
> +	 *
> +	 * @fence: Fence structure hmm is referencing.
> +	 */
> +	void (*fence_ref)(struct hmm_fence *fence);

I don't see fence_ref being called anywhere in the patchset. Is it
actually needed?

> +static void hmm_device_fence_wait(struct hmm_device *device,
> +				  struct hmm_fence *fence)
> +{
> +	struct hmm_mirror *mirror;
> +	int r;
> +
> +	if (fence == NULL)
> +		return;
> +
> +	list_del_init(&fence->list);
> +	do {
> +		r = device->ops->fence_wait(fence);
> +		if (r == -EAGAIN)
> +			io_schedule();
> +	} while (r == -EAGAIN);
> +
> +	mirror = fence->mirror;
> +	device->ops->fence_unref(fence);
> +	if (r)
> +		hmm_mirror_release(mirror);
> +}
> +

Regards,
Haggai
