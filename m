Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbaC0MqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 08:46:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbaC0MqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 08:46:16 -0400
Message-ID: <53341D8E.80105@redhat.com>
Date: Thu, 27 Mar 2014 13:46:06 +0100
From: Florian Weimer <fweimer@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Jim Lieb <jlieb@panasas.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com, Jeff Layton <jlayton@redhat.com>
Subject: Re: Thoughts on credential switching
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
In-Reply-To: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 01:23 AM, Andy Lutomirski wrote:

> I propose the following set of new syscalls:
>
> int credfd_create(unsigned int flags): returns a new credfd that
> corresponds to current's creds.
>
> int credfd_activate(int fd, unsigned int flags): Change current's
> creds to match the creds stored in fd.  To be clear, this changes both
> the "subjective" and "objective" (aka real_cred and cred) because
> there aren't any real semantics for what happens when userspace code
> runs with real_cred != cred.

This interface does not address the long-term lack of POSIX compliance 
in setuid and friends, which are required to be process-global and not 
thread-specific (as they are on the kernel side).

glibc works around this by reserving a signal and running set*id on 
every thread in a special signal handler.  This is just crass, and it is 
likely impossible to restore the original process state in case of 
partial failure.  We really need kernel support to perform the 
process-wide switch in an all-or-nothing manner.

-- 
Florian Weimer / Red Hat Product Security Team
