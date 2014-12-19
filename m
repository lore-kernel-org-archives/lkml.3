Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbaLSFBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 00:01:24 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:55912 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaLSFBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 00:01:23 -0500
MIME-Version: 1.0
In-Reply-To: <8761d8tq4p.fsf@rustcorp.com.au>
References: <8761d8tq4p.fsf@rustcorp.com.au>
Date: Thu, 18 Dec 2014 21:01:22 -0800
X-Google-Sender-Auth: Km2Y1oTSa_9IAcEGkhsZe7oTo6w
Message-ID: <CA+55aFxS_JuFE+RM8cjeLx5tXu8XJVznfyrD4MSUqV85gPfx0w@mail.gmail.com>
Subject: Re: [PULL] modules-next
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ionut Alexa <ionut.m.alexa@gmail.com>, Kees Cook <keescook@chromium.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 4:55 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> The exciting thing here is the getting rid of stop_machine on module
> removal.  This is possible by using a simple atomic_t for the counter,
> rather than our fancy per-cpu counter: it turns out that no one is doing
> a module increment per net packet, so the slowdown should be in the noise.

Famous last words. It may not happen per-packet, but I see
module_get() in various block drivers and in netfilter code etc, and
some of them may be pretty bad.

Let's see how it all works out.

                       Linus
