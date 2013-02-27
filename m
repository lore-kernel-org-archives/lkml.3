Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab3B0MWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 07:22:20 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:56315 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab3B0MWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 07:22:19 -0500
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2013 07:22:19 EST
Message-ID: <512DF827.1040508@simon.arlott.org.uk>
Date: Wed, 27 Feb 2013 12:12:23 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Helmut Schaa <helmut.schaa@googlemal.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rt2x00: allow AP and mesh mode to operate simultaneously
References: <20130221033302.1F06F660B25@gitolite.kernel.org>
In-Reply-To: <20130221033302.1F06F660B25@gitolite.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/02/13 03:33, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=4a5fc6d7074de72dd836fbb9c5cd79f9a491871c
> Commit:     4a5fc6d7074de72dd836fbb9c5cd79f9a491871c
> Parent:     92941382e8b80c55a4ad06b88a3bf95110969693
> Author:     Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> AuthorDate: Fri Jan 25 12:47:50 2013 +0800
> Committer:  John W. Linville <linville@tuxdriver.com>
> CommitDate: Wed Jan 30 15:06:44 2013 -0500
> 
>     rt2x00: allow AP and mesh mode to operate simultaneously
>     
>     Allow AP and Mesh mode to operate concurrently using
>     single radio. Verify this using fonera 2.0n featuring
>     RT3052 chipset and also TP-LINK TL-WN727N featuring
>     RT5370 chipset.

This breaks the probe of my RT3071 device (Tenda W322UA):
[ 4376.598444] phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 3071, rf: 0008, rev: 021c.
[ 4376.598700] ------------[ cut here ]------------
[ 4376.598717] WARNING: at net/wireless/core.c:443 wiphy_register+0x549/0x6c0 [cfg80211]()
[ 4376.598719] Hardware name: empty
[ 4376.598721] Modules linked in: rt2800usb(+) rt2800lib rt2x00usb rt2x00lib mac80211 cfg80211 8021q garp bnep rfcomm bridge stp ext4 jbd2 nf_conntrack_ipv6 ipt_REJECT nf_defrag_ipv6 iptable_filter xt_state iptable_mangle ip6t_REJECT iptable_nat xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat ip6table_filter xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_conntrack ip_tables xt_connmark nf_conntrack ip6_tables x_tables fuse btusb crc_ccitt kvm_amd bluetooth kvm zaurus cdc_ether usbnet crc16 [last unloaded: cfg80211]
[ 4376.598758] Pid: 15052, comm: modprobe Tainted: G        W    3.8.0+ #09507-g19cd6a2
[ 4376.598760] Call Trace:
[ 4376.598770]  [<ffffffff8104912a>] warn_slowpath_common+0x7a/0xc0
[ 4376.598773]  [<ffffffff81049185>] warn_slowpath_null+0x15/0x20
[ 4376.598779]  [<ffffffffa0293a79>] wiphy_register+0x549/0x6c0 [cfg80211]
[ 4376.598786]  [<ffffffffa002c57f>] ? rt2x00lib_probe_dev+0x34f/0x770 [rt2x00lib]
[ 4376.598801]  [<ffffffffa02c75e7>] ieee80211_register_hw+0x3a7/0x830 [mac80211]
[ 4376.598805]  [<ffffffffa002c7c2>] rt2x00lib_probe_dev+0x592/0x770 [rt2x00lib]
[ 4376.598809]  [<ffffffffa001c320>] rt2x00usb_probe+0x160/0x220 [rt2x00usb]
[ 4376.598818]  [<ffffffffa00ef240>] rt2800usb_probe+0x10/0x20 [rt2800usb]
[ 4376.598830]  [<ffffffff814b6b78>] usb_probe_interface+0x1d8/0x2b0
[ 4376.598835]  [<ffffffff81411406>] driver_probe_device+0x76/0x230
[ 4376.598838]  [<ffffffff8141165b>] __driver_attach+0x9b/0xa0
[ 4376.598842]  [<ffffffff814115c0>] ? driver_probe_device+0x230/0x230
[ 4376.598845]  [<ffffffff8140f916>] bus_for_each_dev+0x56/0x90
[ 4376.598849]  [<ffffffff81410f59>] driver_attach+0x19/0x20
[ 4376.598851]  [<ffffffff81410a96>] bus_add_driver+0xf6/0x260
[ 4376.598854]  [<ffffffff81411b73>] driver_register+0x73/0x160
[ 4376.598858]  [<ffffffffa010a000>] ? 0xffffffffa0109fff
[ 4376.598861]  [<ffffffff814b587a>] usb_register_driver+0x9a/0x150
[ 4376.598879]  [<ffffffffa010a000>] ? 0xffffffffa0109fff
[ 4376.598892]  [<ffffffffa010a01e>] rt2800usb_driver_init+0x1e/0x1000 [rt2800usb]
[ 4376.598906]  [<ffffffff810002f6>] do_one_initcall+0x116/0x160
[ 4376.598915]  [<ffffffff810986a2>] load_module+0x1b52/0x22a0
[ 4376.598918]  [<ffffffff810947c0>] ? sys_getegid16+0x50/0x50
[ 4376.598922]  [<ffffffff81098e94>] sys_init_module+0xa4/0xd0
[ 4376.598927]  [<ffffffff817544d6>] system_call_fastpath+0x1a/0x1f
[ 4376.598929] ---[ end trace 52dc8aa1355df590 ]---
[ 4376.598932] interface_modes=0000007e types=00000088 <-- interface_modes does not contain NL80211_IFTYPE_MESH_POINT
[ 4376.598934] phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.
[ 4376.598958] rt2800usb: probe of 1-4.6:1.0 failed with error -22

>     Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
>     Acked-by: Helmut Schaa <helmut.schaa@googlemal.com>
>     Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 92a0aa5..1031db6 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1236,7 +1236,8 @@ static inline void rt2x00lib_set_if_combinations(struct rt2x00_dev *rt2x00dev)
>  	 */
>  	if_limit = &rt2x00dev->if_limits_ap;
>  	if_limit->max = rt2x00dev->ops->max_ap_intf;
> -	if_limit->types = BIT(NL80211_IFTYPE_AP);
> +	if_limit->types = BIT(NL80211_IFTYPE_AP) |
> +			BIT(NL80211_IFTYPE_MESH_POINT);
>  
>  	/*
>  	 * Build up AP interface combinations structure.

-- 
Simon Arlott
