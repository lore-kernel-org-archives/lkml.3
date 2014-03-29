Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaC2Iry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 04:47:54 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:11945 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbaC2Irv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 04:47:51 -0400
From: Zhanghailiang <zhang.zhanghailiang@huawei.com>
To: "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhouxiangjiu <zhouxiangjiu@huawei.com>,
        zhang yanying <zhuangyanying@huawei.com>
Subject: VDSO pvclock may increase host cpu consumption, is this a problem?
Thread-Topic: VDSO pvclock may increase host cpu consumption, is this a
 problem?
Thread-Index: Ac9LK4P7lwEybLX9ToepDSfeMHiCoQ==
Date: Sat, 29 Mar 2014 08:47:27 +0000
Message-ID: <D1BD20B5DB34024DA951CEEE6C4C59985961AD4E@szxema505-mbs.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.22.69]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I found when Guest is idle, VDSO pvclock may increase host consumption.
We can calcutate as follow, Correct me if I am wrong.
      (Host)250 * update_pvclock_gtod = 1500 * gettimeofday(Guest)
In Host, VDSO pvclock introduce a notifier chain, pvclock_gtod_chain in timekeeping.c. It consume nearly 900 cycles per call. So in consideration of 250 Hz, it may consume 225,000 cycles per second, even no VM is created.
In Guest, gettimeofday consumes 220 cycles per call with VDSO pvclock. If the no-kvmclock-vsyscall is configured, gettimeofday consumes 370 cycles per call. The feature decrease 150 cycles consumption per call. 
When call gettimeofday 1500 times,it decrease 225,000 cycles,equal to the host consumption.
Both Host and Guest is linux-3.13.6.
So, whether the host cpu consumption is a problem?

Thanks.
Zhang hailiang
