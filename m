Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaIVIqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:46:25 -0400
Received: from mail-bl2on0147.outbound.protection.outlook.com ([65.55.169.147]:27091
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753512AbaIVIqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:46:21 -0400
Message-ID: <541FDDD6.9040009@freescale.com>
Date: Mon, 22 Sep 2014 11:29:10 +0300
From: Laurentiu Tudor <b10716@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>, <greg@kroah.com>, <arnd@arndb.de>,
        <mpe@ellerman.id.au>, <benh@kernel.crashing.org>
CC: <cbe-oss-dev@lists.ozlabs.org>, <imunsie@au.ibm.com>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
        <jk@ozlabs.org>, <anton@samba.org>
Subject: Re: [PATCH 03/15] powerpc/msi: Improve IRQ bitmap allocator
References: <1411028820-29933-1-git-send-email-mikey@neuling.org> <1411028820-29933-4-git-send-email-mikey@neuling.org>
In-Reply-To: <1411028820-29933-4-git-send-email-mikey@neuling.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.166.1]
X-ClientProxiedBy: AM3PR01CA054.eurprd01.prod.exchangelabs.com (10.141.191.44)
 To DM2PR03MB320.namprd03.prod.outlook.com (10.141.54.23)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB320;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(479174003)(377454003)(24454002)(51704005)(199003)(189002)(20776003)(47776003)(105586002)(64706001)(85306004)(106356001)(4396001)(2201001)(97736003)(101416001)(65956001)(59896002)(102836001)(21056001)(50466002)(92566001)(23676002)(65806001)(120916001)(92726001)(66066001)(31966008)(74502003)(83506001)(99396002)(33656002)(76176999)(77096002)(81542003)(87976001)(50986999)(36756003)(107046002)(54356999)(19580405001)(19580395003)(90102001)(79102003)(95666004)(77982003)(74662003)(80022003)(81342003)(46102003)(65816999)(83072002)(87266999)(76482002)(83322001)(80316001)(85852003)(42186005)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB320;H:[10.171.73.112];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

Minor comment inline.

On 09/18/2014 11:26 AM, Michael Neuling wrote:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> Currently msi_bitmap_alloc_hwirqs() will round up any IRQ allocation requests
> to the nearest power of 2.  eg. ask for 5 IRQs and you'll get 8.  This wastes a
> lot of IRQs which can be a scarce resource.
> 
> For cxl we can require multiple IRQs for every contexts that is attached to the
> accelerator.  For AFU directed accelerators, there may be 1000s of contexts
> attached, hence we can easily run out of IRQs, especially if we are needlessly
> wasting them.
> 
> This changes the msi_bitmap_alloc_hwirqs() to allocate only the required number
> of IRQs, hence avoiding this wastage.
> 
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> ---
>  arch/powerpc/sysdev/msi_bitmap.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/msi_bitmap.c b/arch/powerpc/sysdev/msi_bitmap.c
> index 2ff6302..e001559 100644
> --- a/arch/powerpc/sysdev/msi_bitmap.c
> +++ b/arch/powerpc/sysdev/msi_bitmap.c
> @@ -24,28 +24,36 @@ int msi_bitmap_alloc_hwirqs(struct msi_bitmap *bmp, int num)
>  	 * This is fast, but stricter than we need. We might want to add
>  	 * a fallback routine which does a linear search with no alignment.
>  	 */

Is this comment still relevant (especially the part mentioning "fast")?

---
Best Regards, Laurentiu
