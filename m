Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050AbaDIQUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:20:37 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46702 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933354AbaDIQUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:20:35 -0400
Message-ID: <5345734C.1020905@linux.vnet.ibm.com>
Date: Wed, 09 Apr 2014 11:20:28 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [RFC PATCH] memory driver: make phys_index/end_phys_index reflect
 the start/end section number
References: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com> <533E0B0E.9020909@jp.fujitsu.com> <1396945659.3162.6.camel@ThinkPad-T5421.cn.ibm.com> <53442021.2060608@intel.com> <53443E8C.4070906@linux.vnet.ibm.com> <53445245.3020400@intel.com>
In-Reply-To: <53445245.3020400@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040916-7182-0000-0000-00000A497C6A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 02:47 PM, Dave Hansen wrote:
> On 04/08/2014 11:23 AM, Nathan Fontenot wrote:
>> On 04/08/2014 11:13 AM, Dave Hansen wrote:
>>> On 04/08/2014 01:27 AM, Li Zhong wrote:
>>>> If Dave and others don't have further objections, it seems this small
>>>> userspace incompatibility could be accepted by most of us, and I don't
>>>> need to make a version 2. 
>>>
>>> Let me ask another question then.  What are the units of
>>> phys_index/end_phys_index?  How do we expose those units to userspace?
>>>
>>
>> The documentation for these files just states that the files contain
>> the first and last section id of memory in the memory block for
>> phys_index and end_phys_index respectively.
>>
>> I'm not sure the values have ever been units of anything, at least not
>> that I remember.
> 
> <sigh>
> 
> There are two units.  SECTION_SIZE, which is completely internal to the
> kernel, and block_size_bytes which used to be the same as SECTION_SIZE,
> but is not now.  Which one of those two is phys_index/end_phys_index in,
> and if it is in terms of SECTION_SIZE like this patch proposes, how do
> we tell userspace how large SECTION_SIZE is?
> 
> block_size_bytes is supposed to tell you how large the sections are.  In
> the case where we lumped a bunch of sections together, we also bumped up
> block_size_bytes.  That's why we currently divide the *ACTUAL* section
> number in phys_index/end_phys_index by block_size_bytes.
> 
> That document really needs to be updated to stop referring to sections
> (at least in the descriptions of the user interface).  We can not change
> the units of phys_index/end_phys_index without also changing
> block_size_bytes.
> 

Re-reading the documentation. You're correct, it needs help.

-Nathan

