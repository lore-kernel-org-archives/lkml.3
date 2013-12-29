Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab3L2Lpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 06:45:52 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60950 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3L2Lpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 06:45:51 -0500
MIME-Version: 1.0
In-Reply-To: <524fc449.06a3420a.03dc.ffffb760SMTPIN_ADDED_BROKEN@mx.google.com>
References: <522E9569.9060104@huawei.com>
	<524fc449.06a3420a.03dc.ffffb760SMTPIN_ADDED_BROKEN@mx.google.com>
Date: Sun, 29 Dec 2013 13:45:49 +0200
X-Google-Sender-Auth: CPkGzBv4dG_mtIpoL7zO7NNrsNU
Message-ID: <CAOJsxLEiafGHcX6zy85NRXN7ydnVKNv2oZHNwffp9=hORxGJog@mail.gmail.com>
Subject: Re: [PATCH] slub: Fix calculation of cpu slabs
From: Pekka Enberg <penberg@kernel.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Li Zefan <lizefan@huawei.com>, Christoph Lameter <cl@linux.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 5, 2013 at 10:48 AM, Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:
> On Tue, Sep 10, 2013 at 11:43:37AM +0800, Li Zefan wrote:
>>  /sys/kernel/slab/:t-0000048 # cat cpu_slabs
>>  231 N0=16 N1=215
>>  /sys/kernel/slab/:t-0000048 # cat slabs
>>  145 N0=36 N1=109
>>
>>See, the number of slabs is smaller than that of cpu slabs.
>>
>>The bug was introduced by commit 49e2258586b423684f03c278149ab46d8f8b6700
>>("slub: per cpu cache for partial pages").
>>
>>We should use page->pages instead of page->pobjects when calculating
>>the number of cpu partial slabs. This also fixes the mapping of slabs
>>and nodes.
>>
>>As there's no variable storing the number of total/active objects in
>>cpu partial slabs, and we don't have user interfaces requiring those
>>statistics, I just add WARN_ON for those cases.
>>
>>Cc: <stable@vger.kernel.org> # 3.2+
>>Signed-off-by: Li Zefan <lizefan@huawei.com>
>
> Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Applied and sorry for the slow response!
