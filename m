Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbaDWBne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:43:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57508 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbaDWBnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:43:31 -0400
Message-ID: <53571A7D.8050702@zytor.com>
Date: Tue, 22 Apr 2014 18:42:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Lutomirski <amluto@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com> <535714A1.9080502@linux.intel.com> <CAObL_7HsnpGKRoBh+NZkW7SURqGx_4Dkfow=1-_7UU9uBV4UkA@mail.gmail.com>
In-Reply-To: <CAObL_7HsnpGKRoBh+NZkW7SURqGx_4Dkfow=1-_7UU9uBV4UkA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 06:23 PM, Andrew Lutomirski wrote:
> 
> What's the to_dmesg thing for?
> 

It's for debugging... the espfix page tables generate so many duplicate
entries that trying to output it via a seqfile runs out of memory.  I
suspect we need to do something like skip the espfix range or some other
hack.

> It looks sane, although I haven't checked the detailed register manipulation.
> 
> Users of big systems may complain when every single CPU lines up for
> that mutex.  Maybe no one cares.

Right now the whole smpboot sequence is fully serialized... that needs
to be fixed.

Konrad - I really could use some help figuring out what needs to be done
for this not to break Xen.

	-hpa

