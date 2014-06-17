Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbaFQDjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 23:39:36 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:57154 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbaFQDje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 23:39:34 -0400
X-Original-SENDERIP: 10.178.37.74
X-Original-MAILFROM: neidhard.kim@lge.com
Message-ID: <539FB874.1040003@lge.com>
Date: Tue, 17 Jun 2014 12:39:32 +0900
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
References: <1402563054-8546-1-git-send-email-neidhard.kim@lge.com> <7e888b59-d27b-49dc-9ffc-1c7d56f11773@BN1AFFO11FD007.protection.gbl>
In-Reply-To: <7e888b59-d27b-49dc-9ffc-1c7d56f11773@BN1AFFO11FD007.protection.gbl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 06:28 AM, Sören Brinkmann wrote:
> Shouldn't it be sufficient to replace 'MACB_BIT(RCOMP) with 'MACB_RX_INT_FLAGS'
> to clear all the RX IRQ flags.

I'm afraid not.

You know, this driver initially targeted only GEMs configured with "gem_irq_clear_read."
For this implementation of GEM, the ISR is automatically cleared by reading. The driver
was designed to operate with the value read from ISR, not with the ISR itself.

However, there are other GEMs configured without "gem_irq_clear_read," people like you
and I working with. To support them, they insert similar codes conditionally clearing
the ISR here and there. Now they are found at 6 places. Not enough yet. Do you want to
insert another at the end of macb_reset_hw..? Maybe not.

Jongsung
