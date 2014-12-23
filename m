Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbaLWMJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:09:36 -0500
Received: from mail-bn1bbn0109.outbound.protection.outlook.com ([157.56.111.109]:30883
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754733AbaLWMJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:09:34 -0500
X-WSS-ID: 0NH1B3P-08-A3D-02
X-M-MSG: 
Message-ID: <54995B63.5090808@amd.com>
Date: Tue, 23 Dec 2014 14:09:07 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Dana Elifaz <Dana.Elifaz@amd.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        <iommu@lists.linux-foundation.org>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
Subject: Re: [PATCH 1/2] drivers: Move iommu/ before gpu/ in Makefile
References: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com>
 <1419246435-7050-2-git-send-email-oded.gabbay@amd.com>
In-Reply-To: <1419246435-7050-2-git-send-email-oded.gabbay@amd.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
Authentication-Results: spf=temperror (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(24454002)(377454003)(164054003)(479174004)(189002)(199003)(21056001)(46102003)(97736003)(87936001)(120916001)(50986999)(87266999)(54356999)(99396003)(59896002)(65816999)(62966003)(50466002)(77156002)(64706001)(33656002)(2950100001)(4396001)(20776003)(76176999)(65806001)(65956001)(15975445007)(77096005)(64126003)(68736005)(84676001)(31966008)(19580405001)(47776003)(80316001)(106466001)(92566001)(83506001)(19580395003)(23676002)(36756003)(110136001)(107046002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp02.amd.com;FPR:;SPF:TempError;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:3;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB197;
X-Forefront-PRVS: 04347F8039
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2014 12:09:28.0713
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB197
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,
Dave Airlie asked me to send this patch to you for review.
See link below for cover-letter for this patch that explains the background a 
bit more:
http://lists.freedesktop.org/archives/dri-devel/2014-December/074452.html

Thanks,
	Oded


On 12/22/2014 01:07 PM, Oded Gabbay wrote:
> AMD GPU devices are dependent on AMD IOMMU controller functionality to allow
> the GPU to access a process's virtual memory address space, without the need
> for pinning the memory.
>
> This patch changes the order in the drivers makefile, so iommu/ subsystem is
> linked before gpu/ subsystem. That way, if the gpu and iommu drivers are
> compiled inside the kernel image (not as modules), the correct order of device
> loading is still maintained (iommu module is loaded before gpu module).
>
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
> ---
>   drivers/Makefile | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/Makefile b/drivers/Makefile
> index ebee555..106200f 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -50,7 +50,10 @@ obj-$(CONFIG_RESET_CONTROLLER)	+= reset/
>   obj-y				+= tty/
>   obj-y				+= char/
>
> -# gpu/ comes after char for AGP vs DRM startup
> +# iommu/ comes before gpu as gpu are using iommu controllers
> +obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
> +
> +# gpu/ comes after char for AGP vs DRM startup and after iommu
>   obj-y				+= gpu/
>
>   obj-$(CONFIG_CONNECTOR)		+= connector/
> @@ -141,7 +144,6 @@ obj-y				+= clk/
>
>   obj-$(CONFIG_MAILBOX)		+= mailbox/
>   obj-$(CONFIG_HWSPINLOCK)	+= hwspinlock/
> -obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
>   obj-$(CONFIG_REMOTEPROC)	+= remoteproc/
>   obj-$(CONFIG_RPMSG)		+= rpmsg/
>
>
