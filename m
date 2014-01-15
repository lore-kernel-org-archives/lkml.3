Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbaAOWDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:03:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:15698 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbaAOWAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:00:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,665,1384329600"; 
   d="scan'208";a="459452815"
From: "Brown, Aaron F" <aaron.f.brown@intel.com>
To: "ethan.kernel@gmail.com" <ethan.kernel@gmail.com>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v3] ixgbe: define IXGBE_MAX_VFS_DRV_LIMIT macro and
 cleanup const 63
Thread-Topic: [PATCH 1/2 v3] ixgbe: define IXGBE_MAX_VFS_DRV_LIMIT macro and
 cleanup const 63
Thread-Index: AQHPEj00iZY7ve3oL0SvklDqADUOyQ==
Date: Wed, 15 Jan 2014 22:00:29 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B7312DA20@ORSMSX101.amr.corp.intel.com>
References: <1389795148-341-1-git-send-email-ethan.kernel@gmail.com>
In-Reply-To: <1389795148-341-1-git-send-email-ethan.kernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0FM3RbD012142

On Wed, 2014-01-15 at 22:12 +0800, Ethan Zhao wrote:
> Because ixgbe driver limit the max number of VF functions could be enabled
> to 63, so define one macro IXGBE_MAX_VFS_DRV_LIMIT and cleanup the const 63
> in code.
> 
> v2: fix a typo.
> v3: fix a encoding issue.
> 
> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  | 4 ++--
>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 5 +++--
>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.h | 5 +++++
>  3 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 0ade0cd..47e9b44 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -4818,7 +4818,7 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter)
>  #ifdef CONFIG_PCI_IOV
>  	/* assign number of SR-IOV VFs */
>  	if (hw->mac.type != ixgbe_mac_82598EB)
> -		adapter->num_vfs = (max_vfs > 63) ? 0 : max_vfs;


Unfortunately the if statement got changed considerably with a recent
commit:

commit 170e85430bcbe4d18e81b5a70bb163c741381092
ixgbe: add warning when max_vfs is out of range.
    
And the pattern no longer exists to make a match.  In other words, this
patch no longer applies to net-next and I have to ask you for yet
another spin if you still want to squash the magic number.

Thanks,
Aaron
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
