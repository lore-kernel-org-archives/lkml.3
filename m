Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbbAOTEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:04:53 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:45373 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbbAOTEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:04:51 -0500
MIME-Version: 1.0
In-Reply-To: <20150115185543.GA28195@htj.dyndns.org>
References: <20150115180242.10450.92.stgit@buzz>
	<20150115184914.10450.51964.stgit@buzz>
	<20150115185543.GA28195@htj.dyndns.org>
Date: Thu, 15 Jan 2015 23:04:49 +0400
Message-ID: <CALYGNiPY2K6F+OFoCV5XShrXaQOiyGXreR=4TC=Mp7axTiF0YQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] memcg: track shared inodes with dirty pages
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Konstantin Khebnikov <khlebnikov@yandex-team.ru>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org,
        Roman Gushchin <klamm@yandex-team.ru>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 9:55 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Jan 15, 2015 at 09:49:14PM +0300, Konstantin Khebnikov wrote:
>> From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>>
>> Inode is owned only by one memory cgroup, but if it's shared it might
>> contain pages from multiple cgroups. This patch detects this situation
>> in memory reclaiemer and marks dirty inode with flag I_DIRTY_SHARED
>> which is cleared only when data is completely written. Memcg writeback
>> always writes such inodes.
>>
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>
> This conflicts with the writeback cgroup support patchset which will
> solve the writeback and memcg problem a lot more comprehensively.
>
>  http://lkml.kernel.org/g/1420579582-8516-1-git-send-email-tj@kernel.org
>
> Thanks.

I know. Absolutely accurate per-page solution looks too complicated for me.
Is there any real demand for accurate handling dirty set in shared inodes?
Doing whole accounting in per-inode basis makes life so much easier.

>
> --
> tejun
