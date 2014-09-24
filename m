Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaIXSb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:31:26 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:53166 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbaIXSbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:31:24 -0400
MIME-Version: 1.0
In-Reply-To: <CANaxB-zqeJ0mse0J0=aH4uV+yRdgVhmHbAq4Wa8tW-81sNSMJA@mail.gmail.com>
References: <CANaxB-ykM+5h4+x5hHK2Z_APpiQLvGvc=2nBR5pGQS=msqp6ZA@mail.gmail.com>
	<CANaxB-zqeJ0mse0J0=aH4uV+yRdgVhmHbAq4Wa8tW-81sNSMJA@mail.gmail.com>
Date: Wed, 24 Sep 2014 11:31:24 -0700
Message-ID: <CAM_iQpU4rZLxdb=1TkG6HMR54SLk7tmRqxkg0+acRtV91o+UXA@mail.gmail.com>
Subject: Re: linux-next: cgroup_mount() falls asleep forever
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andrey Wagin <avagin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 7:29 AM, Andrey Wagin <avagin@gmail.com> wrote:
> 2014-09-24 14:31 GMT+04:00 Andrey Wagin <avagin@gmail.com>:
>> Hi All,
>
> The problem is in a following commit:
>
> commit 0c7bf3e8cab7900e17ce7f97104c39927d835469
> Author: Zefan Li <lizefan@huawei.com>
> Date:   Sat Sep 20 14:49:10 2014 +0800
>
>     cgroup: remove redundant variable in cgroup_mount()
>
>     Both pinned_sb and new_sb indicate if a new superblock is needed,
>     so we can just remove new_sb.
>
>     Note now we must check if kernfs_tryget_sb() returns NULL, because
>     when it returns NULL, kernfs_mount() may still re-use an existing
>     superblock, which is just allocated by another concurent mount.
>

I guess the check for NULL is incorrect, the comment on kernfs_pin_sb()
says:

Returns NULL if there's no superblock associated to this kernfs_root,
