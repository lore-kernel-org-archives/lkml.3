Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaEUVrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:47:25 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:39651 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaEUVrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:47:24 -0400
MIME-Version: 1.0
In-Reply-To: <537D1E8B.1010505@zytor.com>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <1400639227.9759.21.camel@pippen.local.home> <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
 <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz> <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com>
 <20140521163315.GJ21205@pd.tnic> <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
 <CA+55aFwiZxg3kS7seKPnkteOBA5N8ENXt6Y+Azn_HH6Z1iRN5w@mail.gmail.com>
 <20140521214319.GF25130@pd.tnic> <537D1E8B.1010505@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 14:47:03 -0700
Message-ID: <CALCETrVP3WtaQ72RgaPUuF2tAZRmJUtEyzyGMKWytv422_thmw@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "Luck, Tony" <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 2:45 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Adding Tony.
>
> On 05/21/2014 02:43 PM, Borislav Petkov wrote:
>> On Thu, May 22, 2014 at 06:37:26AM +0900, Linus Torvalds wrote:
>>> Seriously. If an NMI is interrupted by an MCE, you might as well
>>> consider the machine dead. Don't worry about it. We may or may not
>>> recover, but it is *not* our problem.
>>
>> I certainly like this way of handling it. We can even issue a nice
>> banner saying something like "You're f*cked - go change hw."
>>
>
> Actually, it would be a lot better to panic than deadlock (HA systems
> tend to have something in place to catch the panic and/or reboot).  Any
> way we can see if the CPU is already holding that lock and panic in that
> case?
>

Is there anything actually wrong with just panicking if
!user_mode_vm(regs)?  That would make this a lot more sane.

--Andy
