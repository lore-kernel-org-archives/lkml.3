Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3J2KFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:05:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49184 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab3J2KFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:05:04 -0400
Date: Tue, 29 Oct 2013 11:04:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Gleb Natapov <gleb@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Andre Przywara <andre@andrep.de>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/6] kvm, emulator: Add initial three-byte insns support
Message-ID: <20131029100457.GC10972@pd.tnic>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
 <1379861095-628-5-git-send-email-bp@alien8.de>
 <20131029095043.GV15657@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131029095043.GV15657@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 11:50:43AM +0200, Gleb Natapov wrote:
> There are two three opcode tables, so third_opcode_byte is ambiguous.

Actually there's also 0F_3A and there are also other prefixes besides f0
and f1. Oh, and those tables are not completely full so I can imagine
more stuff coming in later....

I know what you're thinking by now, btw :-)

> What about pfx_0f_38_f0 and pfx_0f_38_f1?

Yeah, those make it much more explicit.

I wanted to keep the "three_byte" in the name in there somewhere,
though, so that it is clear that we're dealing with three byte opcodes
instead of requiring the onlooking innocent person to know the opcodes.

How about:

three_byte_0f_38_f0
three_byte_0f_38_f1
three_byte_0f_3a_50
...

Last one is an example only.

Btw, we might want to reconsider that whole tabular representation when
more stuff needs to be added...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
