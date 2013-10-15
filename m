Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3JOIHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 04:07:05 -0400
Received: from mailout03.t-online.de ([194.25.134.81]:40737 "EHLO
	mailout03.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab3JOIG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 04:06:59 -0400
Message-ID: <525CF790.2090805@t-online.de>
Date: Tue, 15 Oct 2013 10:06:40 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVj?= =?UTF-8?B?a2Vy?= 
	<fweisbec@gmail.com>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request during
 shutdown
References: <525BD08C.2080101@t-online.de> <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com> <20131014212830.GD5790@linux.vnet.ibm.com> <525C67B0.8020303@t-online.de> <20131014231603.GF5790@linux.vnet.ibm.com> <20131015005938.GA13655@linux.vnet.ibm.com>
In-Reply-To: <20131015005938.GA13655@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: ECp0TTZZghHk6IBxYZEYWNdbSmOtpoj2JrZF6qjImhLT2bQxRuMvKTncuCX18tHQzn
X-TOI-MSGID: 477c0bb0-3f64-4a78-b41e-0d474d718a03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.10.2013 02:59, Paul E. McKenney wrote:
> On Mon, Oct 14, 2013 at 04:16:03PM -0700, Paul E. McKenney wrote:
>> On Mon, Oct 14, 2013 at 11:52:48PM +0200, Knut Petersen wrote:
>>> On 14.10.2013 23:28, Paul E. McKenney wrote:
>>>> On Mon, Oct 14, 2013 at 10:53:03AM -0700, Linus Torvalds wrote:

>>>> I´ll run some tests with those debug parameters tomorrow. 
>>>> Any chance of a look at the .config file?
>>> Attached.
>> Thank you!  Looks like a pretty standard RCU setup.  Just to make sure
>> I saw it correctly -- you are running NR_CPUS=1?  Getting races to happen
>> in that mode is truly impressive!

Yes. The AOpen i915GMm-hfs  is a desktop board with mobile chipset for one Pentium-M.
As a musician I need an absolutely silent system, and the low power consumption of that
technology is a nice add-on.
> Ah, thing...  When running with only one CPU, both of synchronize_rcu_bh()
> and synchronize_sched() become essentially no-ops.  Anything that expected
> them to actually sleep would then break.
>
> However, because you are running with CONFIG_PREEMPT=y, synchronize_rcu()
> will still block.
>
> 							Thanx, Paul
>

