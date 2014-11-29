Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaK2SIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 13:08:23 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:44969 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaK2SIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 13:08:22 -0500
MIME-Version: 1.0
In-Reply-To: <5479E11C.8080701@oracle.com>
References: <1417046282-31825-1-git-send-email-sasha.levin@oracle.com>
	<CA+55aFwjTTcGFbbEPWckxZHya5PFWo+MFbK9zMzoqZorXV21nQ@mail.gmail.com>
	<54768059.1080406@oracle.com>
	<CA+55aFxx+Ye+v6bkK0TwzkAHxSEUc7e-EAW-1JD8mySE2nVq2w@mail.gmail.com>
	<5479E11C.8080701@oracle.com>
Date: Sat, 29 Nov 2014 10:08:21 -0800
X-Google-Sender-Auth: 305RSMUjO-1krmpTuPu6K0Nt4FM
Message-ID: <CA+55aFzTc=vXUQ8ZrWWVj4DNmrZOEr3bcYpiGt6+KEVWPW-x2g@mail.gmail.com>
Subject: Re: [RFC v2 1/2] compiler: use compiler to detect integer overflows
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 7:07 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> Since we can't just change those to unsigned

Sure we can. Just cast them. A signed start/len is bogus crap, it's a
random wrong type.

If you want to, add a "if (len < 0) return -EINVAL;" before the cast,
but treating negative numbers as big positive numbers sounds fine too.

> we'd still need to do an overflow
> check with signed integers somewhere.

Why? It's just a type. User space can't care, and signed values make
no sense anyway.

                 Linus
