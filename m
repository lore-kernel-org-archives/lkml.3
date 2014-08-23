Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118AbaHWNci (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 09:32:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaHWNch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 09:32:37 -0400
Date: Sat, 23 Aug 2014 15:30:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
	added to -mm tree
Message-ID: <20140823133001.GA966@redhat.com>
References: <20140822192241.GA26512@redhat.com> <20140822201550.GA25918@moon> <20140823115302.GA27587@redhat.com> <20140823122214.GF25918@moon> <20140823131412.GA31685@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140823131412.GA31685@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to mention,

On 08/23, Oleg Nesterov wrote:
>
> On 08/23, Cyrill Gorcunov wrote:
>
> > Looks like I need
> > to use cred_guard_mutex instead of task_lock here, no?
>
> Please don't. First of all, it can't help because proc_pid_auxv() doesn't hold
> this lock. It does mm_access() which drops this lock after return. And to remind,
> we are going to remove mm_access/lock_trace from sys_read() paths in proc.

Besides, it can't help anyway. cred_guard_mutex is per-process (not per-thread),
suppose that a vfork()'ed child does prctl() while another thread reads the
parent's /proc/pid/auxv.

Cyrill, I am sorry, but I am starting to think that this patch should be
dropped and replaced by another version. Or do you think it would be better
to send the fixes on top?

Oleg.

