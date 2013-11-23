Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab3KWPbM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 10:31:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab3KWPbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 10:31:10 -0500
Date: Sat, 23 Nov 2013 16:32:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, keescook@chromium.org,
        mhocko@suse.cz, snanda@chromium.org, dserrg@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] check_unsafe_exec: kill the dead -EAGAIN and
	clear_in_exec logic
Message-ID: <20131123153218.GA22071@redhat.com>
References: <20131122175442.GA31453@redhat.com> <528FBE22.5030208@jp.fujitsu.com> <20131122204917.GA20520@redhat.com> <528FC5E8.20406@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528FC5E8.20406@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22, KOSAKI Motohiro wrote:
>
> >> I have found no problem in this patch. However, I have a very basic question.
> >> Why do we need to keep fs->in_exec?
> >
> > To ensure that a sub-thread can't create a new process with the same
> > ->fs while we are doing exec without LSM_UNSAFE_SHARE, I guess. This
> > is only for security/ code.
>
> But in LSM_UNSAFE_SHARE case, we have no check, right? I'm amazing why
> we don't need anything.

Yes. We rely on security/ code in this case, it can nack this exec if it
looks unsafe.

IOW. If LSM_UNSAFE_SHARE is not set, we promise that this fs has a single
user: the execing thread (it will kill other subthreads which can have the
same fs). That is why we need to cancel any attempt to create another
CLONE_FS process in between.

But let me repeat this is only my speculations, I know nothing about selinux
and selinux_bprm_set_creds() in particular. Although it looks obvious that
potentially exec with the shared ->fs has the additional security problems.

Kosaki, thank you for review!

Oleg.

