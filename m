Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161615AbaJaBEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:04:52 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:36545 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161426AbaJaBEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:04:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAH_=xoa-3D+S22wnmxA5N4Z6V+GUPF_9KG0LkvGdTAzcdy2Lcg@mail.gmail.com>
References: <4e8f7a1abcf5e0527ef8968143b2d0fcae48f5f4.1414658968.git.e@nanocritical.com>
	<5452B241.5010603@amacapital.net>
	<CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
	<CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
	<CAH_=xoa-3D+S22wnmxA5N4Z6V+GUPF_9KG0LkvGdTAzcdy2Lcg@mail.gmail.com>
Date: Thu, 30 Oct 2014 18:04:49 -0700
X-Google-Sender-Auth: x1ZbZ-8URaVet1DUfzp9B3uDRAA
Message-ID: <CA+55aFw=VWtO19bcnyGRBCK856nNDONjNWXVoVnYhb66MH7YSw@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Rannaud <e@nanocritical.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 5:57 PM, Eric Rannaud <e@nanocritical.com> wrote:
>
> Yes, there definitely is a glibc bug: a fix is being worked on and it
> looks like it will go in. The change replaces the test for O_CREAT by
> a test for either O_CREAT or O_TMPFILE.

Why not just do it unconditionally? There really is no downside. Doing
it conditionally only makes the generated code slower and mode
complex. For absolutely zero gain, as far as I can tell. Does any
architecture actually do anything wrong?

It's actually closer in spirit to the original "open()" model than the
existing code.

              Linus
