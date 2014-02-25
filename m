Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaBYK6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:58:38 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57461 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbaBYK6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:58:37 -0500
Date: Tue, 25 Feb 2014 10:57:56 +0000
From: Will Deacon <will.deacon@arm.com>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pavel Machek <pavel@ucw.cz>, Sebastian Reichel <sre@ring0.de>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        "kvalo@qca.qualcomm.com" <kvalo@qca.qualcomm.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [BISECTED] ssh - Received disconnect from x.x.x.x: 2: Bad packet
 length 3149594624
Message-ID: <20140225105756.GB22279@mudshark.cambridge.arm.com>
References: <52FD08D1.3030405@gmail.com>
 <20140213182105.GN13576@mudshark.cambridge.arm.com>
 <52FD1243.9040706@gmail.com>
 <20140213192909.GO13576@mudshark.cambridge.arm.com>
 <52FE407C.3080002@gmail.com>
 <20140214162458.GF21986@mudshark.cambridge.arm.com>
 <530C4C9B.7050104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530C4C9B.7050104@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivaylo,

On Tue, Feb 25, 2014 at 07:56:11AM +0000, Ivaylo Dimitrov wrote:
> On 14.02.2014 18:24, Will Deacon wrote:
> > You could try putting back the UNALIGNED_ACCESS in net/mac80211/rx.c and
> > commenting out the skb->len = desc->length  - PLCP_HEADER_LENGTH;  line
> > above.
> >
> 
> the following patch
> 
> diff --git a/drivers/net/wireless/ti/wl1251/rx.c 
> b/drivers/net/wireless/ti/wl1251/rx.c
> index 123c4bb..cde0eaf 100644
> --- a/drivers/net/wireless/ti/wl1251/rx.c
> +++ b/drivers/net/wireless/ti/wl1251/rx.c
> @@ -180,7 +180,7 @@ static void wl1251_rx_body(struct wl1251 *wl,
>          wl1251_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);
> 
>          /* The actual length doesn't include the target's alignment */
> -       skb->len = desc->length  - PLCP_HEADER_LENGTH;
> +       skb_trim(skb, desc->length - PLCP_HEADER_LENGTH);
> 
>          fc = (u16 *)skb->data;
> 
> seems to fix the issue, including those "corrupt probe response" 
> messages in dmesg log (I took that 'skb_trim' from the original Nokia 
> kernel). Will send a properly formatted patch shortly.

Good idea -- don't forget to CC linux-wireless, as suggested by Kalle.

Will
