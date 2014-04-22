Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaDVJdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:33:10 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:13495 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbaDVJcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:32:54 -0400
Message-ID: <53563709.2000408@huawei.com>
Date: Tue, 22 Apr 2014 17:31:53 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jianyu Zhan <nasa4836@gmail.com>
CC: Ingo Molnar <mingo@kernel.org>, <a.p.zijlstra@chello.nl>,
        <paulus@samba.org>, <mingo@redhat.com>, <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf-event/cgroup: explicitly init the early_init field
References: <1398144517-9496-1-git-send-email-nasa4836@gmail.com> <20140422060654.GB9133@gmail.com> <CAHz2CGW0D6GpbP7Tps2KoN8av_OUEzO9xGvpV_XwoHgFQ36sOw@mail.gmail.com>
In-Reply-To: <CAHz2CGW0D6GpbP7Tps2KoN8av_OUEzO9xGvpV_XwoHgFQ36sOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/22 15:12, Jianyu Zhan wrote:
> On Tue, Apr 22, 2014 at 2:06 PM, Ingo Molnar <mingo@kernel.org> wrote:
>> How can that field ever be nonzero?
>>
>> I.e. under what exact circumstances does this patch make sense?
> 
> Hi, Ingo,
> 
> More explanation.
> 
> Sure, for this global variable struct, if not initailized, its all
> fields will be initialized
> to 0 or null(depending on its type).  The point here is no to deprive
> the rights of compiler/linker of doing this initialization, it is mainly for
> documentation reason. Actually this field's value would affect how ->css_alloc
> should implemented.
> 
> Concretely, if early_init is nonzero, then ->css_alloc *must not* call kzalloc,
> because in cgroup implementation, ->css_alloc will be called earlier before
> mm_init().
> 
> I don't think that the value of one field(early_init) has a so subtle
> restrition on the another field(css_alloc) is a good thing,
> but since
> it is there,
> docment it should be needed.
> 
> I could resend the patch with  more comment.
> 

nack

As I said in another mail thread, this change makes no sense.

