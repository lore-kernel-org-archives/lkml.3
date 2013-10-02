Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3JBBkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 21:40:47 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50253 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3JBBko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 21:40:44 -0400
Message-ID: <524B7999.60806@amacapital.net>
Date: Tue, 01 Oct 2013 18:40:41 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Djalal Harouni <tixxdz@opendz.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, tixxdz@gmail.com
Subject: Re: [PATCH v2 0/9] procfs: protect /proc/<pid>/* files with file->f_cred
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 01:26 PM, Djalal Harouni wrote:
> /proc/<pid>/* entries varies at runtime, appropriate permission checks
> need to happen during each system call.
> 
> Currently some of these sensitive entries are protected by performing
> the ptrace_may_access() check. However even with that the /proc file
> descriptors can be passed to a more privileged process
> (e.g. a suid-exec) which will pass the classic ptrace_may_access()
> check. In general the ->open() call will be issued by an unprivileged
> process while the ->read(),->write() calls by a more privileged one.
> 
> Example of these files are:
> /proc/*/syscall, /proc/*/stack etc.
> 
> And any open(/proc/self/*) then suid-exec to read()/write() /proc/self/*
> 
> 
> These files are protected during read() by the ptrace_may_access(),
> however the file descriptor can be passed to a suid-exec which can be
> used to read data and bypass ASLR. Of course this was discussed several
> times on LKML.

Can you elaborate on what it is that you're fixing?  That is, can you
give a concrete example of what process opens what file and passes the
fd to what process?

I'm having trouble following your description.

--Andy

