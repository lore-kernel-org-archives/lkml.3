Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3FITnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 15:43:40 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:63742 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3FITnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 15:43:39 -0400
MIME-Version: 1.0
In-Reply-To: <CACDNBm2Q+9KTs-57N9Y7YYHZhzYvyJN+4XFxuwRsS-XoEGyhbQ@mail.gmail.com>
References: <1369988485-23176-1-git-send-email-wangxfdu@gmail.com>
	<CAHp75Veb+FK=5u_HBUp+KNT4__GjbSg1T-kq1tGebDq2pEJOBA@mail.gmail.com>
	<CACDNBm3WJ_U22uqKuVssV4ntATTHnz_8=pq9_qa33S+eKreKSA@mail.gmail.com>
	<CAHp75VfeVZRzyW0jKH=oVPPQv3=tmg214D9=tBs0j3_==20UZg@mail.gmail.com>
	<CACDNBm1mjtHcE+Mm_y55xq2VW_8DVq+-1537M_FnqocWRhafsg@mail.gmail.com>
	<CAHp75VcQqZc+w9pud3oV4HB-BT1mdq04f=O2AtHZBXQ9fpCe0w@mail.gmail.com>
	<CACDNBm2Q+9KTs-57N9Y7YYHZhzYvyJN+4XFxuwRsS-XoEGyhbQ@mail.gmail.com>
Date: Sun, 9 Jun 2013 22:43:38 +0300
Message-ID: <CAHp75Vdh0Z1GPD0qNHZKdoLLhScWyLgsaNN8tsZkPB6eBDVd4g@mail.gmail.com>
Subject: Re: [PATCH] dma: mmp_pdma: support for getting residual bytes
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Xiang Wang <wangxfdu@gmail.com>
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 6:02 AM, Xiang Wang <wangxfdu@gmail.com> wrote:
> 2013/6/6 Andy Shevchenko <andy.shevchenko@gmail.com>:
>> On Thu, Jun 6, 2013 at 6:09 AM, Xiang Wang <wangxfdu@gmail.com> wrote:

[]

>>> 2. DMA controller handles trailing bytes for us.
>>> This is the case I mentioned in my previous email. "When a timed-out
>>> event occurs in peripheral device, it will notify DMA controller and
>>> DMA controller will send out a End of Receive interrupt"
>>> I think we should know how many residual bytes in this case even the
>>> DMA status is DMA_SUCCESS.
>>
>> I'm still not convinced that you have implement such algorithm. Anyway,
>> if I got it correctly you have something like "Receive FIFO Occupancy
>> Register (FOR)" in UART. When you got timeout interrupt, you may get
>> residue and value from FOR, sum them, program DMA to transfer the
>> trailing bytes.
>> What did I miss?
> This case is another working mode of peripheral device (e.g. UART). If
> we configure UART to work in this mode, the hardware(DMA controller
> and UART controller) will deal with the trailing bytes for us.
> The workflow is likely to be:
> a. When timeout occurs in UART, it notifies DMA controller to move the
> trailing bytes in UART FIFO. (software transparent)
> b. After DMA finishes moving all bytes in UART FIFO, it will send out
> an End Of Receive(EOR) interrupt.
> So in this case, software sees an EOR interrupt from DMA controller
> instead of an Timeout Interrupt from UART controller.

Thanks for explanation.

It's quite good your hw could manage such cases, though I thing it's
wrong to have residue great than 0 and DMA_SUCCESS as a status in the
driver.

So, if Vinod, Dan, or any experienced developer is okay with it, I'm okay too.

--
With Best Regards,
Andy Shevchenko
