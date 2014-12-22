Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaLVL4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:56:34 -0500
Received: from mail-bn1bon0134.outbound.protection.outlook.com ([157.56.111.134]:45056
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754457AbaLVL4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:56:32 -0500
X-WSS-ID: 0NGZFTT-07-9MS-02
X-M-MSG: 
Message-ID: <549806DE.2080703@amd.com>
Date: Mon, 22 Dec 2014 12:56:14 +0100
From: =?ISO-8859-15?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oded Gabbay <oded.gabbay@amd.com>, David Airlie <airlied@linux.ie>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
CC: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, Joerg Roedel <joro@8bytes.org>,
        "Jerome Glisse" <j.glisse@gmail.com>,
        John Bridgman <John.Bridgman@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Dana Elifaz <Dana.Elifaz@amd.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH 0/2] Change order of linkage in kernel makefiles for amdkfd
References: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com>
In-Reply-To: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com>
Content-Type: text/plain; charset="iso-8859-15"; format=flowed
X-Originating-IP: [10.224.155.116]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(189002)(199003)(31966008)(97736003)(87936001)(50986999)(59896002)(105586002)(99396003)(101416001)(76176999)(21056001)(36756003)(2950100001)(77096005)(4396001)(33656002)(86362001)(62966003)(107046002)(15975445007)(106466001)(77156002)(120916001)(19580395003)(19580405001)(46102003)(80316001)(92566001)(68736005)(87266999)(54356999)(84676001)(65816999)(65806001)(65956001)(20776003)(50466002)(23756003)(47776003)(64706001)(83506001)(129583001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB200;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 11:56:19.5095
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For this series: Reviewed-by: Christian König <christian.koenig@amd.com>

Am 22.12.2014 um 12:07 schrieb Oded Gabbay:
> This small patch-set, was created to solve the bug described at
> https://bugzilla.kernel.org/show_bug.cgi?id=89661 (Kernel panic when
> trying use amdkfd driver on Kaveri). It replaces the previous patch-set called
> [PATCH 0/3] Use workqueue for device init in amdkfd
> (http://lists.freedesktop.org/archives/dri-devel/2014-December/074401.html)
>
> That bug appears only when radeon, amdkfd and amd_iommu_v2 are compiled
> inside the kernel (not as modules). In that case, the correct loading
> order, as determined by the exported symbol used by each driver, is
> not enforced anymore and the kernel loads them based on who was linked
> first. That makes radeon load first, amdkfd second and amd_iommu_v2
> third.
>
> Because the initialization of a device in amdkfd is initiated by radeon,
> and can only be completed if amdkfd and amd_iommu_v2 were loaded and
> initialized, then in the case mentioned above, this initalization fails
> and there is a kernel panic as some pointers are not initialized but
> used nontheless.
>
> To solve this bug, this patch-set moves iommu/ before gpu/ in drivers/Makefile
> and also moves amdkfd/ before radeon/ in drivers/gpu/drm/Makefile.
>
> The rationale is that in general, AMD GPU devices are dependent on AMD IOMMU
> controller functionality to allow the GPU to access a process's virtual memory
> address space, without the need for pinning the memory. That's why it makes
> sense to initialize the iommu/ subsystem ahead of the gpu/ subsystem.
>
> 	Oded
>
> Oded Gabbay (2):
>    drivers: Move iommu/ before gpu/ in Makefile
>    drm: Put amdkfd before radeon in drm Makefile
>
>   drivers/Makefile         | 6 ++++--
>   drivers/gpu/drm/Makefile | 2 +-
>   2 files changed, 5 insertions(+), 3 deletions(-)
>

