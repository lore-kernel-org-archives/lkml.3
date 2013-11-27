Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab3K0WZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:25:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53289 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757452Ab3K0WZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:25:57 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20131127222104.GA748@pd.tnic>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <5294F10C.8060901@amacapital.net> <CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com> <52964EC7.9000504@zytor.com> <52966C0A.7070201@zytor.com> <20131127222104.GA748@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Add a text_poke syscall v2
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 27 Nov 2013 14:25:29 -0800
To: Borislav Petkov <bp@alien8.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <b6331d08-d5fb-4ec5-80e2-ff32d3ce93ce@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually the CPUID is superfluous on anything than the executing CPU since IRET is serializing.

Borislav Petkov <bp@alien8.de> wrote:
>On Wed, Nov 27, 2013 at 02:02:50PM -0800, H. Peter Anvin wrote:
>> For the record, this is the entire patch necessary to do the
>> sync_cores() system call -- and no potential interactions with
>security
>> frameworks or whatnot, simply because no security-sensitive
>operations
>> are performed of any kind.
>> 
>> Comments/opinions appreciated.
>
>And we do this in the kernel not because userspace can't execute
>sync_core() aka CPUID but because for userspace it is hard to IPI all
>cores easily?

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
