Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524Ab3IHRGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 13:06:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab3IHRGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 13:06:10 -0400
Date: Sun, 8 Sep 2013 19:00:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: Re: [REVIEW][PATCH 3/5] pidns: Don't have unshare(CLONE_NEWPID)
	imply CLONE_THREAD
Message-ID: <20130908170001.GA1835@redhat.com>
References: <87ob8gys0d.fsf@xmission.com> <87a9k0yrvu.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9k0yrvu.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay, vacation.

On 08/29, Eric W. Biederman wrote:
>
> I goofed when I made unshare(CLONE_NEWPID) only work in a
> single-threaded process.  There is no need for that requirement and in
> fact I analyzied things right for setns.  The hard requirement
> is for tasks that share a VM to all be in the pid namespace and
> we properly prevent that in do_fork.

Yes, agreed, with the current meaning of ->pid_ns unshare(NEWPID)
looks safe even if the caller is multi-threaded... and this matches
pidns_install() which doesn't require single-threaded.

Oleg.

