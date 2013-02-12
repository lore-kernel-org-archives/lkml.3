Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787Ab3BLSq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:46:27 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:37946 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933742Ab3BLSq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:46:26 -0500
MIME-Version: 1.0
In-Reply-To: <511A8922.6050908@zytor.com>
References: <20130209110031.GA17833@n2100.arm.linux.org.uk>
 <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org>
 <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com>
 <5119C34B.70207@zytor.com> <CAMe9rOrTLGJvO+Z8kCG3gmOuW-Yq2Ex9WMfJZ5wmZcbz+zm94Q@mail.gmail.com>
 <CA+55aFwMr8pDfj+wuv=-tUFqZQOhnqkwC7tVq-S=4MGGWiqz1A@mail.gmail.com>
 <511A7892.4020407@zytor.com> <CAMe9rOrqDjBQjLyDRWJqRKdzQf1zMXHwXxFk2DekC+EeCHa8UA@mail.gmail.com>
 <511A8922.6050908@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Feb 2013 10:46:04 -0800
X-Google-Sender-Auth: URMlB_OYjh0OEVrKzxA__ut76-I
Message-ID: <CA+55aFympY-ie_SiMCnsE9emu_AS2zYCNJV=yp95Vu4tbPDoXA@mail.gmail.com>
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

On Tue, Feb 12, 2013 at 10:25 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> I just thought up this variant, I'm about to test it, but H.J., do you
> see any problems with it?

Looks good to me. And we already use __builtin_choose_expr(), so it's
"portable". And it should avoid all the potential issues with
bitfields (rmk already pointed out how bitfields don't work well with
the ARM model, who knows what other pitfalls bitfield code generation
could have)

I wonder if we could/should eventually do some of the sizeof() in
generic code - not have these magic things duplicated in all the
architectures, just have the architectures specify the raw typed
details (__copy_to_user_4() etc). So cross-platform portability could
be a good thing. That's a separate discussion, though, and possibly
not worth it.

                      Linus
