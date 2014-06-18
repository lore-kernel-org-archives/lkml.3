Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965902AbaFRKH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:07:57 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:27954 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965123AbaFRKHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:07:55 -0400
Message-ID: <53A164DB.1020305@huawei.com>
Date: Wed, 18 Jun 2014 18:07:23 +0800
From: Liu hua <sdu.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: <anton@enomsg.org>, <ccross@android.com>, <keescook@chromium.org>,
        <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Wang Nan <wangnan0@huawei.com>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>
Subject: Should Pstore(ramoops) records customized information?
References: <539E6D4D.5000802@huawei.com>
In-Reply-To: <539E6D4D.5000802@huawei.com>
X-Forwarded-Message-Id: <539E6D4D.5000802@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.58.238]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.53A164EF.00CA,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: fb6ace041fe5499db8f189f44db58620
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees or Colin or Tony or Anton,

We are very interested in Pstore, which provides a mechanism to save information
when machine is going to die. It is much lighter than kdump. So we can deploy it on
our real products. Because our product runs on several platforms (x86,arm and mips),
we prefer ramoops as pstore backend. For ramoops backend, now we can save dmesg,
console and ftrace inforamtion to different memory regions. It is very good, but
can we do something more?

For kmsg_dumper or console, we mixed messages together. So some important meaasges
may be flooded with dispensable ones. Pstore does not provide a way to let us
determine which message to record, which to discard. And

So can we introduce a customized information recording mechanism?

Something like this:

(1) The backend (ramoops) provides servel memory regions staticly. Each region
 is a ring buffer, which does not connect with certain PSTORE_TYPE_ID. So no one
 can modify or use it before allocation.

(2) A pstore user allocs a memory region, pstore will return a pstore_type_id.

        pstore_type_id = alloc_pstroe_region()

(3) This user record certain message to this region.

        psinfo->write(pstore_type_id, ...)


By doing this:

(1) The console and ftrace message recording is also supported. we just need to call
    alloc_pstore_region() before saving such messages.

(2) We can realize a mechanism like black box in aircraft. if we record certain kind of
    messages to a sigle region. We do not need to care other type messages to overlap it.
    we can allways get the latest messages of each type.

(3) Anyone in kernel or modules can use this mechanism, if they alloc a region.


Thanks,
Liu Hua


.




