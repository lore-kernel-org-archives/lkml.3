Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaCKQqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:46:15 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:40216 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaCKQqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:46:13 -0400
MIME-Version: 1.0
In-Reply-To: <531F3D02.30706@linux.intel.com>
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>
 <CA+55aFwaWgb-hCfOf8Y_LA+ZAHpTFYU937XN=7T6SxDAdpPzcg@mail.gmail.com>
 <CALCETrUe0TjzjEo-N2GZkD9DiVbtjretGjTVqiv7U+ZJerWLXQ@mail.gmail.com>
 <CA+55aFydgX7yejyPq0ckuXabEFhjXO960F=L0-+yYNT=U=Madg@mail.gmail.com>
 <CALCETrXd_7K2rc-JPDFtxQWE+ZURzY6qfOLR9DDtjp-nBG1Sgg@mail.gmail.com>
 <CA+55aFzPntnPHCbNa6PNdeKQmFBsF4JNu0BHix8LsP2ybYQ-Yg@mail.gmail.com>
 <CALCETrXai1eS9FFC=EsxzSy51fMjgEh+zD6meDJiovLirPKf2Q@mail.gmail.com>
 <CA+55aFzB9jjOjxT=m=5t04L3JONe5HhEhuHUXtqDYREmEjQrgQ@mail.gmail.com>
 <531F365B.4060000@linux.intel.com> <CA+55aFxmkBnwDfKhX7h1qoJ3emD=+ugc3OLNDH79a1kGu7He1Q@mail.gmail.com>
 <531F3D02.30706@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Mar 2014 09:45:52 -0700
Message-ID: <CALCETrXt5=N7U-f1i+oCkbF5xqc0Qn8U_C9B47grcuEagAhDEA@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefani Seibold <stefani@seibold.net>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 9:42 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 03/11/2014 09:30 AM, Linus Torvalds wrote:
>>
>> No, the trivial solution is to stop adding crap to it.
>>
>> And no, "just reserve a little more space for it" is neither trivial
>> nor a good idea. The fixed VDSO address is very much at the top of the
>> address space, so you can't allocate more space for it unless you do
>> one of
>>
>>  (a) make it non-contiguous
>>  (b) get rid of the hole that is the very last page
>>  (c) mess with the vsyscall pages and make it contiguous "backwards"
>>
>> all of which sound like *horrible* ideas. Certainly not "trivial solution".
>>
>> No, the trivial solution is to not mess with that legacy page at all.
>>
>> Why is *that* trivial solution not on the table? Why the heck are
>> people hell-bent on changing this stupid legacy page around?
>>
>> I find this whole thread very annoying. We shouldn't care about
>> x86-32, and certainly not from a performance angle - we should
>> consider it a "it's done, don't touch it" issue.
>>
>
> Andy actually did the research, and found that even the legacy VDSO
> doesn't have to live at any one particular address, it just has to live
> at the address it is linked at.  So we can move it just fine, but we
> have to change the link address to match.
>
> That gives us a lot more maneuvering room than saying it has to be at
> one specific address.
>

We could even just relocate the damn thing wherever it ends up.  That
will waste one page of memory per process, though.

--Andy
