Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3IIEdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 00:33:43 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:34987 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab3IIEdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 00:33:42 -0400
MIME-Version: 1.0
In-Reply-To: <522C8DA8.6030701@oracle.com>
References: <522C8DA8.6030701@oracle.com>
Date: Mon, 9 Sep 2013 12:33:40 +0800
Message-ID: <CAJd=RBAd6-kX127cdTs10Ty7LJ+cGQX8NvX9H1bb4QSh4erzLw@mail.gmail.com>
Subject: Re: hugetlb: NULL ptr deref in region_truncate
From: Hillf Danton <dhillf@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, trinity@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 8, 2013 at 10:46 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest, running latest -next
> kernel, I've
> stumbled on the following:
>
> [  998.281867] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000274
> [  998.283333] IP: [<ffffffff812707c4>] region_truncate+0x64/0xd0
> [  998.284288] PGD 0
> [  998.284717] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  998.286506] Modules linked in:
> [  998.287101] CPU: 88 PID: 24650 Comm: trinity-child85 Tainted: G    B   W
> 3.11.0-next-20130906-sasha #3985

 *  'B' - System has hit bad_page?
