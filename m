Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaDVT2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:28:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51314 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbaDVT16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:27:58 -0400
Date: Tue, 22 Apr 2014 21:27:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrew Lutomirski <amluto@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
Message-ID: <20140422192752.GH15882@pd.tnic>
References: <20140422144659.GF15882@pd.tnic>
 <CAObL_7FGs4n6zusbdwTLi5W5q2V81Sf7pOnOmHPFyv5d7jMfvA@mail.gmail.com>
 <53569467.1030809@zytor.com>
 <CAObL_7F9yxt=vXjbssYB5wjZ7HUyKcstG7KYaRWxDDK0n7_vQw@mail.gmail.com>
 <CA+55aFyg1n6=Lnp_qhqdGESoP3u-sv_+MbvSdT4MEutGQAJESg@mail.gmail.com>
 <CAObL_7HdWs2hoNYd0gKzh6iVJr293Z9p+Dg1C6u+5GYQiDfgnA@mail.gmail.com>
 <CA+55aFzRf2Dhh3Eea1E74cpD9DXijUHpsXa71AURy_n6F_JKbw@mail.gma!il.com>
 <5356A2BF.2060609@zytor.com>
 <20140422172630.GG15882@pd.tnic>
 <CAObL_7GOMT8Jv27LhCA=UHY=6kbgtfzQeVYUUkZp2cZCu1AM3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAObL_7GOMT8Jv27LhCA=UHY=6kbgtfzQeVYUUkZp2cZCu1AM3A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:29:45AM -0700, Andrew Lutomirski wrote:
> Or we could add a TIF_NEEDS_ESPFIX that gets set once you have a
> 16-bit LDT entry.

Or something like that, yep.

> But I think it makes sense to nail down everything else first. I
> suspect that a single test-and-branch in the iret path will be lost in
> the noise from iret itself.

The cumulative effects of such additions here and there are nasty
though. If we can make the general path free relatively painlessly, we
should do it, IMO.

But yeah, later.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
