Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaDVBtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:49:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44249 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaDVBtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:49:03 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CAObL_7FMX9yaGVi19pVwsU5VwHqKLLWMEB7kwDF-fatsGnHvdQ@mail.gmail.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com> <CAObL_7EJi5+m-oDXRy4hu+-OTZ=9wZ9WEivTMsdDtccU00wfWA@mail.gmail.com> <5355A9E9.9070102@zytor.com> <CAObL_7EP+zPpx9TVgsSu2iFN+r0U8yy6UEZtdk=CPwowXUu=Qw@mail.gmail.com> <1dbe8155-58da-45c2-9dc0-d9f4b5a6e643@email.android.com> <CAObL_7FUDpV9md+UnDbXxWw=trrXLFLNNJMNegdezrQt7rm6TA@mail.gmail.com> <a035392c-f332-4b3f-b851-13b0c7a0fc68@email.android.com> <CAObL_7FMX9yaGVi19pVwsU5VwHqKLLWMEB7kwDF-fatsGnHvdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 21 Apr 2014 18:47:52 -0700
To: Andrew Lutomirski <amluto@gmail.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Message-ID: <ee12ff5e-91fe-487b-bed9-4472f15f94fe@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Race condition (although with x86 being globally ordered, it probably can't actually happen.) The bitmask is probably the way to go.

On April 21, 2014 6:28:12 PM PDT, Andrew Lutomirski <amluto@gmail.com> wrote:
>On Mon, Apr 21, 2014 at 6:14 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> I wanted to avoid the "another cpu made this allocation, now I have
>to free" crap, but I also didn't want to grab the lock if there was no
>work needed.
>
>I guess you also want to avoid bouncing all these cachelines around on
>boot on bit multicore machines.
>
>I'd advocate using the bitmap approach or simplifying the existing
>code.  For example:
>
>+       for (n = 0; n < ESPFIX_PUD_CLONES; n++) {
>+               pud = ACCESS_ONCE(pud_p[n]);
>+               if (!pud_present(pud))
>+                       return false;
>+       }
>
>I don't see why that needs to be a loop.  How can one clone exist but
>not the others?
>
>--Andy

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
