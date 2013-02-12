Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab3BLRBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:01:03 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:50806 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab3BLRBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:01:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAMe9rOrTLGJvO+Z8kCG3gmOuW-Yq2Ex9WMfJZ5wmZcbz+zm94Q@mail.gmail.com>
References: <20130209110031.GA17833@n2100.arm.linux.org.uk>
 <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org>
 <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com>
 <5119C34B.70207@zytor.com> <CAMe9rOrTLGJvO+Z8kCG3gmOuW-Yq2Ex9WMfJZ5wmZcbz+zm94Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Feb 2013 09:00:30 -0800
X-Google-Sender-Auth: Oblg-JADUha1vdvc7YsswX4XGqg
Message-ID: <CA+55aFwMr8pDfj+wuv=-tUFqZQOhnqkwC7tVq-S=4MGGWiqz1A@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user() warnings
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 8:38 AM, H.J. Lu <hjl.tools@gmail.com> wrote:
>
> Can you do something similar to what we did in glibc:

No. Because we use macros to be type-independent (i e"get_user()"
works *regardless* of type), so casting to "uintptr_t" doesn't work.
It throws away the type information, and truncates 64-bit values on
32-bit architectures.

The whole point of the bitmask thing is that it doesn't have that
issue, and gets the size correct automatically. It's not pretty, but
it allows the rest of the sources to be readable.

                Linus
