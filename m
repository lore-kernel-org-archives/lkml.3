Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaJGTkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:40:33 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:49541 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbaJGTkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:40:32 -0400
From: Matthew Fortune <Matthew.Fortune@imgtec.com>
To: Andy Lutomirski <luto@amacapital.net>,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: David Daney <david.s.daney@gmail.com>, Rich Felker <dalias@libc.org>,
        David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Subject: RE: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
Thread-Topic: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
Thread-Index: AQHP4aN00Rru6iu58k+v+yCGGiYzx5wje4qAgAAGhYCAAAOMgIAABAuAgAADj4CAABvzgIAAAvcAgAAEkwCAAAfXAIAABHWAgABDfICAAFdDkIAAjnQAgAADP4CAAB08wA==
Date: Tue, 7 Oct 2014 19:40:27 +0000
Message-ID: <6D39441BF12EF246A7ABCE6654B0235320F1EBEE@LEMAIL01.le.imgtec.org>
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com>
 <20141006205459.GZ23797@brightrain.aerifal.cx>
 <5433071B.4050606@caviumnetworks.com>
 <20141006213101.GA23797@brightrain.aerifal.cx>
 <54330D79.80102@caviumnetworks.com>
 <20141006215813.GB23797@brightrain.aerifal.cx>
 <543327E7.4020608@amacapital.net> <54332A64.5020605@caviumnetworks.com>
 <20141007000514.GD23797@brightrain.aerifal.cx>
 <543334CE.8060305@caviumnetworks.com>
 <20141007004915.GF23797@brightrain.aerifal.cx> <54337127.40806@gmail.com>
 <6D39441BF12EF246A7ABCE6654B0235320F1E173@LEMAIL01.le.imgtec.org>
 <543431DA.4090809@imgtec.com>
 <CALCETrUQEbb=DotSzsneN7Hano_eC-EoTMko6uKcyZXvEcktkw@mail.gmail.com>
In-Reply-To: <CALCETrUQEbb=DotSzsneN7Hano_eC-EoTMko6uKcyZXvEcktkw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.159.206]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s97JecYw019320

> >
> > 4)  The voice for doing any instruction emulation in kernel - it is not a
> > MIPS business model to force customer to put details of all Coprocessor 2
> > instructions public. We provide an interface and the rest is a customer
> > business. Besides that it is really painful to make a differentiation
> > between Cavium Octeon and some another CPU instructions with the same
> > opcode. On other side, leaving emulation of their instructions to them is
> > not a wise after having some good way doing that multiple years.
> 
> IMO this is all backwards.  If MIPS customers put proprietary
> instructions into their ISA, they leave out the FPU, and they put a
> proprietary insn in a branch delay slot, then I think that they
> deserve a fatal signal.
> 
> There's a really easy solution for new systems: fix the toolchain.
> Teach the assembler to disallow any proprietary instructions in an FP
> branch delay slot.

I think I'd be mostly in favour of this from a toolchain perspective but
only from the perspective of FP branch instructions. This still leaves a
problem for normal branches should any of them get removed and need emulating.
The general form of bltzal and bgezal would be the example here of branches
which are removed in R6 (The special case of using $0 remains). This is
really niche but my point is more about how we would deal with such a thing
if it happened. The answer may be just to scream and shout and discourage the
removal of such instructions from the architecture.

Matthew

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
