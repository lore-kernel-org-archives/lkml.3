Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbaFQEmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 00:42:52 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45367 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbaFQEmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 00:42:49 -0400
X-Original-SENDERIP: 10.178.37.74
X-Original-MAILFROM: neidhard.kim@lge.com
Message-ID: <539FC747.3060908@lge.com>
Date: Tue, 17 Jun 2014 13:42:47 +0900
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
References: <1402563054-8546-1-git-send-email-neidhard.kim@lge.com> <9f5be687-d127-49a4-90ea-c1033505452d@BN1BFFO11FD019.protection.gbl> <539E79F1.1090006@lge.com> <ea57b37f-1f1c-40a0-84a6-46b0b78ec6b4@BY2FFO11FD034.protection.gbl> <539FAA34.9030002@lge.com> <0f1d404c-89a7-4bbd-99ff-973d4f26d2c6@BY2FFO11FD005.protection.gbl>
In-Reply-To: <0f1d404c-89a7-4bbd-99ff-973d4f26d2c6@BY2FFO11FD005.protection.gbl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 12:50 PM, Sören Brinkmann wrote:
> On Tue, 2014-06-17 at 11:38AM +0900, Jongsung Kim wrote:
>> On 06/16/2014 11:56 PM, Sören Brinkmann wrote:
>>> On Mon, 2014-06-16 at 02:00PM +0900, Jongsung Kim wrote:
>>>> On 06/13/2014 12:44 AM, Sören Brinkmann wrote:
>>>>> This is now clearing all IRQ flags which is probably not what we want
>>>>> here. This is handling RX only. We still want the non-RX interrupts to go to
>>>>> the actual interrupt service routing.
>>>>
>>>> The ISR(Interrupt Status Register) is read only in the interrupt service
>>>> routine, macb_interrupt. But is partially cleared here and there. Further
>>>> handler-functions decide jobs to be done by reading/checking other status
>>>> registers. (e.g., TSR, RSR) So, clearing the ISR after reading looks not
>>>> a bad idea.
>>>
>>> But you are clearing _all_ interrupt flags in the RX NAPI handler.
>>> Doesn't that mean we might miss certain events?
>>
>> Please inspect my patch again. What I did in the macb_poll is removing
>> statements clearing the Rx-complete interrupt, not clearing all the
>> interrupts.
> 
> Why is clearing those bits removed? It's probably not a big hit, but it might
> result in a pointless interrupt which could be avoided. But it should
> probably clear all RX interrupts - MACB_RX_INT_FLAGS - instead of just RCOMP.
> For clear-on-read implementations it shouldn't make a difference.

I agree. But I removed it because I think stepping the same procedure
regardless of the "gem_irq_clear_read" implementation is better than
implementation-specific optimization.

> And in the if-condition in that new helper, I'd add '&& status' to
> avoid writing back zeros.

Good point. I'll add it when I resend v2.

Jongsung
