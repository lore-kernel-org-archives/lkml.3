Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbbAXATG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 19:19:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:2854 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbbAXATE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 19:19:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,457,1418112000"; 
   d="scan'208";a="666754064"
From: "Vick, Matthew" <matthew.vick@intel.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ethernet: fm10k: Actually drop 4 bits
Thread-Topic: [PATCH] ethernet: fm10k: Actually drop 4 bits
Thread-Index: AQHQN2tZwQuPicYglkaLrsR9ALJ30A==
Date: Sat, 24 Jan 2015 00:18:59 +0000
Message-ID: <D0E81E0C.682EB%matthew.vick@intel.com>
References: <1421967198-16667-1-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1421967198-16667-1-git-send-email-linux@rasmusvillemoes.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.4.7.141117
x-originating-ip: [10.166.14.12]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <543D00244348774BBCF40F383798268E@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/22/15, 2:53 PM, "Rasmus Villemoes" <linux@rasmusvillemoes.dk> wrote:

>The comment explains the intention, but vid has type u16. Before the
>inner shift, it is promoted to int, which has plenty of space for all
>vid's bits, so nothing is dropped. Use a simple mask instead.
>
>Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>---
> drivers/net/ethernet/intel/fm10k/fm10k_pf.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
>b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
>index 275423d4f777..b1c57d0166a9 100644
>--- a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
>+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
>@@ -335,7 +335,7 @@ static s32 fm10k_update_xc_addr_pf(struct fm10k_hw
>*hw, u16 glort,
> 		return FM10K_ERR_PARAM;
> 
> 	/* drop upper 4 bits of VLAN ID */
>-	vid = (vid << 4) >> 4;
>+	vid &= 0x0fff;
> 
> 	/* record fields */
> 	mac_update.mac_lower = cpu_to_le32(((u32)mac[2] << 24) |

Good catch! I noticed this too and was getting a patch together to address
this.

The difference is that I was planning on not silently accepting an invalid
VLAN ID to begin with and returning FM10K_ERR_PARAM if the VLAN was
invalid, which I think is a better approach for this situation. If it's
alright with you, I'll generate the patch shortly and credit you via your
Reported-by.

Cheers,
Matthew

