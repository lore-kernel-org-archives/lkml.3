Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaDOMJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:09:06 -0400
Received: from numidia.opendz.org ([98.142.220.152]:41274 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaDOMJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:09:04 -0400
Date: Tue, 15 Apr 2014 13:09:00 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH v2 1/2] procfs: make /proc/*/{stack,syscall,personality}
 0400
Message-ID: <20140415120900.GA5766@dztty>
References: <1395495460-7652-1-git-send-email-tixxdz@opendz.org>
 <1395495460-7652-2-git-send-email-tixxdz@opendz.org>
 <20140328153231.93bcad089d9ccc670ee6cc17@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140328153231.93bcad089d9ccc670ee6cc17@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 03:32:31PM -0700, Andrew Morton wrote:
> On Sat, 22 Mar 2014 14:37:39 +0100 Djalal Harouni <tixxdz@opendz.org> wrote:
> 
> > These procfs files contain sensitive information and currently their
> > mode is 0444. Change this to 0400, so the VFS will be able to block
> > unprivileged processes from getting file descriptors on arbitrary
> > privileged /proc/*/{stack,syscall,personality} files.
> > 
> > This reduces the scope of ASLR leaking and bypasses by protecting
> > already running processes.
> 
> Sigh.  Why on earth did we make these 444 in the first place.
> 
> There is risk of breakage here.  Probably anyone who is using these
> files and who observes such breakage is a sophisticated user who
> understands the reasons and knows how to make the tools work again. 
> There's only one way to find out :(
> 
> I can't remember why we even added /proc/pid/syscall - the changelog
> doesn't give a rationale (this is regrettably common).
Yep :-/

Ok, thank you for taking the patches!

Just to update the tread, Alexey Dobriyan suggested that we also improve
/proc/*/wchan

I'll do it by caching the ptrace check during open time, and re-check it
in proc_pid_wchan() only in case we return an address, this way we do not
break tools. Will add it to the patches I've and send it soon (didn't
want to disturb you during the merge window).

Thanks!

-- 
Djalal Harouni
http://opendz.org
