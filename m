Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab3I1Ofb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 10:35:31 -0400
Received: from numidia.opendz.org ([98.142.220.152]:39760 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3I1Of2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 10:35:28 -0400
Date: Sat, 28 Sep 2013 15:35:23 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        tixxdz@gmail.com
Subject: Re: [PATCH 06/12] procfs: make /proc/*/stack 0400
Message-ID: <20130928143523.GA2199@dztty>
References: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
 <1380140085-29712-7-git-send-email-tixxdz@opendz.org>
 <CAGXu5jJKH6WPSMnqALOEjqGb6ZoeyYzj5vemk=2z4KPZyg=ptw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJKH6WPSMnqALOEjqGb6ZoeyYzj5vemk=2z4KPZyg=ptw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 03:43:24PM -0500, Kees Cook wrote:
> On Wed, Sep 25, 2013 at 3:14 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > The /proc/*/stack contains sensitive information and currently its mode
> > is 0444. Change this to 0400 so the VFS will be able to block
> > unprivileged processes to get file descriptors on arbitrary privileged
> > /proc/*/stack files.
> >
> > The /proc/*/stack is a /procfs ONE file that shares the same ->open()
> > file operation with other ONE files. Doing a ptrace_may_access() check
> > during open() might break userspace from accessing other ONE files
> > like /proc/*/stat and /proc/*/statm.
> >
> > Therfore make it 0400 for now, and improve its check during ->read()
> > in the next following patch.
> >
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Eric W. Biederman <ebiederm@xmission.com>
> > Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> 
> While the rest of the series is being discussed, I think it would be
> nice to at least get this into the tree. Fixing this reduces which
> processes are exposed to ASLR leaks. The rest of the series closes the
> remaining holes.
> 
> I would if it would be valuable adding a test for the identified leak
> conditions to some test suite? LTP perhaps?
I'm not familiar with LTP, but I guess a small program that perform I/O
redirection and execve a suid-exec will do it?

I'll try to add code comment in fs/proc/base.c


> -Kees
> 
> -- 
> Kees Cook
> Chrome OS Security

-- 
Djalal Harouni
http://opendz.org
