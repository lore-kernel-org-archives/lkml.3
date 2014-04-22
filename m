Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaDVHP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:15:29 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:35372 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbaDVHPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:15:25 -0400
Message-ID: <535616D9.8060702@huawei.com>
Date: Tue, 22 Apr 2014 15:14:33 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jianyu Zhan <nasa4836@gmail.com>
CC: Hillf Danton <dhillf@gmail.com>, Tejun Heo <tj@kernel.org>,
        <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hugetlb_cgroup: explicitly init the early_init field
References: <1398144620-9630-1-git-send-email-nasa4836@gmail.com> <CAJd=RBA6ZUZ2UBetmcwGciqY8snme-aY60ZhW9F=8CO6kDzMBA@mail.gmail.com> <CAHz2CGXsvdtVdwZfyFAwtRHJ_vkeJZXtLv4fTGTYEeEwN7H6Qw@mail.gmail.com>
In-Reply-To: <CAHz2CGXsvdtVdwZfyFAwtRHJ_vkeJZXtLv4fTGTYEeEwN7H6Qw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/22 15:01, Jianyu Zhan wrote:
> Hi, hillf,
> 
> On Tue, Apr 22, 2014 at 2:47 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> But other fields still missed, if any. Fair?
> 
> yep, it is not fair.
> 
> Sure for this global variable struct, if not initailized, its all
> fields will be initialized
> to 0 or null(depending on its type).  The point here is no to deprive
> the rights of
> compiler/linker of doing this initialization, it is mainly for
> documentation reason.
> Actually this field's value would affect how ->css_alloc should implemented.
> 
> Concretely, if early_init is nonzero, then ->css_alloc *must not* call kzalloc,
> because in cgroup implementation, ->css_alloc will be called earlier before
> mm_init().
> 
> I don't think that the value of one field(early_init) has a so subtle
> restrition on the
> another field(css_alloc) is a good thing, but since it is there,
> docment it should
> be needed.
> 

I don't see how things can be improved by initializing it to 0 explicitly,
if anything needs to be improved.

