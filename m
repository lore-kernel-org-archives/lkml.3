Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422630AbaDWUyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:54:45 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2029 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932572AbaDWUyk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:54:40 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        "John W. Linville" <linville@tuxdriver.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 23 Apr 2014 13:54:27 -0700
Subject: RE: linux-next: build failure after merge of the wireless-next tree
Thread-Topic: linux-next: build failure after merge of the wireless-next tree
Thread-Index: Ac9eptWv3wstb5qlQxeRH2X1BaPvbAAjxznQ
Message-ID: <477F20668A386D41ADCC57781B1F70430F70A2A9C2@SC-VEXCH1.marvell.com>
References: <20140423134753.4731f16efe32ee9f20925757@canb.auug.org.au>
In-Reply-To: <20140423134753.4731f16efe32ee9f20925757@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-23_04:2014-04-23,2014-04-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404230310
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> Hi John,
> 
> After merging the wireless-next tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/net/wireless/mwifiex/pcie.c: In function 'mwifiex_pcie_fw_dump_work':
> drivers/net/wireless/mwifiex/pcie.c:2290:3: error: implicit declaration of function 'vmalloc' [-
> Werror=implicit-function-declaration]
>    entry->mem_ptr = vmalloc(memory_size + 1);
>    ^
> drivers/net/wireless/mwifiex/pcie.c:2290:18: warning: assignment makes pointer from integer without a
> cast [enabled by default]
>    entry->mem_ptr = vmalloc(memory_size + 1);
>                   ^
> drivers/net/wireless/mwifiex/pcie.c:2361:4: error: implicit declaration of function 'vfree' [-
> Werror=implicit-function-declaration]
>     vfree(entry->mem_ptr);
>     ^
> 
> Caused by commit e050c76fcf49 ("mwifiex: add firmware dump feature for
> PCIe").
> 
> I have applied this patch for today:


Sorry for the trouble and thanks a lot for the fix.

Regards,
Bing


> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 23 Apr 2014 13:44:59 +1000
> Subject: [PATCH] mwifiex: using vmallog requires including vmalloc.h
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/wireless/mwifiex/pcie.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
> index 51989b31137a..9c1f42754bbe 100644
> --- a/drivers/net/wireless/mwifiex/pcie.c
> +++ b/drivers/net/wireless/mwifiex/pcie.c
> @@ -17,6 +17,7 @@
>   * this warranty disclaimer.
>   */
> 
> +#include <linux/vmalloc.h>
>  #include <linux/firmware.h>
> 
>  #include "decl.h"
> --
> 1.9.2
> 
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
