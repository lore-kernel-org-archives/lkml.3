Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaDADq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 23:46:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaDADqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 23:46:08 -0400
Date: Mon, 31 Mar 2014 18:30:32 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Zhanghailiang <zhang.zhanghailiang@huawei.com>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhouxiangjiu <zhouxiangjiu@huawei.com>,
        zhang yanying <zhuangyanying@huawei.com>
Subject: Re: VDSO pvclock may increase host cpu consumption, is this a
 problem?
Message-ID: <20140331213032.GA5866@amt.cnet>
References: <D1BD20B5DB34024DA951CEEE6C4C59985961AD4E@szxema505-mbs.china.huawei.com>
 <5339AB59.4050906@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5339AB59.4050906@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 10:52:25AM -0700, Andy Lutomirski wrote:
> On 03/29/2014 01:47 AM, Zhanghailiang wrote:
> > Hi,
> > I found when Guest is idle, VDSO pvclock may increase host consumption.
> > We can calcutate as follow, Correct me if I am wrong.
> >       (Host)250 * update_pvclock_gtod = 1500 * gettimeofday(Guest)
> > In Host, VDSO pvclock introduce a notifier chain, pvclock_gtod_chain in timekeeping.c. It consume nearly 900 cycles per call. So in consideration of 250 Hz, it may consume 225,000 cycles per second, even no VM is created.
> > In Guest, gettimeofday consumes 220 cycles per call with VDSO pvclock. If the no-kvmclock-vsyscall is configured, gettimeofday consumes 370 cycles per call. The feature decrease 150 cycles consumption per call. 
> > When call gettimeofday 1500 times,it decrease 225,000 cycles,equal to the host consumption.
> > Both Host and Guest is linux-3.13.6.
> > So, whether the host cpu consumption is a problem?
> 
> Does pvclock serve any real purpose on systems with fully-functional
> TSCs?  The x86 guest implementation is awful, so it's about 2x slower
> than TSC.  It could be improved a lot, but I'm not sure I understand why
> it exists in the first place.

VM migration.

Can you explain why you consider it so bad ? How you think it could be
improved ?

> I certainly understand the goal of keeping the guest CLOCK_REALTIME is
> sync with the host, but pvclock seems like overkill for that.

VM migration.

