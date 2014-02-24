Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaBXQxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:53:49 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33211 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbaBXQxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:53:47 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,7358"; a="16056767"
X-IronPort-AV: E=Sophos;i="4.97,535,1389772800"; 
   d="scan'208";a="689300749"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Will Deacon <will.deacon@arm.com>
CC: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pavel Machek <pavel@ucw.cz>, Sebastian Reichel <sre@ring0.de>,
        Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>,
        <linville@tuxdriver.com>
Subject: Re: [BISECTED] ssh - Received disconnect from x.x.x.x: 2: Bad packet length 3149594624
References: <52FD08D1.3030405@gmail.com>
	<20140213182105.GN13576@mudshark.cambridge.arm.com>
	<52FD1243.9040706@gmail.com>
	<20140213192909.GO13576@mudshark.cambridge.arm.com>
	<52FE407C.3080002@gmail.com>
	<20140214162458.GF21986@mudshark.cambridge.arm.com>
Date: Mon, 24 Feb 2014 18:52:53 +0200
In-Reply-To: <20140214162458.GF21986@mudshark.cambridge.arm.com> (Will
	Deacon's message of "Fri, 14 Feb 2014 16:24:58 +0000")
Message-ID: <877g8ktpui.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Deacon <will.deacon@arm.com> writes:
> Well, we probably need a bit more to go on, because I doubt that this code
> is to blame. More likely, the issue is in the caller.
> Looking at drivers/net/wireless/ti/wl1251/rx.c:182
>
>         /* The actual length doesn't include the target's alignment */
>         skb->len = desc->length  - PLCP_HEADER_LENGTH;
>
>         fc = (u16 *)skb->data;
>
>         if ((*fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON)
>                 beacon = 1;
>
>         wl1251_rx_status(wl, desc, &status, beacon);
>
>         wl1251_debug(DEBUG_RX, "rx skb 0x%p: %d B %s", skb, skb->len,
>                      beacon ? "beacon" : "");
>
>         memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
>         ieee80211_rx_ni(wl->hw, skb);
>
> I wonder whether that first line (with the comment about alignment) is
> assuming some behaviour from the mac80211 layer.
>
> You could try putting back the UNALIGNED_ACCESS in net/mac80211/rx.c and
> commenting out the skb->len = desc->length  - PLCP_HEADER_LENGTH;  line
> above.
>
> Adding the original author (I think) and John Linville, since I'm well out
> of my depth in this code!

I haven't touched wl1251 for years. You should send questions to
linux-wireless list and CC people who have worked on it recently.

-- 
Kalle Valo
