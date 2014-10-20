Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaJTV5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:57:51 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:44795 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbaJTV5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:57:50 -0400
MIME-Version: 1.0
In-Reply-To: <54458199.1000607@zytor.com>
References: <cover.1411494540.git.luto@amacapital.net> <54458199.1000607@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 20 Oct 2014 14:57:28 -0700
Message-ID: <CALCETrXcTwOQLQX0Tx8XgDPaWit9P5ut1p8mDehAcAah9V17wQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] x86: Disentangle the vdso and clean it up
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 2:41 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 09/23/2014 10:50 AM, Andy Lutomirski wrote:
>>
>> Patch 8 removes the vvar that selects the getcpu mode.  That vvar
>> has been unnecessary for a couple of years, ever since alternative
>> patching has worked in the vdso.
>>
>
> Is there any fundamental reason to not always use LSL at this point?

No, other than aesthetics.

Crappy timings on my dev box:

rdtscp: 18ns (and slowdown of nearly insns because it's like lfence or
mfence IIRC)

lsl: 15ns

just for fun, lsl of an out of bounds descriptor: 46ns

lsl is also nice because it works even if CR4.TSD is set.

I know I probably shouldn't say this, but sgdt is even faster (<8ns)

Should I send a replacement for patch 8 or should I let you merge 1-7
and fold this into the followup series?

--Andy
