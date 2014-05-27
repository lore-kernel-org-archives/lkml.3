Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaE0HpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:45:24 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:32338 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaE0HpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:45:23 -0400
Message-ID: <53844277.3050204@huawei.com>
Date: Tue, 27 May 2014 15:44:55 +0800
From: Libo Chen <libo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, "Li Zefan" <lizefan@huawei.com>,
        <peterz@infradead.org>
Subject: Re: balance storm
References: <5382AF2E.1040407@huawei.com>	 <1401090987.5339.79.camel@marge.simpson.net> <53832A36.5020205@huawei.com> <1401112989.23186.28.camel@marge.simpson.net>
In-Reply-To: <1401112989.23186.28.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.22.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/26 22:03, Mike Galbraith wrote:
> On Mon, 2014-05-26 at 19:49 +0800, Libo Chen wrote:
> 
>> how to turn off SD_SHARE_PKG_RESOURCES in userspace ?
> 
> I use a script Ingo gave me years and years ago to
> twiddle /proc/sys/kernel/sched_domain/cpuN/domainN/flags domain wise.
> Doing that won't do you any good without a handler to build/tear down
> sd_llc when you poke at flags though.  You can easily add a sched
> feature to play with it.


I make a simple script：

   for ((i=0;i<=15;i++))
   do
           echo 4143 > /proc/sys/kernel/sched_domain/cpu$i/domain1/flags
   done

In our kernel  SD_SHARE_PKG_RESOURCE is 0x0200, the original flag value is 4655,
domain1's name is MC.

but migrations event doesn't reduce like yours, what problem?  I wouldn't like
recompile kernel :(


> 
> -Mike
> 
> 
> 


