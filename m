Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab3KSJzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:55:39 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60215 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3KSJzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:55:37 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <528B3585.5080606@jp.fujitsu.com>
Date: Tue, 19 Nov 2013 18:55:17 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
CC: "vgoyal@redhat.com" <vgoyal@redhat.com>, "bhe@redhat.com" <bhe@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "chaowang@redhat.com" <chaowang@redhat.com>
Subject: Re: /proc/vmcore mmap() failure issue
References: <20131113204130.GD7613@redhat.com> <5284A689.70903@jp.fujitsu.com> <20131114151359.GA3913@redhat.com> <5285EC60.1060906@jp.fujitsu.com> <20131115142617.GC6637@redhat.com> <0910DD04CBD6DE4193FCF86B9C00BE971BF592@BPXM01GP.gisp.nec.co.jp>
In-Reply-To: <0910DD04CBD6DE4193FCF86B9C00BE971BF592@BPXM01GP.gisp.nec.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/18 9:51), Atsushi Kumagai wrote:
> (2013/11/15 23:26), Vivek Goyal wrote:
>> On Fri, Nov 15, 2013 at 06:41:52PM +0900, HATAYAMA Daisuke wrote:
>>
>> [..]
>>>> Given the fact that hpa does not like fixing it in kernel. We are left
>>>> with option of fixing it in following places.
>>>>
>>>> - Drop partial pages in kexec-tools
>>>> - Drop partial pages in makeudmpfile.
>>>> - Read partial pages using read() interface in makedumpfile
>>>> - Modify /proc/vmcore to copy partial pages in second kernel's memory.
>>>>
>>>> It is not clear to me that partial pages are really useful.  So I want
>>>> to avoid modifying /proc/vmcore to deal with partial pages and increase
>>>> complexity.
>>>>
>>>> So fixing makedumpfile (either option2 or option 3) seems least risky
>>>> to me. In fact I would say let us keep it simple and truncate partial
>>>> pages in makedumpfile to keep it simple. And look at option 3 once we
>>>> have a strong use case for partial pages.
>>>>
>>>> What do you think?
>>>>
>>>
>>> As you say, it's not clear that partial pages are really useful, but on
>>> the other hand, it seems to me not clear that they are really useless.
>>> I think we should get them as long as we have access to them.
>>>
>>> It seems best to me the option 3). Switching between read and mmap would
>>> be not so complex and also it's by far flexible in makedumpfile than in
>>> kernel.
>>
>> Ok, I am fine with option 3. It is more complicated option but safe
>> option.
> 
> It sounds reasonable also to me.
> 
>> Is there any chance that you could look into fixing this. I have no
>> experience writing code for makedumpfile.
> 
> I'll send a patch to fix this soon.
> 

Thanks.

BTW, now the following patch has been applied on top of makedumpfile in
kexec-tools package on fedora in order to avoid the issue.

https://lists.fedoraproject.org/pipermail/kexec/2013-November/000254.html

I remember prototype version of mmap patch implemented a kind of --no-mmap option
and we could use it to disable mmap() use and use read() instead, I think
which is useful when we face this kind of issue.

-- 
Thanks.
HATAYAMA, Daisuke

