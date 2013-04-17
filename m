Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab3DQSlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:41:45 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:51557 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab3DQSlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:41:44 -0400
Message-ID: <516EECDB.6090400@linux.vnet.ibm.com>
Date: Thu, 18 Apr 2013 02:41:31 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Avi Kivity <avi.kivity@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: mmu_notifier: re-fix freed page still mapped in secondary
 MMU
References: <516CF235.4060103@linux.vnet.ibm.com> <20130416093131.GJ3658@sgi.com> <516D275C.8040406@linux.vnet.ibm.com> <20130416112553.GM3658@sgi.com> <20130416114322.GN3658@sgi.com> <516D4D08.9020602@linux.vnet.ibm.com> <20130416180835.GY3658@sgi.com> <516E0F1E.5090805@linux.vnet.ibm.com> <20130417141035.GA29872@sgi.com>
In-Reply-To: <20130417141035.GA29872@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041718-9574-0000-0000-00000781253E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 10:10 PM, Robin Holt wrote:
> On Wed, Apr 17, 2013 at 10:55:26AM +0800, Xiao Guangrong wrote:
>> On 04/17/2013 02:08 AM, Robin Holt wrote:
>>> On Tue, Apr 16, 2013 at 09:07:20PM +0800, Xiao Guangrong wrote:
>>>> On 04/16/2013 07:43 PM, Robin Holt wrote:
>>>>> Argh.  Taking a step back helped clear my head.
>>>>>
>>>>> For the -stable releases, I agree we should just go with your
>>>>> revert-plus-hlist_del_init_rcu patch.  I will give it a test
>>>>> when I am in the office.
>>>>
>>>> Okay. Wait for your test report. Thank you in advance.
>>>>
>>>>>
>>>>> For the v3.10 release, we should work on making this more
>>>>> correct and completely documented.
>>>>
>>>> Better document is always welcomed.
>>>>
>>>> Double call ->release is not bad, like i mentioned it in the changelog:
>>>>
>>>> it is really rare (e.g, can not happen on kvm since mmu-notify is unregistered
>>>> after exit_mmap()) and the later call of multiple ->release should be
>>>> fast since all the pages have already been released by the first call.
>>>>
>>>> But, of course, it's great if you have a _light_ way to avoid this.
>>>
>>> Getting my test environment set back up took longer than I would have liked.
>>>
>>> Your patch passed.  I got no NULL-pointer derefs.
>>
>> Thanks for your test again.
>>
>>>
>>> How would you feel about adding the following to your patch?
>>
>> I prefer to make these changes as a separate patch, this change is the
>> improvement, please do not mix it with bugfix.
> 
> I think your "improvement" classification is a bit deceiving.  My previous
> patch fixed the bug in calling release multiple times.  Your patch without
> this will reintroduce that buggy behavior.  Just because the bug is already
> worked around by KVM does not mean it is not a bug.

As your tested, calling ->release() multiple times can work, but just make your
testcase more _slower_. So your changes is trying to speed it up - it is a
improvement.

Well, _if_ it is really a bug, could you please do not fix two bugs in one patch?

Thanks!

