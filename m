Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbbAVAop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:44:45 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:11626 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbbAVAoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:44:34 -0500
Message-ID: <54C047E3.70402@huawei.com>
Date: Thu, 22 Jan 2015 08:44:19 +0800
From: Li Bin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>
CC: Josh Poimboeuf <jpoimboe@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <guohanjun@huawei.com>,
        <zhangdianfang@huawei.com>, <xiexiuqi@huawei.com>
Subject: Re: [PATCH 1/2] livepatch: Revert "livepatch: enforce patch stacking
 semantics"
References: <1421831262-27869-1-git-send-email-huawei.libin@huawei.com> <1421831262-27869-2-git-send-email-huawei.libin@huawei.com> <alpine.LNX.2.00.1501211505180.10817@pobox.suse.cz> <20150121143620.GA2943@cerebellum.variantweb.net>
In-Reply-To: <20150121143620.GA2943@cerebellum.variantweb.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.181]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/21 22:36, Seth Jennings wrote:
> On Wed, Jan 21, 2015 at 03:06:38PM +0100, Jiri Kosina wrote:
>> On Wed, 21 Jan 2015, Li Bin wrote:
>>
>>> This reverts commit 83a90bb1345767f0cb96d242fd8b9db44b2b0e17.
>>>
>>> The method that only allowing the topmost patch on the stack to be
>>> enabled or disabled is unreasonable. Such as the following case:
>>>
>>> 	- do live patch1
>>> 	- disable patch1
>>> 	- do live patch2 //error
>>>
>>> Now, we will never be able to do new live patch unless disabing the
>>> patch1 although there is no dependencies.
>>
>> Unregistering disabled patch still works and removes it from the list no 
>> matter the position.
>>
>> So what exactly is the problem?
> 
>>From a quick glance, it seems that what this set does is it only
> enforces the stacking requirements if two patches patch the same
> function.
> 

Yes, this patch is only concerning this case that 'multi patches patch
the same function' and solve the problem that mentioned previously:

foo_unpatched()
	foo_patch1()
		foo_patch2()
			foo_patch3()
		disable(foo_patch2)
		disable(foo_patch3)
	foo_patch1()

foo_patch2 is not allowed to be disabled before disable foo_patch3.

Thanks,
	Li Bin

> I'm not sure if that is correct logically or correctly implemented by
> these patches yet.
> 
> Seth
> 
>>
>> -- 
>> Jiri Kosina
>> SUSE Labs
> 
> .
> 


