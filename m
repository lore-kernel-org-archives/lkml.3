Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665Ab3BLS3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:29:35 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:47351 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933532Ab3BLS3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:29:34 -0500
MIME-Version: 1.0
In-Reply-To: <511A8922.6050908@zytor.com>
References: <20130209110031.GA17833@n2100.arm.linux.org.uk>
	<tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org>
	<CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com>
	<5119C34B.70207@zytor.com>
	<CAMe9rOrTLGJvO+Z8kCG3gmOuW-Yq2Ex9WMfJZ5wmZcbz+zm94Q@mail.gmail.com>
	<CA+55aFwMr8pDfj+wuv=-tUFqZQOhnqkwC7tVq-S=4MGGWiqz1A@mail.gmail.com>
	<511A7892.4020407@zytor.com>
	<CAMe9rOrqDjBQjLyDRWJqRKdzQf1zMXHwXxFk2DekC+EeCHa8UA@mail.gmail.com>
	<511A8922.6050908@zytor.com>
Date: Tue, 12 Feb 2013 10:29:33 -0800
Message-ID: <CAMe9rOoZOmcRKaSKsgp0gimHexW3DZCZKugQOztiuOixTZFbUQ@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user() warnings
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 10:25 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> I just thought up this variant, I'm about to test it, but H.J., do you
> see any problems with it?
>
> #define itype(x) \
> __typeof__(__builtin_choose_expr(sizeof(*(x)) > sizeof(0UL), 0ULL, 0UL))
>
> I tried it out with a small test program (attached), and it seems to
> work.  Next for using it in the kernel...
>
>         -hpa
>

It looks OK to me.

-- 
H.J.
