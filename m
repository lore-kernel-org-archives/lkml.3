Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab3JGMuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:50:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab3JGMt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 08:49:59 -0400
Date: Mon, 7 Oct 2013 14:43:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/pid.c: check pid whether be NULL in
	__change_pid()
Message-ID: <20131007124319.GA24450@redhat.com>
References: <52528CF7.8050405@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52528CF7.8050405@asianux.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07, Chen Gang wrote:
>
> Within __change_pid(), 'new' may be NULL if it comes from detach_pid(),
> and 'link->pid' also may be NULL ("link->pid = new"), so theoretically,\
> the original 'link->pid' may be NULL, too.

I don't really understand this "theoretically",

> In real world, at least now, all callers which will call detach_pid()
> or change_pid() will not cause issue,

Yes,

> but still recommend to check it
> in __change_pid() to let itself consistency.

Why?

Contrary, I think we should not hide the problem. If __change_pid() is
called when task->pids[type].pid is already NULL there is something
seriously wrong.

Oleg.

