Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaDVHBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:01:51 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:54276 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaDVHBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:01:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBA6ZUZ2UBetmcwGciqY8snme-aY60ZhW9F=8CO6kDzMBA@mail.gmail.com>
References: <1398144620-9630-1-git-send-email-nasa4836@gmail.com> <CAJd=RBA6ZUZ2UBetmcwGciqY8snme-aY60ZhW9F=8CO6kDzMBA@mail.gmail.com>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Tue, 22 Apr 2014 15:01:04 +0800
Message-ID: <CAHz2CGXsvdtVdwZfyFAwtRHJ_vkeJZXtLv4fTGTYEeEwN7H6Qw@mail.gmail.com>
Subject: Re: [PATCH] hugetlb_cgroup: explicitly init the early_init field
To: Hillf Danton <dhillf@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org,
        Cgroups <cgroups@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, hillf,

On Tue, Apr 22, 2014 at 2:47 PM, Hillf Danton <dhillf@gmail.com> wrote:
> But other fields still missed, if any. Fair?

yep, it is not fair.

Sure for this global variable struct, if not initailized, its all
fields will be initialized
to 0 or null(depending on its type).  The point here is no to deprive
the rights of
compiler/linker of doing this initialization, it is mainly for
documentation reason.
Actually this field's value would affect how ->css_alloc should implemented.

Concretely, if early_init is nonzero, then ->css_alloc *must not* call kzalloc,
because in cgroup implementation, ->css_alloc will be called earlier before
mm_init().

I don't think that the value of one field(early_init) has a so subtle
restrition on the
another field(css_alloc) is a good thing, but since it is there,
docment it should
be needed.


Thanks,
Jianyu Zhan
