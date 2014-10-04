Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaJDPdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 11:33:44 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:51466 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaJDPdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 11:33:43 -0400
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Zubair Kakakhel <Zubair.Kakakhel@imgtec.com>,
        "david.daney@cavium.com" <david.daney@cavium.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "davidlohr@hp.com" <davidlohr@hp.com>,
        "macro@linux-mips.org" <macro@linux-mips.org>,
        "chenhc@lemote.com" <chenhc@lemote.com>,
        "zajec5@gmail.com" <zajec5@gmail.com>,
        James Hogan <James.Hogan@imgtec.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "alex@alex-smith.me.uk" <alex@alex-smith.me.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "blogic@openwrt.org" <blogic@openwrt.org>,
        "jchandra@broadcom.com" <jchandra@broadcom.com>,
        Paul Burton <Paul.Burton@imgtec.com>,
        Qais Yousef <Qais.Yousef@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        Markos Chandras <Markos.Chandras@imgtec.com>,
        "manuel.lauss@gmail.com" <manuel.lauss@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "lars.persson@axis.com" <lars.persson@axis.com>
Subject: Re: [PATCH 0/3] MIPS executable stack protection
Thread-Topic: [PATCH 0/3] MIPS executable stack protection
Thread-Index: Ac/f6JBasxw0os/VaEewjedDoGfZbg==
Date: Sat, 4 Oct 2014 15:33:36 +0000
Message-ID: <tg3ek4qtursbob5wootj8r09.1412436788097@email.android.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC282DA7E8B50048996C8C67EAC32EE2@imgtec.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s94FXnUP024427

Peter Zijlstra wrote:

>> It sets up a per-thread 'VDSO' page and appropriate TLB support.

> So traditionally we've always avoided per-thread pages like that.
> What makes it worth it on MIPS?

MIPS has branch delay slots - it is an instruction after branch which is executed
before branch is taken. If branch fails due to FPU unavailability then that
instruction should be emulated as well as branch itself.
However, MIPS allows to have a customisable coprocessor 2 instructions
and it is impractical to emulate it and big amount of other traditional MIPS
instructions inside of kernel.

So, some per thread space is needed to put instruction into it, enclose it with
a return kernel call and switch temporary execution into it.

Currently, this space is space at SP register (user stack) but it prevents
switching stack as non-executable.

Handle another stack set (one stack per thread) in common user map is
impractical because of management, scalability and performance difficulties.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
