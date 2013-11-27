Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab3K0XNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 18:13:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47587 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757549Ab3K0XNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 18:13:13 -0500
Date: Thu, 28 Nov 2013 00:13:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
Message-ID: <20131127231305.GN32267@pd.tnic>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>
 <5294F10C.8060901@amacapital.net>
 <CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com>
 <52964EC7.9000504@zytor.com>
 <52966C0A.7070201@zytor.com>
 <20131127222104.GA748@pd.tnic>
 <b6331d08-d5fb-4ec5-80e2-ff32d3ce93ce@email.android.com>
 <20131127222944.GB748@pd.tnic>
 <cb0c1623-0e58-4418-b22e-cdcadbf31dea@email.android.com>
 <CA+55aFzTppZ+uhZ+mfHYmmJ9+aboEMUQ9PUfW63BTA-z+1nWqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFzTppZ+uhZ+mfHYmmJ9+aboEMUQ9PUfW63BTA-z+1nWqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 03:04:41PM -0800, Linus Torvalds wrote:
> So sysexit/sysret doesn't count as a serializing instruction, no.
> But it doesn't need to, because *self*-modifying code doesn't need a
> serializing instruction, only a branch. It's only *cross*-modifying
> code that needs a serializing instruction.
>
> So the IPI is sufficient for the cross-modifying case, and the sysret
> is sufficient for the self-modifying case. And we also don't need
> to worry about "what happens if we schedule to another CPU, and
> self-modifying becomes cross-modifying", because the scheduling will
> then do the serializing instruction.
>
> So IPI for other CPU's (limited to the mm-mask) and just a system call
> for local CPU should be perfectly fine.

Cool, so basically an empty dummy syscall IPI-ed to all cores. With a
big fat comment on top.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
