Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaFPFAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 01:00:37 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:45051 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaFPFAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 01:00:35 -0400
X-Original-SENDERIP: 10.178.37.74
X-Original-MAILFROM: neidhard.kim@lge.com
Message-ID: <539E79F1.1090006@lge.com>
Date: Mon, 16 Jun 2014 14:00:33 +0900
From: Jongsung Kim <neidhard.kim@lge.com>
Organization: LG Electronics
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hayun Hwang <hwang.hayun@lge.com>,
        Youngkyu Choi <youngkyu7.choi@lge.com>
Subject: Re: [PATCH] net/cadence/macb: clear interrupts simply and correctly
References: <1402563054-8546-1-git-send-email-neidhard.kim@lge.com> <9f5be687-d127-49a4-90ea-c1033505452d@BN1BFFO11FD019.protection.gbl>
In-Reply-To: <9f5be687-d127-49a4-90ea-c1033505452d@BN1BFFO11FD019.protection.gbl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 12:44 AM, Sören Brinkmann wrote:
> Hi Jongsung,

Hi Sören,

> Does this interrupt need to be enabled? There is nothing checking
> that bit and handling this IRQ in the handler, AFAICT. And you solve
> this by simply clearing the bit. So, I wonder whether not enabling this
> IRQ in the first place would solve things too.

The driver actually checks the bit, but does not clear it. Disabling the
"Rx used bit read" interrupt you said may be a solution. However, I think
it is the better way to clear the exceptional HW-state rather than just to
mask it.

> This is now clearing all IRQ flags which is probably not what we want
> here. This is handling RX only. We still want the non-RX interrupts to go to
> the actual interrupt service routing.

The ISR(Interrupt Status Register) is read only in the interrupt service
routine, macb_interrupt. But is partially cleared here and there. Further
handler-functions decide jobs to be done by reading/checking other status
registers. (e.g., TSR, RSR) So, clearing the ISR after reading looks not
a bad idea.

Jongsung
