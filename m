Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbaGSOt6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 10:49:58 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:45777 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaGSOtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 10:49:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140719061658.GK18775@thunk.org>
References: <20140718191908.GA20534@www.outflux.net>
	<20140719061658.GK18775@thunk.org>
Date: Sat, 19 Jul 2014 07:49:55 -0700
X-Google-Sender-Auth: RfMbXw5yfZQEqj2UchSYAZNUxMA
Message-ID: <CAGXu5jLjhXz3G-R18a=4U4OqSo8hLdW7OocCcLaEBLfYs=mAtA@mail.gmail.com>
Subject: Re: [PULL] seccomp update (3.17)
From: Kees Cook <keescook@chromium.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Kees Cook <keescook@chromium.org>,
        James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>,
        David Drysdale <drysdale@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 11:16 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Jul 18, 2014 at 12:19:08PM -0700, Kees Cook wrote:
>> Hi James,
>>
>> Please pull these seccomp changes for 3.17.
>>
>> (And if I should base off something other than security-next, please
>> let me know. Or if there are any things I should be doing differently
>> with this tree.)
>
> One note; there is a (interim) syscall number collision with the new
> getrandom(2) system call.  I'm sure Linus will be able to handle it,
> and fix it up, but I just wanted to give a heads up that depending on
> which pull request hits mainline first, the syscall number for either
> the new seccomp(2) or getrandom(2) may end up changing.
>
> I've been warning people not to try to use getrandom(2) or check
> anything into LibreSSL, et. al., until the patch is finalized and in
> Linus's tree, but if you have userspace users already using the
> syscall assignments in this patch series, please let me know and I can
> try to make adjustments on my side.

No worries -- the only user of the seccomp syscall that I know of is
the seccomp regression testing suite, and that'd be trivially to fix.

I would note that the seccomp series includes adding the syscall also
to ARM and MIPS, so from a collision fixing perspective, it may be
fewer edits to fix getrandom instead. :)

-Kees

-- 
Kees Cook
Chrome OS Security
