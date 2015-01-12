Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbbALUWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:22:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43251 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbbALUWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:22:42 -0500
Message-ID: <54B42CF2.2030104@zytor.com>
Date: Mon, 12 Jan 2015 12:22:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>
CC: Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] x86: introduce push/pop macros which generate CFI_REL_OFFSET
 and CFI_RESTORE
References: <1421017655-25561-1-git-send-email-dvlasenk@redhat.com> <20150112192314.GF3904@pd.tnic> <CALCETrXzEPKPFKBeKF3UMduNe1ViQTC6vULEySo_0XTJcK7Qkw@mail.gmail.com> <20150112193704.GG3904@pd.tnic> <CALCETrUVXGnqqtgw1eZRK5g0B+5vwGuvSV6dwnm5witA-fJWLQ@mail.gmail.com> <20150112201145.GH3904@pd.tnic> <CALCETrVto_uxTz30M8a4XyLk-UXTQXc3CsYxEKJkhmqH=FdvNA@mail.gmail.com>
In-Reply-To: <CALCETrVto_uxTz30M8a4XyLk-UXTQXc3CsYxEKJkhmqH=FdvNA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 12:14 PM, Andy Lutomirski wrote:
> On Mon, Jan 12, 2015 at 12:11 PM, Borislav Petkov <bp@alien8.de> wrote:
>> On Mon, Jan 12, 2015 at 11:46:53AM -0800, Andy Lutomirski wrote:
>>> Dumb example:
>>>
>>>     pushq_cfi $__KERNEL_DS /* ss */
>>>
>>> This doesn't save anything that the unwinder would care about.
>>
>> And? The unwinder or whatever looks at that info simply ignores stuff it
>> is not interested in, no?
> 
> But CFI_REL_OFFSET $__KERNEL_DS, 0 probably isn't even well-formed and
> won't build.
> 

I think this is relatively easy to deal with at the expense of a large
.ifeq statement in the macro.

	-hpa


