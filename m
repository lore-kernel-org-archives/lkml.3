Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaFYAlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 20:41:09 -0400
Received: from mga14.intel.com ([192.55.52.115]:2263 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbaFYAlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 20:41:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="357138513"
Message-ID: <53AA1A9F.8030108@linux.intel.com>
Date: Wed, 25 Jun 2014 08:41:03 +0800
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Liu hua <sdu.liu@huawei.com>, "Luck, Tony" <tony.luck@intel.com>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Wang Nan <wangnan0@huawei.com>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>,
        Liu ShuoX <shuox.liu@intel.com>
Subject: Re: Should Pstore(ramoops) records customized information?
References: <539E6D4D.5000802@huawei.com> <53A164DB.1020305@huawei.com> <3908561D78D1C84285E8C5FCA982C28F32838E10@ORSMSX114.amr.corp.intel.com> <53A2D5BB.5040500@huawei.com> <3908561D78D1C84285E8C5FCA982C28F3283A5E3@ORSMSX114.amr.corp.intel.com> <53A41125.4080802@huawei.com>
In-Reply-To: <53A41125.4080802@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/6/20 18:47, Liu hua wrote:
> On 2014/6/20 7:42, Luck, Tony wrote:
>
>>> BTW, I note that "extern struct pstore_info *psinfo" locates in
>>> fs/pstore/internal.h. So users out of directory "fs/pstore/" can not use pstore to
>>> record messages. We do not want other kernel users to use pstore, right?  And can we
>>> break this?
>> Yes we can make some interface visible to the rest of the kernel ... probably
>> not the raw "*psinfo" though. Perhaps the pstore_alloc_ring_buffer() and
>> pstore_write_ring_buffer() functions should be the ones exported to the
>> rest of the kernel.
>>
>>> ditoo.. Since other backends like efi and erst may can not privide such ring buffer.
>>> So pstore_alloc_ring_buffer should be a funciton pointer of pstore_info struct.
>> Yes - that allows less capable backend like ERST and efivars to not provide the
>> service.  Since it becomes internal, you can drop the "pstore_" prefix.  E.g.
>> something like:
>>
>> int pstore_alloc_ring_buffer(char *name, int size)
>> {
>> 	return psinfo->alloc_ring_buffer(name, size);
>> }
>> EXPORT_SYMBOL_GPL(pstore_alloc_ring_buffer);
>>
>> ... and you have to find/make some global header for the "extern" declaration.
> I will make these RFC patch series according to our discussion. Thanks you very to
> valuable advice.

Sorry for seeing your email late.We already worked out some patches to restructure
pstore. Would you like to try patchset http://article.gmane.org/gmane.linux.kernel/1697680/?

We have more patches available to add some flags to disable/enable specific zones.

Yanmin

