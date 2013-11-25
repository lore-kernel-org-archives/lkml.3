Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab3KYOcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:32:47 -0500
Received: from natasha.panasas.com ([209.166.131.148]:59748 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab3KYOco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:32:44 -0500
X-Greylist: delayed 10636 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Nov 2013 09:32:44 EST
Message-ID: <52935F73.4090209@panasas.com>
Date: Mon, 25 Nov 2013 16:32:19 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: Yuanhan Liu <yuanhan.liu@linux.intel.com>, LKP <fnstml-lkp@cn.fujitsu.com>,
        Fengguang Wu <fengguang.wu@intel.com>, <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: CPU: 0 PID: 1 at init/main.c:711 do_one_initcall()
References: <20131122060223.GP9991@yliu-dev.sh.intel.com> <CAFLxGvynVV=aY755xTPTa7-57O25Dwzc+cbWELj+4xxFKznKMg@mail.gmail.com>
In-Reply-To: <CAFLxGvynVV=aY755xTPTa7-57O25Dwzc+cbWELj+4xxFKznKMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 04:15 PM, Richard Weinberger wrote:
> On Fri, Nov 22, 2013 at 7:02 AM, Yuanhan Liu
> <yuanhan.liu@linux.intel.com> wrote:
>> Greetings,
>>
>> I got the below dmesg and the first bad commit is
>>
>> commit 20545536cd8ea949c61527b6395ec8c0d2c237b1
>> Author: Boaz Harrosh <bharrosh@panasas.com>
>> Date:   Thu Jul 19 15:22:37 2012 +0300
>>
>>     RFC: do_xor_speed Broken on UML do to jiffies
>>
>>     Remember that hang I reported a while back on UML. Well
>>     I'm at it again, and it still hangs and I found why.
>>
>>     I have dprinted jiffies and it never advances during the
>>     loop at do_xor_speed. There for it is stuck in an endless
>>     loop. I have also dprinted current_kernel_time() and it
>>     returns the same constant value as well.
>>
>>     Note that it does usually work on UML, only during
>>     the modprobe of xor.ko while that test is running. It looks
>>     like some lucking is preventing the clock from ticking.
>>
>>     However ktime_get_ts does work for me so I changed the code
>>     as below, so I can work. See how I put several safety
>>     guards, to never get hangs again.
>>     And I think my time based approach is more accurate then
>>     previous system.
>>
>>     UML guys please investigate the jiffies issue? what is
>>     xor.ko not doing right?
> 
> This patch never hit my mailbox...
> 
>>     Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>>

Sir Richard

I never followed on this patch. Sorry. I do think it is in
the right direction, but it has a dev-by-zero problem and
a 32 bitness problem. (So I never sent it, beyond the initial
query)

[It stopped to be very important for me since I stopped using
 UM very much. Ever since FC17 I'm unable to produce a running
 image. It just will not boot, an image that a kvm would. So
 very sad me, but no UML for me anymore.]

If you want to investigate. try doing a modprobe xor.ko on
a uml and see. since xor.ko is only built on demand for example
enabling exofs or object-layout-driver will select it. ,or MD-raid5.

Thanks
Boaz

