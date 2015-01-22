Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbbAVJyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:54:51 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:15134 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbbAVJyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:54:43 -0500
Message-ID: <54C0C8CF.8070804@huawei.com>
Date: Thu, 22 Jan 2015 17:54:23 +0800
From: Li Bin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Josh Poimboeuf <jpoimboe@redhat.com>
CC: Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, <live-patching@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <guohanjun@huawei.com>, <zhangdianfang@huawei.com>,
        <xiexiuqi@huawei.com>
Subject: Re: [PATCH 2/2] livepatch: disable/enable_patch manners for interdependent
 patches
References: <1421831262-27869-1-git-send-email-huawei.libin@huawei.com> <1421831262-27869-3-git-send-email-huawei.libin@huawei.com> <alpine.LNX.2.00.1501211506420.10817@pobox.suse.cz> <54C04775.1070908@huawei.com> <20150122035126.GB12927@treble.redhat.com> <54C0B735.7070106@huawei.com>
In-Reply-To: <54C0B735.7070106@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.181]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/22 16:39, Li Bin wrote:
> On 2015/1/22 11:51, Josh Poimboeuf wrote:
>> On Thu, Jan 22, 2015 at 08:42:29AM +0800, Li Bin wrote:
>>> On 2015/1/21 22:08, Jiri Kosina wrote:
>>>> On Wed, 21 Jan 2015, Li Bin wrote:
>>>> By this you limit the definition of the patch inter-dependency to just 
>>>> symbols. But that's not the only way how patches can depend on it other -- 
>>>> the dependency can be semantical.
>>>
>>> Yes, I agree with you. But I think the other dependencies such as semantical
>>> dependency should be judged by the user, like reverting a patch from git repository.
>>> Right?
>>
>> But with live patching, there are two users: the patch creator (who
>> creates the patch module) and the end user (who loads it on their
>> system).
>>
>> We can assume the patch creator knows what he's doing, but the end user
>> doesn't always know or care about low level details like patch
>> dependencies.  The easiest and safest way to protect the end user is the
>> current approach, which assumes that each patch depends on all
>> previously applied patches.
> 
> But then, the feature that disable patch dynamically is useless.
> For example, if user find a bug be introduced by the last patch and disable
> it directly, the new patch is no longer allowed from now unless enable the
> old patch firstly but there is a risk window by this way.
> 

Ok, in this case we can unregister the old patch firstly.
But it seems that the feature that enable/disable patch dynamically indeed
useless. (Its value is only for the last patch to enable or disable.)

>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe live-patching" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 


