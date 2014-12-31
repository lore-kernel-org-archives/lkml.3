Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaLaPrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:47:42 -0500
Received: from mail-db3on0064.outbound.protection.outlook.com ([157.55.234.64]:44756
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751104AbaLaPrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:47:40 -0500
Message-ID: <54A41A64.9080909@mellanox.com>
Date: Wed, 31 Dec 2014 17:46:44 +0200
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
Subject: Re: [PATCH 3/7] HMM: introduce heterogeneous memory management.
References: <1419266940-5440-1-git-send-email-j.glisse@gmail.com>
 <1419266940-5440-4-git-send-email-j.glisse@gmail.com>
In-Reply-To: <1419266940-5440-4-git-send-email-j.glisse@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.8.1.4]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 193.47.165.134)
 smtp.mailfrom=haggaie@mellanox.com; 
X-Forefront-Antispam-Report: CIP:193.47.165.134;CTRY:IL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(428002)(189002)(199003)(479174004)(24454002)(86362001)(65816999)(97736003)(33656002)(76176999)(64706001)(47776003)(92566001)(65806001)(36756003)(21056001)(84676001)(6806004)(31966008)(20776003)(80316001)(62966003)(77156002)(19580405001)(101416001)(87936001)(106466001)(4396001)(50986999)(107046002)(2950100001)(68736005)(50466002)(19580395003)(99396003)(46102003)(23676002)(54356999)(64126003)(105586002)(59896002)(77096005)(120916001)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:DB4PR05MB0942;H:mtlcas13.mtl.com;FPR:;SPF:None;MLV:sfv;PTR:ErrorRetry;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DB4PR05MB0942;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DB4PR05MB0942;
X-Forefront-PRVS: 0442E569BC
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB4PR05MB0942;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2014 15:47:34.9197
 (UTC)
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a652971c-7d2e-4d9b-a6a4-d149256f461b;Ip=[193.47.165.134]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR05MB0942
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DB4PR05MB0944;
X-OriginatorOrg: Mellanox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 22/12/2014 18:48, j.glisse@gmail.com wrote:
> +/* hmm_device_register() - register a device with HMM.
> + *
> + * @device: The hmm_device struct.
> + * Returns: 0 on success or -EINVAL otherwise.
> + *
> + *
> + * Call when device driver want to register itself with HMM. Device driver can
> + * only register once. It will return a reference on the device thus to release
> + * a device the driver must unreference the device.

I see that the code doesn't actually have a reference count on the
hmm_device, but just registers and unregisters it through the
hmm_device_register/hmm_device_unregister functions. Perhaps you should
update the comment here to tell that.

> + */
> +int hmm_device_register(struct hmm_device *device)
> +{
> +	/* sanity check */
> +	BUG_ON(!device);
> +	BUG_ON(!device->name);
> +	BUG_ON(!device->ops);
> +	BUG_ON(!device->ops->release);
> +
> +	mutex_init(&device->mutex);
> +	INIT_LIST_HEAD(&device->mirrors);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(hmm_device_register);

Regards,
Haggai
