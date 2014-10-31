Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbaJaKp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:45:29 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:24217 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393AbaJaKp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:45:27 -0400
Message-ID: <54536834.1020005@huawei.com>
Date: Fri, 31 Oct 2014 18:45:08 +0800
From: hujianyang <hujianyang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: <dedekind1@gmail.com>, <dwmw2@infradead.org>,
        <computersforpeace@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UBI: vtbl: Use ubi_eba_atomic_leb_change()
References: <1414259021-5691-1-git-send-email-richard@nod.at> <1414659349.23185.27.camel@sauron.fi.intel.com> <54530A29.9070208@huawei.com> <545343CA.7080507@nod.at>
In-Reply-To: <545343CA.7080507@nod.at>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.144]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/31 16:09, Richard Weinberger wrote:
> Hujianyang,
> 
> Am 31.10.2014 um 05:03 schrieb hujianyang:
>> Hi Artem and Richard,
>>
>> We are using atomic operation, leb_change(), for master_node
>> in ubifs-level. We use two lebs for master_node even if they
>> are changed with atomic operation.
>>
>> I think volume_table and master_node play similar roles. Do
>> you think changing VTBL record into one peb is OK? I just
>> what to know if I missed something. Could you please take
>> some time to explain that?
> 
> I'm not sure if I correctly understand your question.
> 
> If we use only one PEB for the VTBL existing UBI implementations
> would break as they assume we have two.
> 
> Thanks,
> //richard
> 
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
> 
> 

This question is basing on your comment for this patch:

"""
we can guarantee that the first VTBL record is always
correct and we don't really need the second one anymore.
"""

I think that means one PEB is enough in your considering.
So I want to know if you are sure about this. Because
we use two leb for master_node in ubifs-level. So maybe
VTBL is like super_node, not master_node, right?

