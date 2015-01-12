Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbbALU1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:27:05 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:40201 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbbALU1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:27:00 -0500
MIME-Version: 1.0
In-Reply-To: <54B42CF2.2030104@zytor.com>
References: <1421017655-25561-1-git-send-email-dvlasenk@redhat.com>
 <20150112192314.GF3904@pd.tnic> <CALCETrXzEPKPFKBeKF3UMduNe1ViQTC6vULEySo_0XTJcK7Qkw@mail.gmail.com>
 <20150112193704.GG3904@pd.tnic> <CALCETrUVXGnqqtgw1eZRK5g0B+5vwGuvSV6dwnm5witA-fJWLQ@mail.gmail.com>
 <20150112201145.GH3904@pd.tnic> <CALCETrVto_uxTz30M8a4XyLk-UXTQXc3CsYxEKJkhmqH=FdvNA@mail.gmail.com>
 <54B42CF2.2030104@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 12 Jan 2015 12:26:38 -0800
Message-ID: <CALCETrUiSEtJ-2MH9LQUnrkhE4=0WEzsiLQTvjNbE=CVqBoO2w@mail.gmail.com>
Subject: Re: [PATCH] x86: introduce push/pop macros which generate
 CFI_REL_OFFSET and CFI_RESTORE
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 12:22 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/12/2015 12:14 PM, Andy Lutomirski wrote:
>> On Mon, Jan 12, 2015 at 12:11 PM, Borislav Petkov <bp@alien8.de> wrote:
>>> On Mon, Jan 12, 2015 at 11:46:53AM -0800, Andy Lutomirski wrote:
>>>> Dumb example:
>>>>
>>>>     pushq_cfi $__KERNEL_DS /* ss */
>>>>
>>>> This doesn't save anything that the unwinder would care about.
>>>
>>> And? The unwinder or whatever looks at that info simply ignores stuff it
>>> is not interested in, no?
>>
>> But CFI_REL_OFFSET $__KERNEL_DS, 0 probably isn't even well-formed and
>> won't build.
>>
>
> I think this is relatively easy to deal with at the expense of a large
> .ifeq statement in the macro.
>
>

Is the usage you have in mind something like:

pushq_cfi %r11 /* saves r11 */
pushq_cfi $0 /* saves nothing */
pushq_cfi %r11, savereg=rip /* saves rip */

I think I prefer the somewhat less magical:

pushq_reg_cfi %r11 /* saves r11 */
pushq_reg_cfi %r11, savereg=rip /* saves rip */
pushq_nounwind_cfi $0

Or something like that.

--Andy

         -hpa
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
