Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbaDVLiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:38:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815AbaDVLiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:38:09 -0400
Message-ID: <53565491.702@redhat.com>
Date: Tue, 22 Apr 2014 13:37:53 +0200
From: Florian Weimer <fweimer@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Boaz Harrosh <openosd@gmail.com>, Jeff Layton <jlayton@redhat.com>,
        Jim Lieb <jlieb@panasas.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com
Subject: Re: Thoughts on credential switching
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com> <53341D8E.80105@redhat.com> <20140327060225.4f4caa5a@ipyr.poochiereds.net> <53342258.8000304@redhat.com> <533428BF.8090007@gmail.com>
In-Reply-To: <533428BF.8090007@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 02:33 PM, Boaz Harrosh wrote:

> man setuid should be saying DEPRECATED, EMULATED and SIGNAL NOT SAFE
> and be done with it POSIX or no POSIX who cares?

The glibc side cares, and there's also this bit: "It aims towards POSIX 
and Single UNIX Specification compliance.", which should be familiar.

I get that POSIX doesn't do what people want here (umask and current 
directory handling are another story).  But it hasn't really helped that 
some folks just said "POSIX sucks" and did their own thing, completely 
bypassing the system interfaces, instead of getting things fixed 
properly.  Now we have to balance the kernel behavior, POSIX demands, 
glibc dirty hacks to implement the questionable POSIX behavior on top of 
the kernel interfaces, and more dirty hacks to work around glibc because 
some applications do not like it.

I would really like to clean up this mess, but it's not clear to me 
where to start.

> Please show me one user of that and declare it brain dead.

Safely and demonstratively relinquishing elevated privileges.

> POSIX or not it just does not have any real programming mining
> at all.

What do you mean with "mining" in this context?

-- 
Florian Weimer / Red Hat Product Security Team
