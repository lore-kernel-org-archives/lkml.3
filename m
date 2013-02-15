Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab3BOUDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:03:14 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:41920 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3BOUDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:03:12 -0500
MIME-Version: 1.0
In-Reply-To: <20130214053656.GS4503@ZenIV.linux.org.uk>
References: <20130214053656.GS4503@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Feb 2013 12:02:50 -0800
X-Google-Sender-Auth: JFs_IhrCo6ouCrL4iv6P1uPBypg
Message-ID: <CA+55aFz1JjGSCdqXpVz3oH-PWFDE3Qdxt3EVxqC2i=nfLqf0Jw@mail.gmail.com>
Subject: Re: [RFC] SIGKILL vs. SIGSEGV on late execve() failures
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 9:36 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>         The only problem is that some suicides do SIGKILL, some SIGSEGV.
> AFAICS, it started as SIGSEGV and had been switched to SIGKILL for a.out
> (without any comments) in 1.1.62.

Ok, I really don't think it matters which one we do - either SIGSEGV
or SIGKILL is fine for a execve() that fails in those rare "impossible
to recover from" circumstances. And no, I have no memory what the
reason for the switch was, it's much too long ago..

               Linus
