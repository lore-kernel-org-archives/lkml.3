Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587Ab3BLRt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:49:57 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:51579 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab3BLRt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:49:56 -0500
MIME-Version: 1.0
In-Reply-To: <511A7D50.9090804@zytor.com>
References: <20130209110031.GA17833@n2100.arm.linux.org.uk>
 <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org>
 <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com>
 <5119C34B.70207@zytor.com> <CAMe9rOrTLGJvO+Z8kCG3gmOuW-Yq2Ex9WMfJZ5wmZcbz+zm94Q@mail.gmail.com>
 <CA+55aFwMr8pDfj+wuv=-tUFqZQOhnqkwC7tVq-S=4MGGWiqz1A@mail.gmail.com>
 <511A7892.4020407@zytor.com> <CA+55aFz=OnntmRvi6geuL7ccC6ncwQ7NvURDcwu87BkpS3H0TQ@mail.gmail.com>
 <511A7D50.9090804@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Feb 2013 09:49:30 -0800
X-Google-Sender-Auth: 3iGz2ke4Wu-ijyv5J22w3gOSKf8
Message-ID: <CA+55aFxTnLbT7yjxzP8_eAXV-YDFMgSu-6Op-Hr3aDhAw_S=BQ@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user() warnings
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@kernel.org>,
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

On Tue, Feb 12, 2013 at 9:35 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> On the other hand, it still uses two gcc extensions: long long bitfields and
> typeof.
>
> I'll see what kind of code we get with the macro.

At least one thing to look out for is the poor LLVM people who are
trying to make the kernel compile with that compiler.. We shouldn't
make it arbitrarily harder for them, so *some* level of portability is
a good idea.

Then there is icc, but I don't know how relevant that would ever be.
At least LLVM has the potential to be widely available.

Of course, they may both already support even the odd gcc builtins -
we already use a lot of the more straightforward ones...

            Linus
