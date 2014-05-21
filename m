Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaEUVqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:46:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42373 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbaEUVqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:46:39 -0400
Message-ID: <537D1E8B.1010505@zytor.com>
Date: Wed, 21 May 2014 14:45:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Jiri Kosina <jkosina@suse.cz>, Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com> <1400639227.9759.21.camel@pippen.local.home> <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com> <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz> <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com> <20140521163315.GJ21205@pd.tnic> <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz> <CA+55aFwiZxg3kS7seKPnkteOBA5N8ENXt6Y+Azn_HH6Z1iRN5w@mail.gmail.com> <20140521214319.GF25130@pd.tnic>
In-Reply-To: <20140521214319.GF25130@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Tony.

On 05/21/2014 02:43 PM, Borislav Petkov wrote:
> On Thu, May 22, 2014 at 06:37:26AM +0900, Linus Torvalds wrote:
>> Seriously. If an NMI is interrupted by an MCE, you might as well
>> consider the machine dead. Don't worry about it. We may or may not
>> recover, but it is *not* our problem.
> 
> I certainly like this way of handling it. We can even issue a nice
> banner saying something like "You're f*cked - go change hw."
> 

Actually, it would be a lot better to panic than deadlock (HA systems
tend to have something in place to catch the panic and/or reboot).  Any
way we can see if the CPU is already holding that lock and panic in that
case?

	-hpa


