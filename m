Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaCLXn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 19:43:57 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:44844 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaCLXnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 19:43:55 -0400
MIME-Version: 1.0
In-Reply-To: <5320E885.1080402@linux.intel.com>
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>
 <CALCETrXai1eS9FFC=EsxzSy51fMjgEh+zD6meDJiovLirPKf2Q@mail.gmail.com>
 <CA+55aFzB9jjOjxT=m=5t04L3JONe5HhEhuHUXtqDYREmEjQrgQ@mail.gmail.com>
 <531F365B.4060000@linux.intel.com> <CA+55aFxmkBnwDfKhX7h1qoJ3emD=+ugc3OLNDH79a1kGu7He1Q@mail.gmail.com>
 <531F3D02.30706@linux.intel.com> <CALCETrXt5=N7U-f1i+oCkbF5xqc0Qn8U_C9B47grcuEagAhDEA@mail.gmail.com>
 <CALCETrWCXY-hwZh2U4QPp0YeeGuPXFUrUuCn7h-5H+TvdXEq5Q@mail.gmail.com>
 <CA+55aFz+OfvtXLxg4CA4C6GPGh8F_aDuG6nnFFCCBpjTPLP1zA@mail.gmail.com>
 <1394613046.995.51.camel@wall-e.seibold.net> <CA+55aFyTCoipjhbAVCuhCgqb8JeSjGcmOU3xE6EFrjNpfspfqg@mail.gmail.com>
 <CA+55aFxc8Qp-4_+n=upd-ghzkxpjCyRpesm3P7xtWjDyBe9MCw@mail.gmail.com>
 <CA+55aFyhS5jCWcxuK4bXKEPh+8HWbPE+gy1m4N9B-2HyT48+QA@mail.gmail.com>
 <5320D3AB.5060002@linux.intel.com> <CA+55aFzC1Xy1VNF46Mj8V8CEc0tyVA76+631xZiF6nk3Gyvc-Q@mail.gmail.com>
 <CALCETrUGc5+CS8=sYvtkK967ZR833zu98rzRkEw_DX++1hL-BA@mail.gmail.com> <5320E885.1080402@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Mar 2014 16:43:34 -0700
Message-ID: <CALCETrXbgHMPU7in4ThRWyRTw4EN4W9vYOh1RKAiBLFTauxrRQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 4:06 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 03/12/2014 02:49 PM, Andy Lutomirski wrote:
>> On Wed, Mar 12, 2014 at 2:46 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> On Wed, Mar 12, 2014 at 2:37 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>>>
>>>> How would that deal with the legacy vsyscall case for x86-64?  Just rely
>>>> on the "legacy vsyscall emulation" (which seems to have its own class of
>>>> problems...)?
>>>
>>> It does?
>>>
>>> We *default* to emulation, and have for over two years now (since
>>> v3.4).  If there are problems with it, we need to fix those.
>>
>> Even in the non-default "vsyscall=native" case, the vsyscall pages
>> just contains syscalls.  It does not need to access the vvar page, the
>> hpet, or anything else that the vdso uses.
>>
>
> Ah, right.  I let that detail slip the mind.
>
> I do hear vsyscall=native still being used as a workaround for problems,
> but yes, just making it call the kernel is fine, of course.

Next time you hear that, can you let me know?  I haven't heard of any
issues since 3.4 IIRC.

--Andy

>
> So yes, this does make it all better.
>
>         -hpa
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
