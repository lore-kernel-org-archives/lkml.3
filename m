Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab3IZAWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 20:22:54 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:46835 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3IZAWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 20:22:52 -0400
MIME-Version: 1.0
In-Reply-To: <1380140085-29712-5-git-send-email-tixxdz@opendz.org>
References: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
	<1380140085-29712-5-git-send-email-tixxdz@opendz.org>
Date: Wed, 25 Sep 2013 17:22:51 -0700
X-Google-Sender-Auth: oJAMNQT-s7PxHK-Tz8Pogz-JlNk
Message-ID: <CA+55aFwhb8rFbd8xT0==+r_QV-m8ANm+0sFEqUfk9Qg4rYpm-w@mail.gmail.com>
Subject: Re: [PATCH 04/12] seq_file: Make seq_file able to access the file's
 opener cred
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Djalal Harouni <tixxdz@opendz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        tixxdz@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 1:14 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>
> Therefor add the f_cred field to the seq_file struct and a helper
> seq_f_cred() to return it.

I hate how you've split up this patch from the next one that actually
_initializes_ the new field.

The two patches should have been one.

I think the patch should also remove the 'user_ns' member, since it's
now available as f_cred->user_ns.

I also suspect that it would be better to just make the the new
seq_file member point to the 'struct file' instead. Sure, it's an
extra level of indirection, but the lifetime of f_cred is not as clear
otherwise. You don't increment the reference count, which is correct
*only* because 'seq_file' has the same lifetime as 'struct file', and
thus the reference count from struct file for the f_cred is
sufficient.

[ Time passes, I look over the other patches ]

Oh, and I note that you remove user_ns in patch 12. Again, I think
that's just splitting things up too much. It actually gets harder to
see what happens when you do this.

               Linus
