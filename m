Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaJ0N5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:57:38 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4349 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaJ0N5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:57:37 -0400
Message-ID: <544E4F3C.1010509@xs4all.nl>
Date: Mon, 27 Oct 2014 14:57:16 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Johann Klammer <klammerj@a1.net>
CC: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH][RESEND][TRIVIAL] Turn bothersome error into a debug message
References: <542AE6A6.9000504@a1.net> <544E4C57.9080302@a1.net>
In-Reply-To: <544E4C57.9080302@a1.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johann,

I've added this to my todo list and will look at this soon (next Friday or Monday
most likely).

	Hans

On 10/27/2014 02:44 PM, Johann Klammer wrote:
> Let's see if that works now...
> 
> On 09/30/2014 07:21 PM, Johann Klammer wrote:
>> Hello,
>>
>> After updating the kernel to 3.14.15 I am seeing these messages:
>>
>> [273684.964081] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep
>> timed out while waiting for registers getting programmed
>> [273690.020061] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep
>> timed out while waiting for registers getting programmed
>> [273695.076082] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep
>> timed out while waiting for registers getting programmed
>> [273700.132077] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep
>> timed out while waiting for registers getting programmed
>> [273705.188070] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep
>> timed out while waiting for registers getting programmed
>> [273710.244066] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep
>> timed out while waiting for registers getting programmed
>> [273715.300187] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep
>> timed out while waiting for registers getting programmed
>> [273720.356068] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep
>> timed out while waiting for registers getting programmed
>> [273725.412188] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep
>> timed out while waiting for registers getting programmed
>> [273730.468094] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep
>> timed out while waiting for registers getting programmed
>> [273735.524070] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep
>> timed out while waiting for registers getting programmed
>> [273740.580176] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep
>> timed out while waiting for registers getting programmed
>>
>> filling up the logs(one about every 5 seconds).
>>
>> The TV card is a Terratec Cinergy 1200 DVBS (I believe.. it's rather old).
>>
>> I can not observe any erratic behavior, just those pesky messages...
>>
>> I see there was an earlier post here in 2008 about a similar
>> problem...(Cinergy 1200 DVB-C... a coincidence?)
>>
>> What does it mean?
>> Do I need to be worried?
>>
>> I am using a debian testing on a 32 bit box.
>> The previous kernel was linux-image-3.12-1-486.
>> It did not show those messages, but maybe due to some configure
>> options... I built this one from linux-source-3.14...
>>
> Answering my own question:
> Other posts suggests that it is not actually an error on cards without a
> CI interface. Here's a patch that turns it into a debug message, so it
> does not clobber the logs.
> 
> Signed-off-by: Johann Klammer <klammerj@a1.net>
> --- linux-source-3.14/drivers/media/common/saa7146/saa7146_core.c.orig  2014-07-31 23:51:43.000000000 +0200
> +++ linux-source-3.14/drivers/media/common/saa7146/saa7146_core.c 2014-10-06 18:57:54.000000000 +0200
> @@ -71,7 +71,7 @@ static inline int saa7146_wait_for_debi_
>     if (saa7146_read(dev, MC2) & 2)
>       break;
>     if (err) {
> -     pr_err("%s: %s timed out while waiting for registers getting programmed\n",
> +     pr_debug("%s: %s timed out while waiting for registers getting programmed\n",
>              dev->name, __func__);
>       return -ETIMEDOUT;
>     }
> 
> 
