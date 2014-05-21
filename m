Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaEUVux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:50:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbaEUVuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:50:52 -0400
Date: Wed, 21 May 2014 23:50:49 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
In-Reply-To: <537D1E8B.1010505@zytor.com>
Message-ID: <alpine.LNX.2.00.1405212348140.12047@pobox.suse.cz>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com> <1400639227.9759.21.camel@pippen.local.home> <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com> <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz>
 <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com> <20140521163315.GJ21205@pd.tnic> <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz> <CA+55aFwiZxg3kS7seKPnkteOBA5N8ENXt6Y+Azn_HH6Z1iRN5w@mail.gmail.com> <20140521214319.GF25130@pd.tnic>
 <537D1E8B.1010505@zytor.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014, H. Peter Anvin wrote:

> > I certainly like this way of handling it. We can even issue a nice
> > banner saying something like "You're f*cked - go change hw."
> 
> Actually, it would be a lot better to panic than deadlock (HA systems
> tend to have something in place to catch the panic and/or reboot).  Any
> way we can see if the CPU is already holding that lock and panic in that
> case?

Well, spin_trylock() and then either spin_unlock() and proceed sending 
the signal, otherwise panic().

-- 
Jiri Kosina
SUSE Labs
