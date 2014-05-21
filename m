Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaEUWAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:00:01 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:45958 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbaEUV77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:59:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140521215547.GJ25130@pd.tnic>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <1400639227.9759.21.camel@pippen.local.home> <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
 <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz> <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com>
 <20140521163315.GJ21205@pd.tnic> <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
 <CALCETrVPVcyTd8FYV90DPhKvGW1GhHxkUPObpXK69AhwwqLi1w@mail.gmail.com>
 <20140521214845.GG25130@pd.tnic> <CALCETrUr75gGj3E5cSZdGRpX-wd6pDzDruMGave+GbnpWaptRA@mail.gmail.com>
 <20140521215547.GJ25130@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 14:59:38 -0700
Message-ID: <CALCETrWR+PqM6SxzqoRwghPgihjQCJ74VCN5AsAq3Kja64uCTg@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 2:55 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, May 21, 2014 at 02:52:55PM -0700, Andy Lutomirski wrote:
>> Why is it a problem if user_mode_vm(regs)?  Conversely, why is sending
>> a signal a remotely reasonable thing to do if !user_mode_vm(regs)?
>
> Let me quote Jiri:
>
> (1) task sends signal to itself
> (2) it acquires sighand->siglock so that it's able to queue the signal
> (3) MCE triggers

...and !user_mode_vm(regs), and hence we're IN_KERNEL, and we should
presumably just panic instead of trying to send a signal.

I missed the IN_KERNEL thing because I didn't realize that ->cs was
copied to struct mce.

--Andy
