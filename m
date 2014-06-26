Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbaFZGOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 02:14:00 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:34342 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaFZGN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 02:13:58 -0400
From: "Zhangbo (Oscar)" <oscar.zhangbo@huawei.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Yanxiaodan <yanxiaodan@huawei.com>,
        "Zhoujian (jay, Euler)" <jianjay.zhou@huawei.com>,
        Luonengjun <luonengjun@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        Yanqiangjun <yanqiangjun@huawei.com>,
        "Zhaoyanbin (A)" <lefty.zhao@huawei.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        Alexander Gordeev <agordeev@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Subject: X86/irq: failed to assign vectors from CPU0
Thread-Topic: X86/irq: failed to assign vectors from CPU0
Thread-Index: Ac+RBcWz2QMmDFo9QNa/6nL2JzKQvA==
Date: Thu, 26 Jun 2014 06:13:39 +0000
Message-ID: <0259E1C966E8C54AA93AA2B1240828E62C52C674@szxema507-mbs.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.20.95]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.53ABBA1F.0041,ss=1,re=0.000,fgs=0,
	ip=169.254.6.169,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: eb72adfce98b91ea71be5bbf71739be0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Msi or Msi-x interrupts assign vectors from a CPU while the number of CUPs is more than 8. __assign_irq_vector() is responsible for assigning vectors from low-numbered CPUs by default. 
	If there are a lot of Msi or Msi-x interrupts, it will cause the low-numbered CPUs out of vectors, so the subsequent interrupts will be failed to allocate vectors from these CPUs. 
	What is the consideration of preferentially assigning vectors from low-numbered CPUs? How about assigning vectors from the CPUs which have the maximum number of unused vectors?
	Thank you in advance.
