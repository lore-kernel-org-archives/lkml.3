Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3CLTUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:20:22 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:39309 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab3CLTUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:20:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130312191118.GA17439@redhat.com>
References: <1363058712.4534.12.camel@pasglop>
	<CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com>
	<CAKi4VALkUhOtP_8BOi3Mi8fTz8TUPwmwQq7WW27BEDue2wFNRw@mail.gmail.com>
	<20130312182210.GA15862@redhat.com>
	<CA+55aFz9M1RWOwyRuatxnyQ+_ON0+A032QcW9=oBOks1JPt13w@mail.gmail.com>
	<20130312191118.GA17439@redhat.com>
Date: Tue, 12 Mar 2013 12:20:19 -0700
X-Google-Sender-Auth: W0VfZJCOHc7yvQUkVwGpZ9pMbfs
Message-ID: <CA+55aFzmATkP-W0uX1a_gP7E1fwcp2Mh4537Ou2uwHDixNKPTg@mail.gmail.com>
Subject: Re: Regression with orderly_poweroff()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 12:11 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Confused... which arguments? The only argument is poweroff_cmd, it can't
> go away and kmalloc(GFP_KERNEL) is fine in work->func() ?

Hmm. I guess in this particular situation, we really don't have any
arguments from callers, no. I was confused by the fact that we had
that argv_split/argv_free thing, but that doesn't actually come from
the callers, it just comes from our own buffer. So yeah, I guess
everything could just go into a workqueue.

               Linus
