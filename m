Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3AVH52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:57:28 -0500
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:44612 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab3AVH51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:57:27 -0500
Message-ID: <20130122095021.89432qdbeu32a4sg@www.dalek.fi>
Date: Tue, 22 Jan 2013 09:50:21 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Matt Sealey <matt@genesi-usa.com>, Nicolas Pitre <nico@fluxnic.net>,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Russell King <linux@arm.linux.org.uk>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        Dave Martin <dave.martin@linaro.org>,
        David McCullough <david_mccullough@mcafee.com>
Subject: Re: [PATCH] crypto: fix FTBFS with ARM SHA1-asm and THUMB2_KERNEL
References: <1358787763-1226-1-git-send-email-matt@genesi-usa.com>
 <alpine.LFD.2.02.1301211739470.6300@xanadu.home>
 <CAKGA1bkQ9e8gmSPz_4csJWjEOKj3ZVqSLijSTRWxgDSaZoYqCA@mail.gmail.com>
 <20130122094614.79031aq5ddrgr2zo@www.dalek.fi>
In-Reply-To: <20130122094614.79031aq5ddrgr2zo@www.dalek.fi>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jussi Kivilinna <jussi.kivilinna@mbnet.fi>:

> Quoting Matt Sealey <matt@genesi-usa.com>:
>
>> This question is to the implementor/committer (Dave McCullough), how
>> exactly did you measure the benchmark and can we reproduce it on some
>> other ARM box?
>>
>> If it's long and laborious and not so important to test the IPsec
>> tunnel use-case, what would be the simplest possible benchmark to see
>> if the C vs. assembly version is faster for a particular ARM device? I
>> can get hold of pretty much any Cortex-A8 or Cortex-A9 that matters, I
>> have access to a Chromebook for A15, and maybe an i.MX27 or i.MX35 and
>> a couple Marvell boards (ARMv6) if I set my mind to it... that much
>> testing implies we find a pretty concise benchmark though with a
>> fairly common kernel version we can spread around (i.MX, OMAP and the
>> Chromebook, I can handle, the rest I'm a little wary of bothering to
>> spend too much time on). I think that could cover a good swath of
>> not-ARMv5 use cases from lower speeds to quad core monsters.. but I
>> might stick to i.MX to start with..
>
> There is 'tcrypt' module in crypto/ for quick benchmarking.  
> 'modprobe tcrypt mode=500 sec=1' tests AES in various cipher-modes,  
> using different buffer sizes and outputs results to kernel log.
>

Actually mode=200 might be better, as mode=500 is for asynchronous  
implementations and might use hardware crypto if such device/module is  
available.

-Jussi


