Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaANSrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:47:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55142 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbaANSru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:47:50 -0500
Message-ID: <52D58647.4010208@zytor.com>
Date: Tue, 14 Jan 2014 10:47:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Fengguang Wu <fengguang.wu@intel.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86, kaslr] BUG: kernel boot hang
References: <20140114133125.GB26942@localhost> <CAGXu5jKqx6JYBhHf08ru9B62RdD1A_WX7on64Cw-v1wYKT2jnQ@mail.gmail.com>
In-Reply-To: <CAGXu5jKqx6JYBhHf08ru9B62RdD1A_WX7on64Cw-v1wYKT2jnQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 10:26 AM, Kees Cook wrote:
>>
>> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
>> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
>> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
>> [    0.000000] BRK [0x07886000, 0x07886fff] PGTABLE
>> [    0.000000] BRK [0x07887000, 0x07887fff] PGTABLE
>> [    0.000000] BRK [0x07888000, 0x07888fff] PGTABLE
>> PANIC: early exception 0e rip 10:ffffffff86204c6e error 0 cr2 ffffffff81972b28
>> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-rc4-00008-g6e6a493 #614
>> PANIC: early exception 0e rip 10:ffffffff86204f22 error 0 cr2 ffffffff81972b28
> 
> I will try to reproduce this, but it's not clear to me what is causing
> the failure. The generated config doesn't look insane to me, so I'm
> not sure what's happening here. Is QEMU doing something unexpected
> with the ordering of where things go for its boot loader?
> 

It used to, but I fixed it up a long time ago and now it is really bog
standard.

More likely it just happens to trigger a corner condition, which is
actually a good thing... much easier to debug in a simulator.

	-hpa


