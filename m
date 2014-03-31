Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaCaRwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:52:32 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59810 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbaCaRw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:52:28 -0400
Message-ID: <5339AB59.4050906@mit.edu>
Date: Mon, 31 Mar 2014 10:52:25 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Zhanghailiang <zhang.zhanghailiang@huawei.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhouxiangjiu <zhouxiangjiu@huawei.com>,
        zhang yanying <zhuangyanying@huawei.com>
Subject: Re: VDSO pvclock may increase host cpu consumption, is this a problem?
References: <D1BD20B5DB34024DA951CEEE6C4C59985961AD4E@szxema505-mbs.china.huawei.com>
In-Reply-To: <D1BD20B5DB34024DA951CEEE6C4C59985961AD4E@szxema505-mbs.china.huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2014 01:47 AM, Zhanghailiang wrote:
> Hi,
> I found when Guest is idle, VDSO pvclock may increase host consumption.
> We can calcutate as follow, Correct me if I am wrong.
>       (Host)250 * update_pvclock_gtod = 1500 * gettimeofday(Guest)
> In Host, VDSO pvclock introduce a notifier chain, pvclock_gtod_chain in timekeeping.c. It consume nearly 900 cycles per call. So in consideration of 250 Hz, it may consume 225,000 cycles per second, even no VM is created.
> In Guest, gettimeofday consumes 220 cycles per call with VDSO pvclock. If the no-kvmclock-vsyscall is configured, gettimeofday consumes 370 cycles per call. The feature decrease 150 cycles consumption per call. 
> When call gettimeofday 1500 times,it decrease 225,000 cycles,equal to the host consumption.
> Both Host and Guest is linux-3.13.6.
> So, whether the host cpu consumption is a problem?

Does pvclock serve any real purpose on systems with fully-functional
TSCs?  The x86 guest implementation is awful, so it's about 2x slower
than TSC.  It could be improved a lot, but I'm not sure I understand why
it exists in the first place.

I certainly understand the goal of keeping the guest CLOCK_REALTIME is
sync with the host, but pvclock seems like overkill for that.

--Andy

