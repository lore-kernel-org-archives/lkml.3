Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaJPUx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:53:29 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:65018 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJPUx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:53:28 -0400
MIME-Version: 1.0
In-Reply-To: <20141016203954.GA26336@redhat.com>
References: <20141016203954.GA26336@redhat.com>
Date: Thu, 16 Oct 2014 13:53:28 -0700
Message-ID: <CAM_iQpUyCR3Bv1QhFkVmii9vB=fjMAUiWZ4T+mj60=FUZOXS+A@mail.gmail.com>
Subject: Re: + freezer-check-oom-kill-while-being-frozen.patch added to -mm tree
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 1:39 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> Fix the issue by checking for TIF_MEMDIE thread flag and get away from the
>> fridge if it is set.  oom_scan_process_thread doesn't have to check for
>> the frozen task anymore because do_send_sig_info will wake up the thread
>> and TIF_MEMDIE is already set by that time.
>
> I must have missed something... but __refrigerator() sleeps in
> TASK_UNINTERRUPTIBLE and do_send_sig_info() won't wake it up?
>

This is exactly what we are trying to fix. Make sure you read the patch
as well before reply? Otherwise, I must have missed your point. :)
