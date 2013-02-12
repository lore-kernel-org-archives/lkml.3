Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761247Ab3BLEri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 23:47:38 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:60278 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761198Ab3BLErg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 23:47:36 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFx7KA-inJJog0v_cAsU0S2FeAN61pyvoUO8pbaxEAWFag@mail.gmail.com>
References: <20130209110031.GA17833@n2100.arm.linux.org.uk>
 <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org>
 <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com>
 <5119C34B.70207@zytor.com> <CA+55aFx7KA-inJJog0v_cAsU0S2FeAN61pyvoUO8pbaxEAWFag@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Feb 2013 20:47:15 -0800
X-Google-Sender-Auth: a_uy0l-3HWJg9gKS9CwSu30J1Xw
Message-ID: <CA+55aFzmWfOQzVMPJUah3oEsn-aaeN5qtO=7P3MQUfLZmEFJZA@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user() warnings
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org, "H.J. Lu" <hjl.tools@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 8:42 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But I don't see anything fundamentally wrong with it. Certainly it
> looks much better than the disgusting and warning-prone
>
>     unsigned long long __val_gu8
>
> thing.

Oh. I just realized. That was your _baseline_ in the comparisons, wasn't it?

Can you please make the baseline be the current mainline git version
of <asm/uaccess.h>, not the first "unsigned long long __val_gu8"
version of the 64-bit get_user()?

Because we should compare against the straightforward code, not the
one that could have messed things up already..

              Linus
