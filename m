Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab3IORBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 13:01:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757137Ab3IORBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 13:01:48 -0400
Date: Sun, 15 Sep 2013 18:55:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Sergey Dyasly <dserrg@gmail.com>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] kthread: Make kthread_create() killable.
Message-ID: <20130915165531.GD13344@redhat.com>
References: <201309132318.HEC05218.OtVOFOFMLJHFQS@I-love.SAKURA.ne.jp> <20130914160515.GA8627@redhat.com> <201309150846.HED51521.tJOFOMVFSOHQFL@I-love.SAKURA.ne.jp> <201309152038.DDJ59271.OJMOHLFtSFOQVF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309152038.DDJ59271.OJMOHLFtSFOQVF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tetsuo,

please do not start the off-list discussions ;)

On 09/15, Tetsuo Handa wrote:
>
> I examined do_coredump() case and found similar result.

...

> Do we want to change from call_usermodehelper_exec(UMH_WAIT_EXEC) to
> call_usermodehelper_exec(UMH_WAIT_EXEC | UMH_WAIT_KILLABLE)

To me, this makes sense in any case. And this matches other recent
"make coredump killable" changes.

> thread (who is waiting for pipe reader process to start) can terminate as soon
> as possible (rather than waiting forever unless somebody releases memory)?

But as for OOM this can't help if the dumping process is multithreaded.
This connects to other problems we discuss in another thread. probably
I should send the patch which does s/PT_TRACE_EXIT/SIGNAL_GROUP_COREDUMP/
at least.

Oleg.

