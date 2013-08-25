Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3HYTlz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 15:41:55 -0400
Received: from void.printf.net ([89.145.121.20]:52254 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868Ab3HYTly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 15:41:54 -0400
From: Chris Ball <cjb@laptop.org>
To: Balaji T K <balajitk@ti.com>
Cc: Francesco Lavra <francescolavra.fl@gmail.com>, <linux-mmc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: omap_hsmmc: clear status flags before starting a new command
References: <51CE7DC8.2070905@gmail.com> <521A5D7C.4050208@ti.com>
Date: Sun, 25 Aug 2013 15:41:49 -0400
In-Reply-To: <521A5D7C.4050208@ti.com> (Balaji T. K.'s message of "Mon, 26 Aug
	2013 01:09:40 +0530")
Message-ID: <87haedpngi.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Aug 25 2013, Balaji T K wrote:
> On Saturday 29 June 2013 11:55 AM, Francesco Lavra wrote:
>> Commit 1f6b9fa40e76fffaaa0b3bd6a0bfdcf1cdc06efa consolidated writes to
>> the STAT register in one location, moving them from omap_hsmmc_do_irq()
>> to omap_hsmmc_irq(). This move has the unwanted side effect that the
>> controller status flags are potentially cleared after a new command has
>> been started as a consequence of reading the previous status flags.
>> This means that if the new command changes the status flags before the
>> IRQ routine returns, those flags may be cleared without handling the
>> event which asserted them, and thus missing the event.
>> Move the writing of the STAT register back in omap_hsmmc_do_irq(),
>> before handling the status flags which generated the interrupt.
>>
>> Signed-off-by: Francesco Lavra <francescolavra.fl@gmail.com>
>
> Reviewed and Tested-by: Balaji T K <balajitk@ti.com>

Thanks, pushed to mmc-next for 3.12.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
