Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbaJCWSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:18:46 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:34165 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756872AbaJCWSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:18:43 -0400
Message-ID: <542F20B0.9020807@gmail.com>
Date: Fri, 03 Oct 2014 15:18:24 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH to be tested] serial: msm_serial: add missing sysrq handling
References: <53E2C573.7090709@gmail.com> <53EAB01B.5030102@codeaurora.org> <53EC1FEA.5070907@gmail.com> <53EC220D.5050908@gmail.com> <542F167D.2020302@codeaurora.org>
In-Reply-To: <542F167D.2020302@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/2014 2:34 PM, Stephen Boyd wrote:
> Hi Frank,
> 
> On 08/13/14 19:42, Frank Rowand wrote:
>> On 8/13/2014 7:33 PM, Frank Rowand wrote:
>>> On 8/12/2014 5:23 PM, Stephen Boyd wrote:
>>>> On 08/06/14 17:16, Frank Rowand wrote:
>> < snip >
>>  
>>> The patches you sent are a little hard to read since they modify further code
>>> that my patch modified.  So I have redone your patches, as if my patch was
>>> not previously applied.  Hopefully I did not make any mistakes there.  I will
>>> reply to this email with each of your redone patches.
>> Stephen's patch alternative number 2:
> 
> I had a discussion with the hardware engineer. Apparently the break bit
> in the SR register is not "sticky" so it doesn't always stay set when
> the handle_rx_dm() function runs and a break has entered the fifo. I
> used your debug patches to confirm this (I never see the break status
> bit when the fifo has multiple characters in it). It sounds like this
> bit can't really be used reliably. The recommendation is to use either
> the break start or break stop interrupt to detect when a break has
> occurred and then search the fifo for the break character (an all zero
> character). If there are two such characters then we can't be certain
> when the break was, but the chances of this seem really slim considering
> that the stale timeout probably triggers first before a human can type a
> character after the break.

That sounds good to me.

> On 1.4 hardware we can change the mode to be single character and then
> we can reliably detect the break character because only one character
> enters the fifo and the higher bits of the fifo can be used to detect if
> it is a break or not. Making that change is probably not that hard, I
> believe we can reuse all the handle_rx_dm logic and force single
> character mode on consoles, but 1.3 hardware doesn't benefit from this
> change. I'll try to get something together soon that tries to make this
> all work as best as it can.

Thanks!  I'll be glad to review and test.  And whatever else I can do to
help.

-Frank
