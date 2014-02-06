Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbaBFLgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 06:36:41 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:32820 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbaBFLgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 06:36:39 -0500
Date: Thu, 6 Feb 2014 12:36:31 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <84816226.20140206123631@eikelenboom.it>
To: Dan Williams <dan.j.williams@intel.com>
CC: Francois Romieu <romieu@fr.zoreil.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 3.14-mw regression: rtl8169 WARNING: DMA-API: exceeded 7 overlapping mappings of pfn 55ebe
In-Reply-To: <CAA9_cme2hgJ=jCDkPh5n5RP8fiJE-dVwbFr-apKv1=mNGPHYZg@mail.gmail.com>
References: <1859471893.20140126115521@eikelenboom.it> <20140127000305.GA14236@electric-eye.fr.zoreil.com> <CAA9_cme2hgJ=jCDkPh5n5RP8fiJE-dVwbFr-apKv1=mNGPHYZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan / Francois,

Didn't have time to test it before, but the patch doesn't seem to help.
I'm still getting the "DMA-API: exceeded 7 overlapping mappings of pfn 55ebe",
but i see now i forgot to mention i use r8169.use_dac=1 ...

Not using it seems to prevent the warning, but before 3.14 i have never seen this (with r8169.use_dac=1)

--
Sander

Wednesday, January 29, 2014, 4:06:24 AM, you wrote:

> On Sun, Jan 26, 2014 at 4:03 PM, Francois Romieu <romieu@fr.zoreil.com> wrote:
>> Sander Eikelenboom <linux@eikelenboom.it> :
>> [...]
>>> I have got a regression with a 3.14-mw kernel (last commit is 4ba9920e5e9c0e16b5ed24292d45322907bb9035):
>>> It looks like it's related to the rtl8169 ...
>>>
>>> --
>>> Sander
>>>
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.105537] ------------[ cut here ]------------
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.116779] WARNING: CPU: 0 PID: 0 at lib/dma-debug.c:491 add_dma_entry+0x103/0x130()
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.128148] DMA-API: exceeded 7 overlapping mappings of pfn 55ebe
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.139397] Modules linked in:
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.150535] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-20140125-mw-pcireset+ #1
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.161784] Hardware name: MSI MS-7640/890FXA-GD70 (MS-7640)  , BIOS V1.8B1 09/13/2010
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.172965]  0000000000000009 ffff88005f603838 ffffffff81acbcfa ffffffff822134e0
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.184156]  ffff88005f603888 ffff88005f603878 ffffffff810bdf62 ffff880000000000
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.195186]  0000000000055ebe 00000000ffffffef 0000000000000200 ffff8800592ea098
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.206227] Call Trace:
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.217027]  <IRQ>  [<ffffffff81acbcfa>] dump_stack+0x46/0x58
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.227907]  [<ffffffff810bdf62>] warn_slowpath_common+0x82/0xb0
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.238678]  [<ffffffff810be031>] warn_slowpath_fmt+0x41/0x50
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.249336]  [<ffffffff81471c5a>] ? active_pfn_read_overlap+0x3a/0x70
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.259904]  [<ffffffff814729e3>] add_dma_entry+0x103/0x130
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.270416]  [<ffffffff81472de6>] debug_dma_map_page+0x126/0x150
>>> Jan 26 11:36:26 serveerstertje kernel: [   89.280840]  [<ffffffff81714686>] rtl8169_start_xmit+0x216/0xa20
>> [r8169 and xen stuff]
>>
>> Dan, I miss the part of the debug code that tells where the mappings were
>> previously set.

> In this case it was a facepalm mistake on my part.  The mappings were
> not being properly accounted in the last revision of the patch I sent.
>  I copied you on the fix [1].

> --
> Dan

> [1]: http://marc.info/?l=linux-netdev&m=139096447627032&w=2


