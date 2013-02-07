Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028Ab3BGRIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:08:36 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:7393
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756622Ab3BGRIf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:08:35 -0500
X-Forefront-Antispam-Report: CIP:198.70.193.117;KIP:(null);UIP:(null);IPV:NLI;H:avcashub1.qlogic.com;RD:avcashub3.qlogic.com;EFVD:NLI
X-SpamScore: -6
X-BigFish: VPS-6(zzbb2dI98dI9371I103dK1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2ei2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1155h)
From: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, netdev <netdev@vger.kernel.org>
CC: Eilon Greenstein <eilong@broadcom.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Sony Chacko <sony.chacko@qlogic.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        David Miller <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "bhutchings@solarflare.com" <bhutchings@solarflare.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: Re: [PATCHv2-net-3.8 2/3] qlcnic: set gso_type
Thread-Topic: [PATCHv2-net-3.8 2/3] qlcnic: set gso_type
Thread-Index: AQHOBTRjC8fXFqUiIEmCY/5n4luF0phuoRUA
Date: Thu, 7 Feb 2013 17:08:29 +0000
Message-ID: <BECD8E8A1B550B48A1BF97C13991F60E2AB64B@avmb2.qlogic.org>
In-Reply-To: <50a60e1293901965901edb46ae49e52da1d469d5.1360236441.git.mst@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.2.5.121010
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D8C730CC2BC9DA4E9BA5BDBA2DAE5D76@qlogic.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/13 5:13 AM, "Michael S. Tsirkin" <mst@redhat.com> wrote:

>qlcnic set gso_size but not gso type. This leads to crashes
>in macvtap.
>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>---
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
>b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
>index 6f82812..09aa310 100644
>--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
>+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
>@@ -986,8 +986,13 @@ qlcnic_process_lro(struct qlcnic_adapter *adapter,
> 	th->seq = htonl(seq_number);
> 	length = skb->len;
> 
>-	if (adapter->flags & QLCNIC_FW_LRO_MSS_CAP)
>+	if (adapter->flags & QLCNIC_FW_LRO_MSS_CAP) {
> 		skb_shinfo(skb)->gso_size = qlcnic_get_lro_sts_mss(sts_data1);
>+		if (skb->protocol == htons(ETH_P_IPV6))
>+			skb_shinfo(skb)->gso_type = SKB_GSO_TCPV6;
>+		else
>+			skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
>+	}
> 
> 	if (vid != 0xffff)
> 		__vlan_hwaccel_put_tag(skb, vid);
>-- 
>MST

Thanks!

Acked-by: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>


