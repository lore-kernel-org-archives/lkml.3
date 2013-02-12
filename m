Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507Ab3BLXta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:49:30 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:47465 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3BLXt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:49:28 -0500
MIME-Version: 1.0
In-Reply-To: <511ACDFB.1050707@zytor.com>
References: <511A8922.6050908@zytor.com> <tip-3578baaed4613a9fc09bab9f79f6ce2ac682e8a3@git.kernel.org>
 <CA+55aFzVSY6G3ZDy7YhwGd2k+OBtpDZaobw8awCeyZsaAqHDVw@mail.gmail.com> <511ACDFB.1050707@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Feb 2013 15:49:07 -0800
X-Google-Sender-Auth: UYWaiz-G4Yw8oVSC_pEFjk_Ed0A
Message-ID: <CA+55aFzU=zvjBPRSKCYHdf3ET-oq6s66e_PHHGcDwf3sJx+j+A@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: Redesign get_user with a
 __builtin_choose_expr hack
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 3:19 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Yes, but there doesn't seem to be any other way to do this.  gcc won't
> even allow "=cd" even if we know the variable is 64 bits, even though
> "=A" is documented to be equivalent to "=da".

No, "=da" means value "in edx _or_ %eax". Not the same as "A".

But you're right, there's nothing similar for %ebx:%ecx. I thought
there was. I was really sure we did something special for 64-bit adc
etc.

> Let me know what you think.

I guess we don't have any choice. And the other cleanups certainly look good.

              Linus
