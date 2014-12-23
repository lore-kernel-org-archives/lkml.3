Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbaLWFgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 00:36:52 -0500
Received: from ispman.iskranet.ru ([62.213.33.10]:39467 "EHLO
	ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaLWFgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 00:36:51 -0500
Message-ID: <5498FF69.2080000@kb.kras.ru>
Date: Tue, 23 Dec 2014 12:36:41 +0700
From: Arseny Solokha <asolokha@kb.kras.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] OHCI: add a quirk for ULi M5237 blocking on reset
References: <Pine.LNX.4.44L0.1412060945160.25285-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1412060945160.25285-100000@netrider.rowland.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 6 Dec 2014, Arseny Solokha wrote:
> 
>> From: Arseny Solokha <asolokha@kb.kras.ru>
>>
>> Commit 8dccddbc2368 ("OHCI: final fix for NVIDIA problems (I hope)")
>> introduced into 3.1.9 broke boot on e.g. Freescale P2020DS development
>> board. The code path that was previously specific to NVIDIA controllers
>> had then become taken for all chips.
>>
>> However, the M5237 installed on the board wedges solid when accessing
>> its base+OHCI_FMINTERVAL register, making it impossible to boot any
>> kernel newer than 3.1.8 on this particular and apparently other similar
>> machines.
>>
>> Don't readl() and writel() base+OHCI_FMINTERVAL on PCI ID 10b9:5237.
>>
>> The patch is suitable for the -next tree as well as all maintained
>> kernels up to 3.2 inclusive.
>>
>> Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
>> ---
>> Changes in v2:
>> - review comments applied
> 
> Much better this time.
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Meanwhile, I discovered a similar thread where the issue was previously
discussed, and have tried to implement a workaround suggested in [1]. No luck so
far: even if the code manages to check a value returned by
readl(base + OHCI_FMINTERVAL), it then still hangs during device unregistering.

Of course, unregistering a device instead of just not accessing OHCI_FMINTERVAL
like in my or Nikita's patch is also possible but it requires hardcoding all
flawed device IDs instead of figuring out misbehaving devices at boot time.


[1] https://lkml.org/lkml/2014/5/29/828

Arsény
