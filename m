Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbaFQHyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:54:43 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:11203 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaFQHym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:54:42 -0400
Message-ID: <539FF43E.2020002@atmel.com>
Date: Tue, 17 Jun 2014 09:54:38 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jongsung Kim <neidhard.kim@lge.com>,
        =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hayun Hwang <hwang.hayun@lge.com>,
        "Youngkyu Choi" <youngkyu7.choi@lge.com>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: Re: [PATCH] net/cadence/macb: clear interrupts simply and correctly
References: <1402563054-8546-1-git-send-email-neidhard.kim@lge.com> <7e888b59-d27b-49dc-9ffc-1c7d56f11773@BN1AFFO11FD007.protection.gbl> <539FB874.1040003@lge.com>
In-Reply-To: <539FB874.1040003@lge.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/06/2014 05:39, Jongsung Kim :
> On 06/17/2014 06:28 AM, Sören Brinkmann wrote:
>> Shouldn't it be sufficient to replace 'MACB_BIT(RCOMP) with 'MACB_RX_INT_FLAGS'
>> to clear all the RX IRQ flags.
> 
> I'm afraid not.
> 
> You know, this driver initially targeted only GEMs configured with "gem_irq_clear_read."
> For this implementation of GEM, the ISR is automatically cleared by reading. The driver
> was designed to operate with the value read from ISR, not with the ISR itself.
> 
> However, there are other GEMs configured without "gem_irq_clear_read," people like you
> and I working with. To support them, they insert similar codes conditionally clearing
> the ISR here and there. Now they are found at 6 places. Not enough yet. Do you want to
> insert another at the end of macb_reset_hw..? Maybe not.

Can't we separate a bit more the implementations of "clear on read" and
"clear on write" so that we do not spread the tests that you are talking
about all over the place and slower the driver's hot paths?

I am more and more skeptical about the mix of MACB/GEM versions in this
single driver as I realized recently that the old MACB-equipped devices
are behaving strangely and with lower performance figures than in the past.

Best regards,
-- 
Nicolas Ferre
