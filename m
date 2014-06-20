Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966869AbaFTKrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:47:35 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:32205 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966748AbaFTKrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:47:32 -0400
Message-ID: <53A41125.4080802@huawei.com>
Date: Fri, 20 Jun 2014 18:47:01 +0800
From: Liu hua <sdu.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>, "anton@enomsg.org" <anton@enomsg.org>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Wang Nan <wangnan0@huawei.com>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>
Subject: Re: Should Pstore(ramoops) records customized information?
References: <539E6D4D.5000802@huawei.com> <53A164DB.1020305@huawei.com> <3908561D78D1C84285E8C5FCA982C28F32838E10@ORSMSX114.amr.corp.intel.com> <53A2D5BB.5040500@huawei.com> <3908561D78D1C84285E8C5FCA982C28F3283A5E3@ORSMSX114.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3283A5E3@ORSMSX114.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.58.238]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.53A41132.0012,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: e02cf0e5456ad60c3f7efe63ff012d29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/20 7:42, Luck, Tony wrote:

>> BTW, I note that "extern struct pstore_info *psinfo" locates in
>> fs/pstore/internal.h. So users out of directory "fs/pstore/" can not use pstore to
>> record messages. We do not want other kernel users to use pstore, right?  And can we
>> break this?
> 
> Yes we can make some interface visible to the rest of the kernel ... probably
> not the raw "*psinfo" though. Perhaps the pstore_alloc_ring_buffer() and
> pstore_write_ring_buffer() functions should be the ones exported to the
> rest of the kernel.
> 
>> ditoo.. Since other backends like efi and erst may can not privide such ring buffer.
>> So pstore_alloc_ring_buffer should be a funciton pointer of pstore_info struct.
> 
> Yes - that allows less capable backend like ERST and efivars to not provide the
> service.  Since it becomes internal, you can drop the "pstore_" prefix.  E.g.
> something like:
> 
> int pstore_alloc_ring_buffer(char *name, int size)
> {
> 	return psinfo->alloc_ring_buffer(name, size);
> }
> EXPORT_SYMBOL_GPL(pstore_alloc_ring_buffer);
> 
> ... and you have to find/make some global header for the "extern" declaration.

I will make these RFC patch series according to our discussion. Thanks you very to
valuable advice.

Thanks,
Liu Hua




> 
> -Tony
> 
> 


