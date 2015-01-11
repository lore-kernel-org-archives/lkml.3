Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbbAKFqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 00:46:31 -0500
Received: from mail-db3on0053.outbound.protection.outlook.com ([157.55.234.53]:7360
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750931AbbAKFqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 00:46:30 -0500
Message-ID: <54B20DEA.5050803@mellanox.com>
Date: Sun, 11 Jan 2015 07:45:14 +0200
From: Haggai Eran <haggaie@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        <joro@8bytes.org>, Mel Gorman <mgorman@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Airlie <airlied@redhat.com>, Brendan Conoboy <blc@redhat.com>,
        Joe Donohue <jdonohue@redhat.com>, Duncan Poole <dpoole@nvidia.com>,
        Sherry Cheung <SCheung@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Mark Hairgrove <mhairgrove@nvidia.com>,
        Lucien Dunning <ldunning@nvidia.com>,
        Cameron Buschardt <cabuschardt@nvidia.com>,
        "Arvind Gopalakrishnan" <arvindg@nvidia.com>,
        Shachar Raindel <raindel@mellanox.com>,
        Liran Liss <liranl@mellanox.com>,
        Roland Dreier <roland@purestorage.com>,
        Ben Sander <ben.sander@amd.com>, Greg Stoner <Greg.Stoner@amd.com>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Michael Mantor <Michael.Mantor@amd.com>,
        Paul Blinzer <Paul.Blinzer@amd.com>,
        Laurent Morichetti <Laurent.Morichetti@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Oded Gabbay <Oded.Gabbay@amd.com>,
        =?windows-1252?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>,
        Jatin Kumar <jakumar@nvidia.com>
Subject: Re: [PATCH 5/6] HMM: add per mirror page table.
References: <1420497889-10088-1-git-send-email-j.glisse@gmail.com>
 <1420497889-10088-6-git-send-email-j.glisse@gmail.com>
 <54AE6485.60402@mellanox.com> <20150110064831.GA19689@gmail.com>
In-Reply-To: <20150110064831.GA19689@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.8.2.69]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 193.47.165.134)
 smtp.mailfrom=haggaie@mellanox.com; 
X-Forefront-Antispam-Report: CIP:193.47.165.134;CTRY:IL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(428002)(189002)(51704005)(199003)(479174004)(24454002)(46102003)(19580395003)(19580405001)(87936001)(6806004)(54356999)(50466002)(64706001)(33656002)(50986999)(64126003)(76176999)(65816999)(77156002)(23746002)(86362001)(62966003)(97736003)(105586002)(106466001)(36756003)(77096005)(68736005)(47776003)(110136001)(2950100001)(83506001)(59896002)(92566002)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:AM2PR05MB0788;H:mtlcas13.mtl.com;FPR:;SPF:None;MLV:sfv;PTR:ErrorRetry;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:AM2PR05MB0788;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:AM2PR05MB0788;
X-Forefront-PRVS: 045315E1EE
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:AM2PR05MB0788;
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2015 05:46:24.4266
 (UTC)
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a652971c-7d2e-4d9b-a6a4-d149256f461b;Ip=[193.47.165.134]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM2PR05MB0788
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2015 08:48, Jerome Glisse wrote:
> On Thu, Jan 08, 2015 at 01:05:41PM +0200, Haggai Eran wrote:
>> On 06/01/2015 00:44, j.glisse@gmail.com wrote:
>>> +	/* fence_wait() - to wait on device driver fence.
>>> +	 *
>>> +	 * @fence: The device driver fence struct.
>>> +	 * Returns: 0 on success,-EIO on error, -EAGAIN to wait again.
>>> +	 *
>>> +	 * Called when hmm want to wait for all operations associated with a
>>> +	 * fence to complete (including device cache flush if the event mandate
>>> +	 * it).
>>> +	 *
>>> +	 * Device driver must free fence and associated resources if it returns
>>> +	 * something else thant -EAGAIN. On -EAGAIN the fence must not be free
>>> +	 * as hmm will call back again.
>>> +	 *
>>> +	 * Return error if scheduled operation failed or if need to wait again.
>>> +	 * -EIO Some input/output error with the device.
>>> +	 * -EAGAIN The fence not yet signaled, hmm reschedule waiting thread.
>>> +	 *
>>> +	 * All other return value trigger warning and are transformed to -EIO.
>>> +	 */
>>> +	int (*fence_wait)(struct hmm_fence *fence);
>>
>> According to the comment, the device frees the fence struct when the
>> fence_wait callback returns zero or -EIO, but the code below calls
>> fence_unref after fence_wait on the same fence.
> 
> Yes comment is out of date, i wanted to simplify fence before readding
> it once needed (by device memory migration).
> 
>>
>>> +
>>> +	/* fence_ref() - take a reference fence structure.
>>> +	 *
>>> +	 * @fence: Fence structure hmm is referencing.
>>> +	 */
>>> +	void (*fence_ref)(struct hmm_fence *fence);
>>
>> I don't see fence_ref being called anywhere in the patchset. Is it
>> actually needed?
> 
> Not right now but the page migration to device memory use it. But i
> can remove it now.
> 
> I can respin to make comment match code but i would like to know where
> i stand on everythings else.
> 

Well, I've read patches 1 through 4, and they seemed fine, although I
still want to have a deeper look into patch 4, because the page table
code seems a little tricky. I haven't completed reading patch 5 and 6 yet.

Haggai
