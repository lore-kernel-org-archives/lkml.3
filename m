Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594Ab3BLEnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 23:43:00 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:40683 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab3BLEm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 23:42:58 -0500
MIME-Version: 1.0
In-Reply-To: <5119C34B.70207@zytor.com>
References: <20130209110031.GA17833@n2100.arm.linux.org.uk>
 <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org>
 <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com> <5119C34B.70207@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Feb 2013 20:42:37 -0800
X-Google-Sender-Auth: RDinyWhR55wQMwTZKp6q4d2Psn8
Message-ID: <CA+55aFx7KA-inJJog0v_cAsU0S2FeAN61pyvoUO8pbaxEAWFag@mail.gmail.com>
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

On Mon, Feb 11, 2013 at 8:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/11/2013 07:33 PM, Linus Torvalds wrote:
>
>> Has anybody run this past any gcc developers? And if so, did they run
>> away screaming?
>
> I haven't no... H.J., any comments on this patch?

I'd be most worried about any known pitfalls about bitfield code
generation. Looking at your code size numbers, it actually seems to
*improve* code generation except for the odd i386.pae case (bigger
code but also a different data size - odd) and i386 noconfig
(different bss, bigger code).

The code/data changes makes me wonder if the variable sometimes gets
flushed to memory as a 8-byte entry, and maybe there are things gcc
people can suggest..

But I don't see anything fundamentally wrong with it. Certainly it
looks much better than the disgusting and warning-prone

    unsigned long long __val_gu8

thing.

               Linus
