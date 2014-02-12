Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaBLJHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:07:43 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58613 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaBLJHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:07:10 -0500
Message-ID: <52FB39A8.9000400@gmail.com>
Date: Wed, 12 Feb 2014 10:06:48 +0100
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Josh Boyer <jwboyer@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Subject: Re: WARNING: CPU: 2 PID: 4415 at lib/idr.c:527 idr_remove.part.6+0x243/0x250()
References: <52FB31D3.8030209@gmail.com> <20140212083559.GE7984@mtj.dyndns.org>
In-Reply-To: <20140212083559.GE7984@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.02.2014 09:35, Tejun Heo wrote:
> On Wed, Feb 12, 2014 at 09:33:23AM +0100, poma wrote:
>>
>> Ahoy!
>>
>> My trace is the last one, therefore per LIFO I am sending this report to
>> you.
>>
>>  ------------[ cut here ]------------
>>  WARNING: CPU: 2 PID: 4415 at lib/idr.c:527 idr_remove.part.6+0x243/0x250()
>>  idr_remove called for id=136 which is not allocated.
>>  CPU: 2 PID: 4415 Comm: systemd Not tainted 3.12.10-300.fc20.x86_64 #1
>>  Call Trace:
>>   [<ffffffff81667ed5>] dump_stack+0x45/0x56
>>   [<ffffffff8106903d>] warn_slowpath_common+0x7d/0xa0
>>   [<ffffffff810690ac>] warn_slowpath_fmt+0x4c/0x50
>>   [<ffffffff81304073>] idr_remove.part.6+0x243/0x250
>>   [<ffffffff811c458c>] ? d_walk+0xdc/0x2a0
>>   [<ffffffff8130408d>] idr_remove+0xd/0x10
>>   [<ffffffff810defa6>] cgroup_destroy_css_killed+0x46/0x70
>>   [<ffffffff810e1c98>] cgroup_destroy_locked+0x2d8/0x310
>>   [<ffffffff810e1cf2>] cgroup_rmdir+0x22/0x40
>>   [<ffffffff811bc108>] vfs_rmdir+0xa8/0x100
>>   [<ffffffff811bc2dd>] do_rmdir+0x17d/0x1d0
>>   [<ffffffff81087b6c>] ? task_work_run+0xac/0xe0
>>   [<ffffffff81012a21>] ? do_notify_resume+0x61/0xa0
>>   [<ffffffff811bf616>] SyS_rmdir+0x16/0x20
>>   [<ffffffff81676ea9>] system_call_fastpath+0x16/0x1b
>>  ---[ end trace 4ebc2893b27b190d ]---
> 
> Sounds simliar to the issue fixed by the following patch.
> 
>   http://lkml.kernel.org/g/52F9D9DA.7040108@huawei.com
> 
> Thanks.
> 

All right!
Thanks.

Josh, Justin will someone look at this as the patch[1] is for 3.14, but
folks see this in the range 3.12 - 3.13[2].

Thanks.


poma


[1] http://thread.gmane.org/gmane.linux.kernel.cgroups/10336
[2] https://bugzilla.redhat.com/show_bug.cgi?id=1045755


