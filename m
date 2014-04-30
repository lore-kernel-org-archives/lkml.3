Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbaD3K5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 06:57:54 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:57302 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967AbaD3K5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:57:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140414175236.GB15249@htj.dyndns.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
	<20140414154556.GA9552@redhat.com>
	<20140414175236.GB15249@htj.dyndns.org>
Date: Wed, 30 Apr 2014 16:27:51 +0530
X-Google-Sender-Auth: WL23cEHXcW1F7WWlEUfKAEP04ok
Message-ID: <CAC4Lta0qd2vW4ENSOpzK+0i06MorzfmsZZZuW9xUtpZ_gWA9gA@mail.gmail.com>
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: implement unified hierarchy
From: Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 11:22 PM, Tejun Heo <tj@kernel.org> wrote:
>> How does this work for root's tasks now? Given that task can only be
>> in leaf cgroups, that means tasks can't be in / cgroup (If one wants
>> to create some cgroups). Does that mean / will be empty and init system
>> need to setup things right.
>
> Root is exempt from the restriction.  Root has always been special
> anyway.
>

(I do not wish to Hijack this thread,  but found a relevant context
 here to initiate discussion.  But would discuss in a separate thread
once I get a positive go on the topic)

Hi Tejun,

For some controllers like cpuset, when we have exclusive_cpu is set,
what about having a knob in the cpuset controller
to move the task to non-root (when option is set).

Because all the way along, though we have freedom to make the cpusets
exclusive and move tasks (say VMs) into them,
making sure they do not interfere with each other, we can not prevent
the other tasks spawned in a system eating into cpus of
exclusive cpuset since they go to root automatically.

Do you think having a knob, to make sure new tasks spawned go to say a
default  directory under root makes sense?

 I understand that we could easily have a userspace script which could
achieve intended goal, but kernel solution
 would really make the exclusive cpusets have exclusive access to cpus
it should have.

(I also have a POC implemented for pre-unified hierarchy tree and
understand some bit of complications involved in that and
understand that we should not have complex policies in kernel for e.g.
filtering tasks based on patterns etc..).
