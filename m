Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbaEZTSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:18:11 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:41140 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaEZTSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:18:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140526191353.GB6887@dztty>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
 <1401110850-3552-2-git-send-email-tixxdz@opendz.org> <CALCETrUte7WRMi23+rp+XbgAoOcw=TPZe02YEuZRZyVroj+mfQ@mail.gmail.com>
 <20140526172101.GA6380@dztty> <CALCETrU=Jy-urWRcRnRyUNKgJFKykcQP6Diy35R3Uf=7fw_wqw@mail.gmail.com>
 <20140526191353.GB6887@dztty>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 26 May 2014 12:17:48 -0700
Message-ID: <CALCETrU1xjXvwtuYyqGhDgch7cZgP_LWLNDC8b8oeEtwJ0UNmg@mail.gmail.com>
Subject: Re: [PATCH 1/9] procfs: use flags to deny or allow access to /proc/<pid>/$entry
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 12:13 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> On Mon, May 26, 2014 at 11:06:40AM -0700, Andy Lutomirski wrote:
>> On Mon, May 26, 2014 at 10:21 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
>> > I would like to keep it enum, enum is type-safe and I want to follow the
>> > semantics of /proc/pid/stat and others:
>>
>> It's not type-safe the way you're doing it, though.
> Can you please shed some light Andy, thank you in advance!

You're casting these things back and forth.  If you were storing enum
values in an enum-typed variable, great, but you're not.

--Andy
