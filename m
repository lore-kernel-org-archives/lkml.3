Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaIXTeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:34:50 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:63483 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaIXTet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:34:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140924185934.GB16214@khazad-dum.debian.net>
References: <20140919110014.GC29639@khazad-dum.debian.net> <20140919112953.GA3256@nazgul.tnic>
 <20140919075415.5149d5f2@as> <20140919150042.GC5318@nazgul.tnic>
 <20140919164217.GD17456@khazad-dum.debian.net> <20140923200054.GB16467@pd.tnic>
 <20140924145658.GB31678@khazad-dum.debian.net> <CALCETrU3-iNqCOT7EArtB91zAZC6ChuVN1wF6LbtdUqpoyJ+ig@mail.gmail.com>
 <20140924174557.GD31678@khazad-dum.debian.net> <CALCETrXz1aGqqUiczykeHhxSSRhEZ=qnj-RsyFhoz565YTKEpw@mail.gmail.com>
 <20140924185934.GB16214@khazad-dum.debian.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 24 Sep 2014 12:34:28 -0700
Message-ID: <CALCETrUUWHnRNvmXaQrjpRcGrBC_N2OFSyner_e-HEdAyk07rg@mail.gmail.com>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Borislav Petkov <bp@alien8.de>, Chuck Ebbert <cebbert.lkml@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:59 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Wed, 24 Sep 2014, Andy Lutomirski wrote:
>> We can sort of fudge it if whatever control BIOS uses is available to
>> us, too, and we can reprogram it to "enabled" after a microcode update
>> disables TSX.
>
> Only for the early initramfs microcode update driver, and that's going to be
> useful only as a way to honor the "keep Intel TSX enabled even if it is
> badly broken" switch that was added by Intel for developer usage.
>
> For the runtime microcode update (regular microcode driver), an
> "enabled->disabled->enabled" transition would still disrupt the system:
> triggering a microcode update in a cpu can update other cpus, which might be
> running Intel TSX instructions.  Boom! processes running on these other cpus
> can crash with SIGILL, and we have data loss.
>
> The microcode update has to preserve the entire [visible] processor state,
> otherwise we cannot safely apply it "late".  Intel TSX included.

Ugh, right.

If we knew the set of CPUs that would be affected by a given update,
we could freeze those CPUs first, though.  But yes, this sucks.

--Andy

>
> --
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh



-- 
Andy Lutomirski
AMA Capital Management, LLC
