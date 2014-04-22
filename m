Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaDVXk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:40:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:8492 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaDVXky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:40:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,907,1389772800"; 
   d="scan'208";a="525741693"
Message-ID: <5356FE03.5070000@linux.intel.com>
Date: Tue, 22 Apr 2014 16:40:51 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: Brian Gerst <brgerst@gmail.com>, Andrew Lutomirski <amluto@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
References: <CAObL_7HdWs2hoNYd0gKzh6iVJr293Z9p+Dg1C6u+5GYQiDfgnA@mail.gmail.com> <CA+55aFzRf2Dhh3Eea1E74cpD9DXijUHpsXa71AURy_n6F_JKbw@mail.gmail.com> <CAObL_7EL8P0jgnjxkngqso47eFpYXHStNkvpzxSG_xCYgnaHng@mail.gmail.com> <CA+55aFwuKTQGHzi-cFkHrkLgkS-kFptajFt4=ginxOgwDcJLrA@mail.gmail.com> <5356A70A.5090907@zytor.com> <CAObL_7GJypym8JhUmdszDTKJVuLW9wSjbbZK4AZ3Jk304GK6tQ@mail.gmail.com> <CAMzpN2hpX=XHFrTKxV1hsngNX4Pmuh9FxjAqeSeQHhEBKza1DA@mail.gmail.com> <5356AF9F.4010301@zytor.com> <CAMzpN2gkCPZoAKCgXa8tNZYFCuiPd6GWg9yhTBSSA=F43WLv1A@mail.gmail.c!om> <5356BA2F.2030007@zytor.com> <20140422233930.GN22728@two.firstfloor.org>
In-Reply-To: <20140422233930.GN22728@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 04:39 PM, Andi Kleen wrote:
>> That simply will not work if you can take a #GP due to the "safe" MSR
>> functions from NMI and #MC context, which would be my main concern.
> 
> At some point the IST entry functions subtracted 1K while the
> handler ran to handle simple nesting cases.
> 
> Not sure that code is still there.

Doesn't help if you take an NMI on the first instruction of the #GP handler.

	-hpa


