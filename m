Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbbAVJma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:42:30 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:17641 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbbAVJmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:42:24 -0500
Message-ID: <54C0C5EC.9080507@huawei.com>
Date: Thu, 22 Jan 2015 17:42:04 +0800
From: Li Bin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Miroslav Benes <mbenes@suse.cz>
CC: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, <live-patching@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <guohanjun@huawei.com>, <zhangdianfang@huawei.com>,
        <xiexiuqi@huawei.com>
Subject: Re: [PATCH 1/2] livepatch: Revert "livepatch: enforce patch stacking
 semantics"
References: <1421831262-27869-1-git-send-email-huawei.libin@huawei.com> <1421831262-27869-2-git-send-email-huawei.libin@huawei.com> <54C04BF0.6020906@huawei.com> <alpine.LNX.2.00.1501221013580.24802@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1501221013580.24802@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.181]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/22 17:15, Miroslav Benes wrote:
> On Thu, 22 Jan 2015, Li Bin wrote:
> 
>> On 2015/1/21 17:07, Li Bin wrote:
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
>>>
>>
>> Correct the log:
>> ... unless disabling the patch1 although ... -->
>> ... unless enabling the patch1 firstly although ...
> 
> Yes, but in such situation you can unregister patch1 and proceed with new 
> live patch. No problem. As Jiri has already written. Or are we missing 
> something?
> 

Ok, that is before process with new live patch we must unregister the disabled
patch1 previously. Is there need some message to avoid confusing the user?

Thanks,
Li Bin

> Regards,
> --
> Miroslav Benes
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe live-patching" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 


