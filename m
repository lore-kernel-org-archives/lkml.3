Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaF3Gg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:36:26 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:46826 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbaF3GgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:36:24 -0400
Message-ID: <53B10548.8040702@huawei.com>
Date: Mon, 30 Jun 2014 14:35:52 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "arozansk@redhat.com" <arozansk@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Bin <huawei.libin@huawei.com>
Subject: Re: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86 platform
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com> <1382084624-10857-5-git-send-email-gong.chen@linux.intel.com> <52612BA4.2060906@linux.vnet.ibm.com> <53AD0275.7020003@huawei.com> <20140627092227.GA23153@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F3284BBB1@ORSMSX114.amr.corp.intel.com> <20140627211441.GA20305@nazgul.tnic> <3908561D78D1C84285E8C5FCA982C28F3284C082@ORSMSX114.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3284C082@ORSMSX114.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.17.191]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/28 6:10, Luck, Tony wrote:
>>> Not all machine checks are fatal - it would be bad for us to go into
>>> an infinite spin instead of executing the recovery code.
>>
>> Then for the time being extlog shouldn't hook into the decoder chain
>> but into mce_process_work, i.e. the last should call it. Or maybe add
>> another notifier which is not atomic...
> 
> I spoke too quickly.  The only MCE for which we have recovery code are
> those that hit in application code.  So the processor that is trying to do
> the printk() can't possibly be holding the locks.  Other processors might
> have held the lock at the time of the MCE - but they have all returned 
> from the handler at the time we try the printk - so they will make progess
> and release the lock so that we can acquire it.

Thank you for your reply.

When we got a MCE which hit in application code, it will be broadcast to
other processors immediately. Other processors who might have held the lock
at the time of MCE, have no chance to release the lock and return from the
printk. Isn't it?

I know this rarely happens in production environments, but I think it's still
a risk here. So it's very good if we have a printk safe in atomic context in
the future.

--
Thanks,
	XiuQi

> 
> -Tony
> 


