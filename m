Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaAPByb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:54:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:10545 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaAPBy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:54:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,666,1384329600"; 
   d="scan'208";a="439557829"
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
Thread-Index: AQHPEl3i849dncaiy0ibYLLFfxl6vg==
Date: Thu, 16 Jan 2014 01:54:26 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B7312DE7D@ORSMSX101.amr.corp.intel.com>
References: <1389795148-341-1-git-send-email-ethan.kernel@gmail.com>
 <309B89C4C689E141A5FF6A0C5FB2118B7312DA20@ORSMSX101.amr.corp.intel.com>
 <CABawtvNEDjTJAjJ9TeEvZd7+2kD=H6zA23T-aQo3uVm5SUEhCQ@mail.gmail.com>
In-Reply-To: <CABawtvNEDjTJAjJ9TeEvZd7+2kD=H6zA23T-aQo3uVm5SUEhCQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0G1sbia014448

On Thu, 2014-01-16 at 09:27 +0800, Ethan Zhao wrote:
> On Thu, Jan 16, 2014 at 6:00 AM, Brown, Aaron F <aaron.f.brown@intel.com> wrote:
> > On Wed, 2014-01-15 at 22:12 +0800, Ethan Zhao wrote:
> >> Because ixgbe driver limit the max number of VF functions could be enabled
> >> to 63, so define one macro IXGBE_MAX_VFS_DRV_LIMIT and cleanup the const 63
> >> in code.
> >>
> >> v2: fix a typo.
> >> v3: fix a encoding issue.
> >>
> >> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
> >> ---
> >>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  | 4 ++--
> >>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 5 +++--
> >>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.h | 5 +++++
> >>  3 files changed, 10 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> >> index 0ade0cd..47e9b44 100644
> >> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> >> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> >> @@ -4818,7 +4818,7 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter)
> >>  #ifdef CONFIG_PCI_IOV
> >>       /* assign number of SR-IOV VFs */
> >>       if (hw->mac.type != ixgbe_mac_82598EB)
> >> -             adapter->num_vfs = (max_vfs > 63) ? 0 : max_vfs;
> >
> >
> > Unfortunately the if statement got changed considerably with a recent
> > commit:
> >
> > commit 170e85430bcbe4d18e81b5a70bb163c741381092
> > ixgbe: add warning when max_vfs is out of range.
> >
> > And the pattern no longer exists to make a match.  In other words, this
> > patch no longer applies to net-next and I have to ask you for yet
> > another spin if you still want to squash the magic number.
> 
> It's not a good news. Our distro is waiting for this patch showing up in stable.
> OK, info me if there is a windows for me to revise the patch.

I don't think any particular window of time is better than another. I
don't see this change as needing very thorough testing so if you send in
(yet) another version I'll try to get it through our internal process as
rapidly as I can.

> 
> Thanks,
> Ethan
> 
> >
> > Thanks,
> > Aaron

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
