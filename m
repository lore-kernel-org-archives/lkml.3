Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaIXRtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:49:20 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:33960 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaIXRtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:49:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140924174557.GD31678@khazad-dum.debian.net>
References: <20140919001311.GB5331@khazad-dum.debian.net> <CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com>
 <20140919110014.GC29639@khazad-dum.debian.net> <20140919112953.GA3256@nazgul.tnic>
 <20140919075415.5149d5f2@as> <20140919150042.GC5318@nazgul.tnic>
 <20140919164217.GD17456@khazad-dum.debian.net> <20140923200054.GB16467@pd.tnic>
 <20140924145658.GB31678@khazad-dum.debian.net> <CALCETrU3-iNqCOT7EArtB91zAZC6ChuVN1wF6LbtdUqpoyJ+ig@mail.gmail.com>
 <20140924174557.GD31678@khazad-dum.debian.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 24 Sep 2014 10:48:57 -0700
Message-ID: <CALCETrXz1aGqqUiczykeHhxSSRhEZ=qnj-RsyFhoz565YTKEpw@mail.gmail.com>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Borislav Petkov <bp@alien8.de>, Chuck Ebbert <cebbert.lkml@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:45 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Wed, 24 Sep 2014, Andy Lutomirski wrote:
>> On Wed, Sep 24, 2014 at 7:56 AM, Henrique de Moraes Holschuh
>> <hmh@hmh.eng.br> wrote:
>> > And I'd really prefer it to be "update x86_capability, warn the user and
>> > carry on" for anything that is not going to crash the kernel.  Several
>> > distros will really want this backported to -stable, as the older kernels
>> > cannot do early microcode updates.
>> >
>>
>> I'm trying to see if Intel is willing to document any additional
>> controls for the TSX bits in this ucode.  No word yet, but I might
>> hear something soon.
>
> If they do document it, please make sure to ask what will happen in the
> following situation:
>
>    Assume there is a newer release of Intel microcode for these
>    processors, i.e. newer than the microcodes in the 2014-09-13 release.
>    IOW assume there are at least two public microcode updates in which the
>    Intel TSX feature has been disabled by default, but can be enabled by
>    the BIOS/UEFI.
>
>    1. BIOS/UEFI has recent microcode (which has the Intel TSX on/off
>       switch), but it is not the latest microcode, and installed this
>       update on the processor.
>
>    2. BIOS/UEFI has *enabled* Intel TSX on user request.
>
>    3. Microcode is updated to the latest microcode by the operating
>       system, newer than the one in BIOS/UEFI.
>
>    After step 3, will Intel TSX be enabled, or disabled ?
>
> Or, to be more explicit: will future microcode updates preserve Intel TSX
> enabled/disabled state, or will they always reset it to disabled?
>
> This is really important, for obvious reasons.
>

Indeed.

We can sort of fudge it if whatever control BIOS uses is available to
us, too, and we can reprogram it to "enabled" after a microcode update
disables TSX.

If I had one of the affected chips, I'd try scanning the MSR space to
see if a new MSR appears after applying the update.  But I don't, so I
can't do this.

--Andy
