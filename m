Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaDCUCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:02:49 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:57025 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbaDCUCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:02:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140403194335.GC2472@mtj.dyndns.org>
References: <20140403164911.GE24119@htj.dyndns.org>
	<CA+55aFy1dm_CoTv+tihQ+m54G3gR9siOngurHsuKf9W3k1sKKw@mail.gmail.com>
	<CA+55aFwBm202pchEH9A6vbJVdar9-T35pBF44cCt7FNjmno9sQ@mail.gmail.com>
	<CAOS58YMckmoCocguf9BC_Wxbn3D2Rx3MArhgozO9qCj4g=5aDw@mail.gmail.com>
	<CA+55aFw2+VKojzoF2aDaruOMKHikTO8J0HeK9DoDLZr+HqTWbg@mail.gmail.com>
	<20140403194335.GC2472@mtj.dyndns.org>
Date: Thu, 3 Apr 2014 13:02:45 -0700
X-Google-Sender-Auth: xJ0esLxCJM4GXNp0UxXE1wzQj3w
Message-ID: <CA+55aFw+jFdmmi6eZ6+RpLM9heyowfXsZxb6Y91GNkPU677PmA@mail.gmail.com>
Subject: Re: [GIT PULL] cgroup changes for v3.15-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        cgroups@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 12:43 PM, Tejun Heo <tj@kernel.org> wrote:
>
> Ah, I remembered the other way around.  We could leak cgroup_root
> reference, not the other way around.  cgroup_mount() can be called
> multiple times for the same sb and we inc cgroup_root's ref each time
> but cgroup_kill_sb() only happens when the sb is released, so if we do
> the following,

Oh, Christ, I see what you are talking about.

That interface is all kinds of crazy.

> The cgroup_root should be destroyed but it isn't, I think.  We'd need
> to bump cgroup_root's refcnt only when a new sb is created.  It's
> kinda ugly.  Hmmm...

Ok, so I guess we can use that "new_sb_created" thing, and I'll redo
my merge resolution to reflect that. I do find this incredibly ugly.

              Linus
