Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbbAWIAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:00:39 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:2847 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbbAWIAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:00:37 -0500
Message-ID: <54C1FF44.1090902@huawei.com>
Date: Fri, 23 Jan 2015 15:59:00 +0800
From: "Ouyang Zhaowei (Charles)" <ouyangzhaowei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
CC: <linux-kernel@vger.kernel.org>, <suoben@huawei.com>,
        <liuyingdong@huawei.com>, <weiping.ding@huawei.com>
Subject: xen-blkfront: weird behavior of "iostat" after VM live-migrate which
 xen-blkfront module has indirect descriptors
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.30.65]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.54C1FF55.0183,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 105b6262ecf276f5c83705b5f15d9c47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

We are testing the indirect feature of xen-blkfront module these days.
And we found that, after VM live-migrate a couple of times, the "%util" of iostat keeps being 100%, and there are several requests stock in "avgqu-sz".
We have checked some later version of Linux, and it happens on Ubuntu 14.04, Ubuntu 14.10 and RHEL 7.0.

The iostat shows like below:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.00    0.00    0.00  100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
xvda              0.00     0.00    0.00    0.00     0.00     0.00     0.00     4.00    0.00    0.00    0.00   0.00 100.00
dm-0              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00

Could you tell us that why is this happening, is this a bug?

Thanks!

Ouyang Zhaowei

