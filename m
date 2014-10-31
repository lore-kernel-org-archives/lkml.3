Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161779AbaJaCM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:12:59 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:40956 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161675AbaJaCMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:12:55 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw=VWtO19bcnyGRBCK856nNDONjNWXVoVnYhb66MH7YSw@mail.gmail.com>
References: <4e8f7a1abcf5e0527ef8968143b2d0fcae48f5f4.1414658968.git.e@nanocritical.com>
 <5452B241.5010603@amacapital.net> <CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
 <CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
 <CAH_=xoa-3D+S22wnmxA5N4Z6V+GUPF_9KG0LkvGdTAzcdy2Lcg@mail.gmail.com> <CA+55aFw=VWtO19bcnyGRBCK856nNDONjNWXVoVnYhb66MH7YSw@mail.gmail.com>
From: Eric Rannaud <e@nanocritical.com>
Date: Thu, 30 Oct 2014 19:12:32 -0700
Message-ID: <CAH_=xoatr9QcbLkk7Uf0eidoorNxCMqV8apr1wpqRhx5jHFHrg@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 6:04 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Oct 30, 2014 at 5:57 PM, Eric Rannaud <e@nanocritical.com> wrote:
>> Yes, there definitely is a glibc bug: a fix is being worked on and it
>> looks like it will go in. The change replaces the test for O_CREAT by
>> a test for either O_CREAT or O_TMPFILE.
>
> Why not just do it unconditionally? There really is no downside. Doing
> it conditionally only makes the generated code slower and mode
> complex. For absolutely zero gain, as far as I can tell. Does any
> architecture actually do anything wrong?

The immediate answer is "to keep the diff minimal". But I'll ask.

-- 
Eric Rannaud <e@nanocritical.com>
Nanocritical, CEO
