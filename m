Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaC2Oqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 10:46:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbaC2Oqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 10:46:35 -0400
Date: Sat, 29 Mar 2014 11:46:07 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zhanghailiang <zhang.zhanghailiang@huawei.com>
Cc: "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhouxiangjiu <zhouxiangjiu@huawei.com>,
        zhang yanying <zhuangyanying@huawei.com>
Subject: Re: VDSO pvclock may increase host cpu consumption, is this a
 problem?
Message-ID: <20140329144607.GA20316@amt.cnet>
References: <D1BD20B5DB34024DA951CEEE6C4C59985961AD4E@szxema505-mbs.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D1BD20B5DB34024DA951CEEE6C4C59985961AD4E@szxema505-mbs.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 08:47:27AM +0000, Zhanghailiang wrote:
> Hi,
> I found when Guest is idle, VDSO pvclock may increase host consumption.
> We can calcutate as follow, Correct me if I am wrong.
>       (Host)250 * update_pvclock_gtod = 1500 * gettimeofday(Guest)
> In Host, VDSO pvclock introduce a notifier chain, pvclock_gtod_chain in timekeeping.c. It consume nearly 900 cycles per call. So in consideration of 250 Hz, it may consume 225,000 cycles per second, even no VM is created.
> In Guest, gettimeofday consumes 220 cycles per call with VDSO pvclock. If the no-kvmclock-vsyscall is configured, gettimeofday consumes 370 cycles per call. The feature decrease 150 cycles consumption per call. 
> When call gettimeofday 1500 times,it decrease 225,000 cycles,equal to the host consumption.
> Both Host and Guest is linux-3.13.6.
> So, whether the host cpu consumption is a problem?

Hi,

How many percents out of the total CPU cycles are 225,000 cycles, for your
CPU ?

